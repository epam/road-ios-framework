//
//  SFWebServiceErrorHandling.h
//  SparkWebservice
//
//  Created by Yuru Taustahuzau on 8/22/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFWebServiceErrorHandling <NSObject>

/**
 * Method validates response and return error object if response is not valid.
 * @param response The response which have to be validated.
 * @param data The data received with response
 * @return Error object (can as NSError instance, as custom object for custom handlers) in case response is not valid.
 */
+ (id)validateResponse:(NSURLResponse *)response withData:(NSData *)data;

@end
