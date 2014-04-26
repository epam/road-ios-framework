//
//  RFRequestTestProcessor.h
//  ROADWebService
//
//  Created by Balazs Gollner on 2014.04.23..
//  Copyright (c) 2014 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFWebServiceRequestProcessing.h"

@interface RFRequestTestProcessor : NSObject<RFWebServiceRequestProcessing>

@property (nonatomic, strong) NSArray *passedAttributes;

@end
