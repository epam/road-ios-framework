//
//  SFAttributedXMLCoder.h
//  SparkSerialization
//
//  Created by Oleh Sannikov on 26.09.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAttributedXMLCoder : NSObject

/**
 Encodes the specified object into a json string.
 @param rootObject The object to serialize.
 @result The xml string.
 */
- (NSString*)encodeRootObject:(id)rootObject;

@end
