//
//  NSXMLElement+Additions.h
//  ODataEntityGenerator
//
//  Created by  on 2012.03.06..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSXMLElement (Additions)

- (BOOL)boolValueFromAttribute:(NSString *)attributeName;
- (BOOL)boolValueFromAttribute:(NSString *)attributeName defaultValue: (BOOL) defaultValue;
- (int)intValueFromAttribute:(NSString *)attributeName;

@end
