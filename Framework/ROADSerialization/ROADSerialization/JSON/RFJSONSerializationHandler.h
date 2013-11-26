//
//  RFJSONSerializationHandler.h
//  ROADSerialization
//
//  Created by Yuru Taustahuzau on 11/26/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Defines methods that you need to implement in order to use class as custom serialization handler.
 */
@protocol RFJSONSerializationHandler <NSObject>

/**
 * Encodes object in structure that NSJSONSerialization class understand. It can be NSString in the most simple case.
 * @param object The object that has to be serialized.
 */
- (id)encodeObject:(id)object;
/**
 * Decodes object from NSJSONSerialization class into appropriate objective-c object. 
 * @param object The object that has to be deserialized. Type of object can be any type that NSJSONSerialization provides.
 */
- (id)decodeObject:(id)object;

@end
