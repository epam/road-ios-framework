//
//  RFServiceProvider+ODataWebClient.h
//  ODataDemo
//
//  Created by Yuru Taustahuzau on 8/13/13.
//  Copyright (c) 2013 EPAM Systems. All rights reserved.
//

#import <ROAD/ROADServices.h>
#import "ODataWebClient.h"

@interface RFServiceProvider(ODataWebClient)

RF_ATTRIBUTE(RFService, serviceClass = [[ODataWebClient class])
- (ODataWebClient *)odataWebClient;

@end
