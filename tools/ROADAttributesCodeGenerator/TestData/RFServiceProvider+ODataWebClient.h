//
//  SFServiceProvider+ODataWebClient.h
//  ODataDemo
//
//  Created by Yuru Taustahuzau on 8/13/13.
//  Copyright (c) 2013 EPAM Systems. All rights reserved.
//

#import <Spark/SparkServices.h>
#import "ODataWebClient.h"

@interface SFServiceProvider(ODataWebClient)

SF_ATTRIBUTE(SFService, serviceClass = [[ODataWebClient class])
- (ODataWebClient *)odataWebClient;

@end
