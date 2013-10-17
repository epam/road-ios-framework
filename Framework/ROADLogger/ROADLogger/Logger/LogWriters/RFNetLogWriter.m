//
//  RFNetLogWriter.m
//  ROADLogger
//
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
// list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "RFNetLogWriter.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#import "RFLogMessage.h"
#import "RFLogMessageWrapper.h"
#import "RFStreamWriter.h"
#import "RFConnection.h"

static NSString * const kRFNetLogServiceType = @"_appalocalnetwork._tcp.";
static NSString * const kCFBundleDisplayName = @"CFBundleDisplayName";

@interface RFNetLogWriter () {
    RFConnection *connection;
    NSMutableArray *serviceNames;
    NSString *uniqueIdForSession;
    NSString *ipAddress;
    NSString *applicationName;
}

@property (strong, nonatomic) RFStreamWriter *streamWriter;

@end

@implementation RFNetLogWriter

@synthesize delegate = _delegate;
@synthesize streamWriter = _streamWriter;

// Initiates a connection to browse for possible network services, creates a unique id for the logging session
- (id)init {
    
    self = [super init];
    
    if (self) {
        
        applicationName = [[NSBundle mainBundle] infoDictionary][kCFBundleDisplayName];
        connection = [[RFConnection alloc] initWithType:kRFNetLogServiceType applicationName:applicationName];
        connection.delegate = self;
        [connection start];
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uniqueId = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        uniqueIdForSession = (__bridge NSString *)uniqueId;
        CFRelease(uniqueId);
    }
    return self;
}

- (void)logValidMessage:(RFLogMessage * const)aMessage {
    RFLogMessageWrapper *wrapper = [[RFLogMessageWrapper alloc] initWithMessage:aMessage deviceName:[self deviceName] applicationName:applicationName uniqueId:uniqueIdForSession];
    [self writeObjectWithSteamWriter:wrapper];
}

- (void)logQueue {
    dispatch_async(self.queue, ^{
        NSMutableArray *messageWrappers = [[NSMutableArray alloc] initWithCapacity:[self.messageQueue count]];
                
        for (RFLogMessage *message in self.messageQueue) {
            RFLogMessageWrapper *wrapper = [[RFLogMessageWrapper alloc] initWithMessage:message deviceName:[self deviceName] applicationName:applicationName uniqueId:uniqueIdForSession];            
            [messageWrappers addObject:wrapper];
        }
        
        [self.messageQueue removeAllObjects];
        
        [self writeObjectWithSteamWriter:messageWrappers];
    });
}

- (void)writeObjectWithSteamWriter:(id)object {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeRootObject:object];
    [archiver finishEncoding];
    [_streamWriter writeData:data];
}

- (void)dealloc {
    connection.delegate = nil;
}

#pragma mark - Connection delegates

// Updates the streamwriter with the available services and informs the delegate about the names of the connected services
- (void)connection:(RFConnection *)connection didFindServices:(NSSet *)services {
    
    _streamWriter = [[RFStreamWriter alloc] initWithServices:services];
    serviceNames = [NSMutableArray array];
    
    for (NSNetService *aService in services) {
        [serviceNames addObject:[aService name]];
    }
    
    if ([_delegate respondsToSelector:@selector(logWriter:availableServiceNames:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate logWriter:self availableServiceNames:serviceNames];
        });
    }
}

// Removes a service when it is no longer available
- (void)connection:(RFConnection *)connection willRemoveService:(NSNetService *)service {
    [serviceNames removeObject:[service name]];
    
    if ([_delegate respondsToSelector:@selector(logWriter:availableServiceNames:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate logWriter:self availableServiceNames:serviceNames];
        });
    }
    
    [_streamWriter removeService:service];
}

// Creates a device name
- (NSString *)deviceName {
    NSString *result = [[UIDevice currentDevice] name];
    
    if ([result hasSuffix:@"Simulator"]) {
        result = [result stringByAppendingFormat:@"_%@", [self ipAddress]];
    }
    return result;
}

// Returns the IP address of the device
- (NSString *)getIPAddress {
    NSString *address = @"error"; 
    struct ifaddrs *interfaces = NULL; 
    struct ifaddrs *temp_addr = NULL; 
    int success = 0; 
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces); 
    
    if (success == 0) { 
        // Loop through linked list of interfaces 
        
        temp_addr = interfaces; 
        while(temp_addr != NULL) { 
            
            BOOL checkAddr = (temp_addr->ifa_addr->sa_family == AF_INET);
            
            // Check if interface is en0 which is the wifi connection on the iPhone
            // it may also be en1 on your ipad3.
            BOOL checkIntreface = ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]);
            
            if(checkAddr && checkIntreface) {
                // Get NSString from C String
                address = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr));
            }
            
            temp_addr = temp_addr->ifa_next; 
        }
    } 
    
    // Free memory 
    freeifaddrs(interfaces);
    return address; 
}

// Stores the IP address so it only has to be fetched once per session
- (NSString *)ipAddress {
    if (ipAddress == nil) {
        ipAddress = [self getIPAddress];
    }
    return ipAddress;
}

@end
