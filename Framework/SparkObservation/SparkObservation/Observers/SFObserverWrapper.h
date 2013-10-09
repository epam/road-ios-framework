//
//  SFObserverWrapper.h
//  ROADObservation
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

extern NSString * const kSFNotificationNameViolationException;
extern NSString * const kSFNotificationNameViolationExceptionReason;
extern NSString * const kSFNotificationOldNameKey;
extern NSString * const kSFNotificationNewNameKey;

/**
 The notification handler block. It takes a notification as an argument, and has no return value.
 */
typedef void (^SFNotificationHandlerBlock)(NSNotification * const notification);

/**
 Wrapper around the observer pattern implementation for notifications. The class handles automatic unsubscription.
 */
@interface SFObserverWrapper : NSObject

/**
 References to the object specified (if any) from which the notification should be accepted. If no object-based filtering is applied, this property is nil.
 */
@property (weak, nonatomic) id notificationObject;

/**
 References the name of the notification. Once the observer is subscribed to the notification, changing the name will throw an exception.
 */
@property (copy, nonatomic) NSString *name;

/**
 Boolean value telling if triggering the observer executes the handler block in a sync or async manner. Can be set at any time. The default value is YES.
 */
@property (assign, nonatomic, getter = isAsync) BOOL async;

/**
 The designated initializer.
 @param aName The name of the notification.
 @param anObject The object from which the notification is expected. Can be nil, in which case any object sending the notification will trigger the observer.
 @param aQueue The dispatch queue on which to execute the handler block.
 @param handler The handler block to execute when a notification is receiver.
 @result The initialized observer instance.
 */
- (id)initWithName:(NSString *const)aName object:(const id)anObject queue:(const dispatch_queue_t)aQueue handler:(SFNotificationHandlerBlock)handler;


/**
 Factory method to create a wrapper for a given notification. The block will be invoked on the current thread.
 @param aName The name of the notification to subscribe the observer to.
 @param anObject The object from which the notification should be accepted.
 @param handler The handler block to invoke in case a notification is received.
 @result An observer subscribed to the notification.
 */
+ (SFObserverWrapper *)observerForName:(NSString * const)aName object:(const id)anObject handler:(SFNotificationHandlerBlock const)handler;

/**
 Factory method to create a wrapper for a given notification.
 @param aName The name of the notification to subscribe the observer to.
 @param anObject The object from which the notification should be accepted.
 @param aQueue A dispatch queue object to which the handler block is passed upon a notification.
 @param handler The handler block to invoke in case a notification is received.
 @result An observer subscribed to the notification.
 */
+ (SFObserverWrapper *)observerForName:(NSString * const)aName object:(const id)anObject queue:(const dispatch_queue_t)aQueue handler:(SFNotificationHandlerBlock const)handler;

/**
 Factory method to create a wrapper for a given notification. The results are the same as if one would invoke the +observerForName:object:handler: method with the object argument as nil.
 @param aName The name of the notification to subscribe the observer to.
 @param handler The handler block to invoke in case a notification is received.
 @result An observer subscribed to the notification.
 */
+ (SFObserverWrapper *)observerForName:(NSString * const)aName handler:(SFNotificationHandlerBlock const)handler;

/**
 Factory method to create a wrapper for a given notification. The results are the same as if one would invoke the +observerForName:object:queue:handler: method with the object argument as nil.
 @param aName The name of the notification to subscribe the observer to.
 @param aQueue A dispatch queue object to which the handler block is passed upon a notification.
 @param handler The handler block to invoke in case a notification is received.
 @result An observer subscribed to the notification.
 */
+ (SFObserverWrapper *)observerForName:(NSString *const)aName queue:(const dispatch_queue_t)aQueue handler:(SFNotificationHandlerBlock const)handler;

@end
