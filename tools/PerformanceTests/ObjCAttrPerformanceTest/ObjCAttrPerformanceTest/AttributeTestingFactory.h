//
//  AttributeTestingFactory.h
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeTestingParameters.h"

@interface AttributeTestingFactory : NSObject

+ (id)createTestForParameters:(AttributeTestingParameters *)params;

@end
