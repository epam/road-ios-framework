//
//  PropertyDescriptor.m
//  ODataEntityGenerator
//
//  Created by  on 2012.03.06..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import "PropertyDescriptor.h"

@implementation PropertyDescriptor

@synthesize name;
@synthesize nullable;
@synthesize typeName;
@synthesize fixedLength;
@synthesize maxLength;
@synthesize precision;
@synthesize isUnicode;
@synthesize isAssociationProperty;

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@:%@ [%d.%d]%@%@", name, typeName, maxLength, precision, nullable?@" nullable":@"", isAssociationProperty?@" association":@""];
}

@end
