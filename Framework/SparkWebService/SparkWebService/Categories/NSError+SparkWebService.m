//
//  NSError+SparkWebService.m
//  SparkWebservice
//
//  Created by Andrei Kuzma on 7/5/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "NSError+SparkWebService.h"

NSString * const kSFWebServiceErrorDomain = @"SFWebServiceError";
NSString *const kSFWebServiceRecievedDataKey = @"RecievedData";

@implementation NSError (SparkWebService)

+(NSError *)sparkWS_deserializationErrorWithData:(NSData*)data
{
    return [NSError errorWithDomain:kSFWebServiceErrorDomain code:1000 userInfo:@{ NSLocalizedDescriptionKey : @"Error during the deserialization",kSFWebServiceRecievedDataKey : data }];
}

+(NSError *)sparkWS_cancellError
{
    return [NSError errorWithDomain:kSFWebServiceErrorDomain code:1001 userInfo:@{ NSLocalizedDescriptionKey : @"The request has been cancelled." }];
}

@end
