#Observation
Component provides unified interface to Cocoa Notifications and KVO with **Blocks**-based callbacks.

Unification is made at levels of:

* Callback Blocks

  ```objc
void (^RFKeyValueHandlerBlock)(id oldValue, id newValue);
void (^RFNotificationHandlerBlock)(NSNotification * const notification);
  ```
* Class names of observation wrappers: `RFObserver` and `RFOObserverWrapper` for KVO and Notifications respectively.


##1. Key-Value Observing
`RFObserver` provides factory method
```objc
+ (RFObserver *)observerForTarget:(id const)aTarget keyPath:(NSString * const)aKeypath handler:(RFKeyValueHandlerBlock)aHandler;
```	
for easy KVO subscription. It adds `aHandler` of `RFKeyValueHandlerBlock` type to a set of KVO params and returns `RFObserver` instance which should be retained until subscription is needed.

`RFObserver` will unsubscribe itself when deallocated.

##2. Cocoa Notifications
`RFObserverWrapper` provides the similar to `RFObserver` behavior as a subscription owning object. It can be created by factory:
```objc
+ (RFObserverWrapper *)observerForName:(NSString *const)aName queue:(const dispatch_queue_t)aQueue handler:(RFNotificationHandlerBlock const)handler;
```
with options to set queue for the callback execution.
or several convenience methods.

Wrapper has boolean `async` (default = YES) property to define whether dispatch callbacks synchronously or asynchronously. 