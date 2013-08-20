//
//  NLLogListenerService.m
//  NetLog-Listener
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


#import "NLLogListenerService.h"
#import "NLStreamOperation.h"
#import "NLLogMessageWrapper.h"
#import "ACLogMessage.h"
#include <netinet/in.h>
#include <arpa/inet.h>

NSString *const kNetServiceDomain  = @"";
NSString *const kNetServiceType = @"_appalocalnetwork._tcp.";
const NSInteger kMaxConcurrentOperationCount = 100;

@interface NLLogListenerService () <NSNetServiceDelegate, NLStreamOperationDelegate>

- (void)connectionReceived:(int)fd;

- (void)makeSocket:(int *)fdForListening error:(int *)error;

- (void)makeBind:(int)fdForListening serverAddress:(struct sockaddr_in *)serverAddress error:(int *)error;

- (void)setPort:(socklen_t *)namelen fd:(int)fdForListening serverAddress:(struct sockaddr_in *)serverAddress port:(int *)chosenPort error:(int *)error;

- (void)listenAndSchedule:(int *)fdForListening error:(int *)error;

- (void)publish:(int)chosenPort;

- (void)cleanup:(int)fdForListening;

@end

@implementation NLLogListenerService {
    BOOL running;
    CFSocketRef listeningSocket;
    NSNetService *netService;
    NSOperationQueue *operationQueue;
}

@synthesize serviceName;
@synthesize running;
@synthesize delegate;
@synthesize operationQueue;

#pragma mark -
#pragma mark LifeCycle
#pragma mark -

- (id)init {
    self = [super init];
    
    if (self) {
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:kMaxConcurrentOperationCount];
    }
    
    return self;
}

- (void)dealloc {
    [self stopService];
}

#pragma mark -
#pragma mark Public methods
#pragma mark -

- (void)startService {
    int error;
    int fdForListening;
    int chosenPort;
    socklen_t namelen;
    struct sockaddr_in serverAddress;
    
    assert(!running);
    assert(listeningSocket == NULL);
    assert(netService == nil);
    
    chosenPort = -1;
    error = 0;

    [self makeSocket:&fdForListening error:&error];
    
    if (error == 0) {
        [self makeBind:fdForListening serverAddress:&serverAddress error:&error];
    }
    
    if (error == 0) {
        [self setPort:&namelen fd:fdForListening serverAddress:&serverAddress port:&chosenPort error:&error];
    }
        
    if (error == 0) {
        [self listenAndSchedule:&fdForListening error:&error];
    }
        
    if (error == 0) {
        [self publish:chosenPort];
    }

    [self cleanup:fdForListening];
}

- (void)stopService {
    [operationQueue cancelAllOperations];
    
    if (netService != nil) {
        [netService setDelegate:nil];
        [netService stop];
        netService = nil;
    }
    
    if (listeningSocket != NULL) {
        CFSocketInvalidate(listeningSocket);
        CFRelease(listeningSocket);
        listeningSocket = NULL;
    }
    
    running = NO;
}

#pragma mark -
#pragma mark Socket callback
#pragma mark -

static void ListeningSocketCallback(CFSocketRef socket, CFSocketCallBackType callbackType, CFDataRef address, const void *data, void *info) {
    NLLogListenerService* listenerService = (__bridge NLLogListenerService *) info;
    int fd = *(const int *)data;
    
    assert([listenerService isKindOfClass:[NLLogListenerService class]]);
    assert(socket == listenerService->listeningSocket);
    assert(callbackType == kCFSocketAcceptCallBack);
    assert(address != NULL);
    assert(data != nil);
    assert(fd >= 0);

    [listenerService connectionReceived:fd];
}

#pragma mark -
#pragma mark Class extensions
#pragma mark -

