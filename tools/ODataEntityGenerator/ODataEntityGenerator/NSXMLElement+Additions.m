//
//  NSXMLElement+Additions.m
//  ODataEntityGenerator
//
//  Created by  on 2012.03.06..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import "NSXMLElement+Additions.h"

@implementation NSXMLElement (Additions)

- (BOOL)boolValueFromAttribute:(NSString *)attributeName
{
    return [[[self attributeForName:attributeName] stringValue] boolValue];
}

- (BOOL)boolValueFromAttribute:(NSString *)attributeName defaultValue: (BOOL) defaultValue
{
    NSXMLNode *attributeNode = [self attributeForName:attributeName];
    if (attributeNode == nil)
        return defaultValue;
    return [[attributeNode stringValue] boolValue];
}

- (int)intValueFromAttribute:(NSString *)attributeName {
    NSXMLNode *attribute = [self attributeForName:attributeName];
    
    return attribute!=nil ? [[attribute stringValue] intValue] : -1;
}


@end
