//
//  NSError+SparkWebService.h
//  SparkWebservice
//
//  Created by Andrei Kuzma on 7/5/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const kSFWebServiceErrorDomain;

@interface NSError (SparkWebService)
/**
 Create deserialization error, and insert the original data into the error userinfo.
 @param data The original data.
 */
+(NSError *)sparkWS_deserializationErrorWithData:(NSData*)data;

/**
 Create cancell error for cancelled webservice calls.
 */
+(NSError*)sparkWS_cancellError;
@end
