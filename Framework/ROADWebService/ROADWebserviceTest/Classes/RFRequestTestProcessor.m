//
//  RFRequestTestProcessor.m
//  ROADWebService
//
//  Created by Balazs Gollner on 2014.04.23..
//  Copyright (c) 2014 Epam Systems. All rights reserved.
//

#import "RFRequestTestProcessor.h"

@implementation RFRequestTestProcessor

- (void)processRequest:(NSMutableURLRequest *)request attributesOnMethod:(NSArray *)attributes {
    
    _passedAttributes = attributes;    
}

@end
