#Observation
Component provides unified interface to Cocoa Notifications and KVO with **Blocks**-based callbacks.

Unification is made at levels of:

* Callback Blocks

		void (^SFKeyValueHandlerBlock)(id oldValue, id newValue);
		void (^SFNotificationHandlerBlock)(NSNotification * const notification);
* Class names of observation wrappers: `SFObserver` and `SFOObserverWrapper` for KVO and Notifications respectively.


##1. Key-Value Observing
`SFObserver` provides factory method

	+ (SFObserver *)observerForTarget:(id const)aTarget keyPath:(NSString * const)aKeypath handler:(SFKeyValueHandlerBlock)aHandler;
	
for easy KVO subscription. It adds `aHandler` of `SFKeyValueHandlerBlock` type to a set of KVO params and returns `SFObserver` instance which should be retained until subscription is needed.

`SFObserver` will unsubscribe itself when deallocated.

##2. Cocoa Notifications
`SFObserverWrapper` provides the similar to `SFObserver` behavior as a subscription owning object. It can be created by factory:

	+ (SFObserverWrapper *)observerForName:(NSString *const)aName queue:(const dispatch_queue_t)aQueue handler:(SFNotificationHandlerBlock const)handler;

with options to set queue for the callback exexution.
or several convenience methods.

Wrapper has boolean `async` (default = YES) property to define whether dispatch callbacks synchronously or asynchronously. 









