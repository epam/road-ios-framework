//
//  RFWebServiceClientWithLogger.h
//  ROADWebService
//
//  Created by Nikita Leonov on 10/19/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "RFWebServiceClient.h"
#import "RFWebServiceLogger.h"
#import <ROAD/ROADLogger.h>

RF_ATTRIBUTE(RFWebServiceLogger, loggerType=kRFLogMessageTypeAllLoggers)
@interface RFWebServiceClientWithLogger : RFWebServiceClient
RF_ATTRIBUTE(RFWebServiceLogger, loggerType=kRFLogMessageTypeNetworkOnly)
- (void)methodWithLogger;
- (void)methodWithoutLogger;
@end
