//
//  NLLogListenerService.h
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


#import <Foundation/Foundation.h>

@class NLLogMessageWrapper;

/**
 Delegate protocol.
 */
@protocol NLLogListenerServiceDelegate <NSObject>

/**
 Informs the delegate that a new message has been received.
 */
- (void)didReceiveLogMessage:(NLLogMessageWrapper *)logMessageWrapper;

/**
 Informs the delegate that the connection with the unique id will stop.
 */
- (void)willTerminateConnectionWithUniqueId:(NSString *)uniqueId;

@end

/**
 This class is used to handle the publication of network services and allocate new service operations for each new connection.
 */
@interface NLLogListenerService : NSObject

/**
 The name of the service.
 */
@property (nonatomic, copy) NSString *serviceName;

/**
 Boolean property indicating if the given service was running.
 */
@property (nonatomic, readonly) BOOL running;

/**
 The delegate property.
 */
@property (nonatomic, weak) NSObject <NLLogListenerServiceDelegate> *delegate;

/**
 The operation queue used to keep the netserive operations alive. Whenever a new connection is found, a new operation is allocated and placed in the queue to run
 concurrently with the rest of the already started operations.
 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/**
 Starts the service.
 */
- (void)startService;

/**
 Stops the service.
 */
- (void)stopService;

@end
