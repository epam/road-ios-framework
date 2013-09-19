//
//  SFNetLogWriter.m
//  SparkLogger
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

#import <SystemConfiguration/SystemConfiguration.h>
#import "SFNetLogWriter.h"
#import "SFLogMessage.h"
#import "SFLogMessageWrapper.h"
#import "SFStreamWriter.h"
#import "SFConnection.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

static NSString * const kSFNetLogServiceType = @"_appalocalnetwork._tcp.";
static NSString * const kCFBundleDisplayName = @"CFBundleDisplayName";

@interface SFNetLogWriter () {
    SFConnection *connection;
    NSMutableArray *serviceNames;
    NSString *uniqueIdForSession;
    NSString *ipAddress;
    NSString *applicationName;
}

@property (strong, nonatomic) SFStreamWriter *streamWriter;

@end

@implementation SFNetLogWriter

@synthesize delegate;
@synthesize streamWriter;

// Initiates a connection to browse for possible network services, creates a unique id for the logging session
- (id)init {
    
    self = [super init];
    
    if (self) {
        
        applicationName = [[NSBundle mainBundle] infoDictionary][kCFBundleDisplayName];
        connection = [[SFConnection alloc] initWithType:kSFNetLogServiceType applicationName:applicationName];
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

- (void)logValidMessage:(SFLogMessage * const)aMessage {
    SFLogMessageWrapper *wrapper = [[SFLogMessageWrapper alloc] initWithMessage:aMessage deviceName:[self deviceName] applicationName:applicationName uniqueId:uniqueIdForSession];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeRootObject:wrapper];
    [archiver finishEncoding];
    [streamWriter writeData:data];
}

- (void)logQueue {
    dispatch_async(self.queue, ^{
        NSMutableArray *messageWrappers = [[NSMutableArray alloc] initWithCapacity:[self.messageQueue count]];
                
        for (SFLogMessage *message in self.messageQueue) {
            SFLogMessageWrapper *wrapper = [[SFLogMessageWrapper alloc] initWithMessage:message deviceName:[self deviceName] applicationName:applicationName uniqueId:uniqueIdForSession];            
            [messageWrappers addObject:wrapper];
        }
        
        [self.messageQueue removeAllObjects];
        
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeRootObject:messageWrappers];
        [archiver finishEncoding];
        [streamWriter writeData:data];
    });
}


- (void)dealloc {
    connection.delegate = nil;
}

#pragma mark - Connection delegates

// Updates the streamwriter with the available services and informs the delegate about the names of the connected services
- (void)connection:(SFConnection *)connection didFindServices:(NSSet *)services {
    
    streamWriter = [[SFStreamWriter alloc] initWithServices:services];
    serviceNames = [NSMutableArray array];
    
    for (NSNetService *aService in services) {
        [serviceNames addObject:[aService name]];
    }
    
    if ([delegate respondsToSelector:@selector(logWriter:availableServiceNames:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate logWriter:self availableServiceNames:serviceNames];
        });
    }
}

// Removes a service when it is no longer available
- (void)connection:(SFConnection *)connection willRemoveService:(NSNetService *)service {
    [serviceNames removeObject:[service name]];
    
    if ([delegate respondsToSelector:@selector(logWriter:availableServiceNames:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate logWriter:self availableServiceNames:serviceNames];
        });
    }
    
    [streamWriter removeService:service];
}

// Creates a device name
- (NSString *)deviceName {
#warning FIX ME
    /*
    NSString *result = [[UIDevice currentDevice] name];
    
    if ([result hasSuffix:@"Simulator"]) {
        result = [result stringByAppendingFormat:@"_%@", [self ipAddress]];
    }
    return result;
     */
    return @"FIX-ME-NAME";
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
            
            // Check if interface is en0 which is the wifi connection on the iPhone
            // it may also be en1 on your ipad3.
            if((temp_addr->ifa_addr->sa_family == AF_INET) && ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])) {
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