- (void)connectionReceived:(int)fd {
    CFReadStreamRef readStream = NULL;
    BOOL success = NO;
    
    assert(fd >= 0);
    
    CFStreamCreatePairWithSocket(NULL, fd, &readStream, NULL);
    assert(readStream != nil);
    
    NSInputStream *inputStream = (__bridge NSInputStream *)readStream;
    
    success = [inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    assert(success);
	
    NLStreamOperation *streamOperation = [[NLStreamOperation alloc] initWithInputStream:inputStream];
    [streamOperation setDelegate:self];
    
    [operationQueue addOperation:streamOperation];

    CFRelease(readStream);
}

- (void)makeSocket:(int *)fdForListening error:(int *)error {
    *fdForListening = socket(AF_INET, SOCK_STREAM, 0);
    
    if (*fdForListening < 0) {
        *error = errno;
    }
}

- (void)makeBind:(int)fdForListening serverAddress:(struct sockaddr_in *)serverAddress error:(int *)error {
    memset(serverAddress, 0, sizeof(*serverAddress));
    serverAddress->sin_family = AF_INET;
    serverAddress->sin_len = sizeof(*serverAddress);
    
    *error = bind(fdForListening, (struct sockaddr *)serverAddress, sizeof(*serverAddress));
    
    if (*error < 0) {
        *error = errno;
    }
}

- (void)setPort:(socklen_t *)namelen fd:(int)fdForListening serverAddress:(struct sockaddr_in *)serverAddress port:(int *)chosenPort error:(int *)error  {
    *namelen = sizeof(*serverAddress);
    *error = getsockname(fdForListening, (struct sockaddr *)serverAddress, namelen);
    
    if (*error < 0) {
        *error = errno;
        assert(*error != 0);
    } else {
        *chosenPort = ntohs(serverAddress->sin_port);
    }
}

- (void)listenAndSchedule:(int *)fdForListening error:(int *)error {
    *error = listen(*fdForListening, 5);
    
    if (*error < 0) {
        *error = errno;
    } else {
        CFSocketContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
        CFRunLoopSourceRef rls;
        
        listeningSocket = CFSocketCreateWithNative(NULL, *fdForListening, kCFSocketAcceptCallBack, ListeningSocketCallback, &context);
        
        if (listeningSocket != NULL) {
            assert(CFSocketGetSocketFlags(listeningSocket) & kCFSocketCloseOnInvalidate);
            *fdForListening = -1;
            
            rls = CFSocketCreateRunLoopSource(NULL, listeningSocket, 0);
            assert(rls != NULL);
            
            CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
            
            CFRelease(rls);
        }
    }
}

- (void)publish:(int)chosenPort {
    netService = [[NSNetService alloc] initWithDomain:kNetServiceDomain type:kNetServiceType name:serviceName port:chosenPort];
    
    assert(netService != nil);
    
    if (netService != nil) {
        [netService setDelegate:self];
        [netService publishWithOptions:0];
    }
}

- (void)cleanup:(int)fdForListening {
    int junk;
    
    if ((listeningSocket != NULL) && (netService != nil)) {
        running = YES;
    } else {
        [self stopService];
    }
    
    if (fdForListening >= 0) {
        junk = close(fdForListening);
        assert(junk == 0);
    }
}

#pragma mark -
#pragma mark NSNetServiceDelegate
#pragma mark -

- (void)netServiceDidPublish:(NSNetService *)sender {
    assert(sender == netService);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    assert(sender == netService);
    [self stopService];
}

- (void)netServiceDidStop:(NSNetService *)sender {
    assert(sender == netService);
    [self stopService];
}

#pragma mark -
#pragma mark NLStreamOperationDelegate
#pragma mark -

- (void)finishedReadingLogMessage:(NLLogMessageWrapper *)logMessageWrapper {
    
    dispatch_async(dispatch_get_main_queue(), ^{ 
        [delegate didReceiveLogMessage:logMessageWrapper];
    });
}

- (void)streamOperation:(NLStreamOperation *)operation willCloseConnectionWithUniqueId:(NSString *)connectionUniqueId {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [delegate willTerminateConnectionWithUniqueId:connectionUniqueId];
    });
}

@end
