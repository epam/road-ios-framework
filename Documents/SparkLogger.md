# SFLogger

SFLogger is intended to replace `NSLog`/`fprintf`-based logging on iOS projects in a configurable industry-standard way. 

It features:

* Log levels and filtering 
* Formatting output
* Output to console, file and network services

## Basic usage

	SFLogInfo(@"Test message with %@, %i, %i", @"Param 1", "2", YES);

already takes and advantage of log leveling and attributes configured in shared instance of logger. Full call will look like: 

	[[[SFServiceProvider sharedProvider] logger] logInfoMessage:formatString];

*`SFServiceProvider` used as a logger singleton provider.*  

Convinience macros are defined for all 4 levels:
`SFLogInfo`, `SFLogDebug`, `SFLogWarning`, `SFLogError`.

## Mutliple outputs, filters and formatting
** Writers **  
Writers represent output for the message. 3 types of outputs included from the box: console, file and network.

Base writer implementation has a **background message queing**. This minimizes performance impact but should also be taken in account when other logging/tracing technologies are used simultaneously.

**Multiple outputs:**  
Logger configured with 3 console writers at different levels. 

	id <SFLogging> logger = [[SFServiceProvider sharedProvider] logger];
	STAssertNotNil(logger, @"Logger as service has not been initialised.");

	logger.writers = @[[SFConsoleLogWriter new], 	[SFConsoleLogWriter infoConsoleWriter], [SFConsoleLogWriter debugConsoleWriter]];

	SFLogDebug(@"text message text message text message");
	SFLogInfo(@"text message text message text message");

Messages in `SFLogDebug` and `SFLogInfo`  will be logged twice: one per specific writer and 1 to common one.

**Formatted logging:**  
Create formatter with comparison block and add it to writer instance. 

	SFLogWriter *writer = [SFConsoleLogWriter new];
	writer.formatter = [SFLogFormatter formatterWithBlock:^NSString *(SFLogMessage *const message) {
    
	    if ([message.message rangeOfString:symbol].location == NSNotFound) {
	        return message.message;
    	} else {
	        return [message.message stringByReplacingOccurrencesOfString:symbol withString:@""];
	    }
	}];

	logger.writers:= @[writer];

## Logging to the Network
`SFNetworkLogWriter` can output it's messages to the service located in the neighborhood network and discovered by Bonjour.

All the job is zero-configured and performed transparently to the user. List of available services can be obtained via delegate method:
		
	- (void)logWriter:(SFNetLogWriter *)logWriter availableServiceNames:(NSArray *)serviceNames;
	
Remote service implementation can be found in **tools** folder.
