# RFLogger

RFLogger is intended to replace `NSLog`/`fprintf`-based logging on iOS projects in a configurable industry-standard way. 

It features:

* Log levels and filtering 
* Formatting output
* Output to console, file and network services

## Basic usage
```objc
#import <ROADLogger.h>
...
RFLogInfo(@"Test message with %@, %i, %i", @"Param 1", "2", YES);
```
already takes and advantage of log leveling and attributes configured in shared instance of logger. Full call will look like: 
```objc
[[RFServiceProvider logger]  logInfoMessage:@"Simple message"];
```
but before writing this code you should configure logger:
```objc
id <RFLogging> logger = [RFServiceProvider logger];
[logger addWriter:[RFConsoleLogWriter plainConsoleWriter]];
```
*`RFServiceProvider` used as a logger singleton provider.*  

Convinience macros are defined for all 4 levels:
`RFLogInfo`, `RFLogDebug`, `RFLogWarning`, `RFLogError`.

We can set necessary log level for all log writers:
```objc
[[RFServiceProvider logger] setLogLevel:RFLogLevelDebug];
```
## Mutliple outputs, filters and formatting

##### Writers
Writers represent output for the message. 3 types of outputs included from the box: console, file and network.

Base writer implementation has a **background message queing**. This minimizes performance impact but should also be taken in account when other logging/tracing technologies are used simultaneously.

##### Multiple outputs:
Logger configured with 3 different writers at one log level. 
```objc
id <RFLogging> logger = [RFServiceProvider logger];
[logger setLogLevel:RFLogLevelInfo];
logger.writers = @[[RFConsoleLogWriter new], [RFConsoleLogWriter plainConsoleWriter], [RFFileLogWriter fileWriterWithPath:filePath]];
    
RFLogDebug(@"text message text message text message");
RFLogInfo(@"text message text message text message");
```
Messages in `RFLogDebug` and `RFLogInfo`  will be logged twice in console and one time in file.

##### Formatted logging:
Create formatter with comparison block and add it to writer instance. 
```objc
NSString *message1 = @"It's right";
NSString *message2 = @"It's not right";
NSString *symbol = @"not ";
    
RFLogWriter *writer = [RFLogWriter plainConsoleWriter];
writer.formatter = [RFLogFormatter formatterWithBlock:^NSString *(RFLogMessage *const message) {
    if ([message.message rangeOfString:symbol].location == NSNotFound) {
        return message.message;
    } else {
        return [message.message stringByReplacingOccurrencesOfString:symbol withString:@""];
    }
}];

logger.writers = @[writer];
    
RFLogInfo(message2);
RFLogInfo([writer formattedMessage:[RFLogMessage infoMessage:message2]]);
RFLogInfo([writer formattedMessage:[RFLogMessage infoMessage:message1]]);
```
In console you can see `It's right` message 3 times.

##### Filtering messages:
Create `RFLogFilter` with necessary predicate for filtering. 
```objc
NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(RFLogMessage *evaluatedObject, NSDictionary *bindings) {
    return [evaluatedObject.type isEqualToString:kRFLogMessageTypeNetworkOnly];
}];
RFLogFilter *logFilter = [RFLogFilter filterWithPrediate:predicate];
    
RFLogMessage *validLogMessage = [RFLogMessage logMessage:@"Simple message" type:kRFLogMessageTypeNetworkOnly level:RFLogLevelWarning userInfo:nil];
RFLogMessage *invalidLogMessage = [RFLogMessage logMessage:@"Simple message" type:kRFLogMessageTypeFileOnly level:RFLogLevelWarning userInfo:nil];

if ([logFilter hasMessagePassedTest:validLogMessage]) {
    // Message has passed filtering because type of message was "kRFLogMessageTypeNetworkOnly"
}
    
if (![logFilter hasMessagePassedTest:invalidLogMessage]) {
    // Message has not passed filtering because type of message was "kRFLogMessageTypeFileOnly"
}
```
##### Predefined logging types
RFLogger contains 6 predefined constants for types of log messages: 

 - `kRFLogMessageTypeAllLoggers`;
 - `kRFLogMessageTypeNetworkOnly`;
 - `kRFLogMessageTypeWebServiceOnly`;
 - `kRFLogMessageTypeConsoleOnly`;
 - `kRFLogMessageTypeFileOnly`;
 - `kRFLogMessageTypeNoLogging`.

## Logging to the Network
`RFNetworkLogWriter` can output it's messages to the service located in the neighborhood network and discovered by Bonjour.

All the job is zero-configured and performed transparently to the user. List of available services can be obtained via delegate method:
```objc		
- (void)logWriter:(RFNetLogWriter *)logWriter availableServiceNames:(NSArray *)serviceNames;
```	
Remote service implementation can be found in **tools** folder.
