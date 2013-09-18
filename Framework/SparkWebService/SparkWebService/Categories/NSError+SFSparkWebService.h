//
//  NSErrorh
//  SparkWebservice
//
//  Created by Andrei Kuzma on 7/5/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const kSFWebServiceErrorDomain;

@interface NSError (SFSparkWebService)
/**
 Create deserialization error, and insert the original data into the error userinfo.
 @param data The original data.
 */
+(NSError *)SF_sparkWS_deserializationErrorWithData:(NSData*)data;

/**
 Create cancell error for cancelled webservice calls.
 */
+(NSError*)SF_sparkWS_cancellError;
@end
