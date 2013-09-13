//
//  EntityDescription.m
//  ODataEntityGenerator
//
//  Created by  on 2012.03.06..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import "EntityDescriptor.h"

#import "PropertyDescriptor.h"

@implementation EntityDescriptor {
    NSMutableArray *properties;
}

@synthesize name;
@synthesize baseName;
@synthesize isAbstract;

- (id) init {
    self = [super init];
    if (self) {
        properties = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addProperty:(PropertyDescriptor *)property {
    [properties addObject:property];
}

- (NSArray *) properties {
    return properties;
}


-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@:%@ (%@)", name, baseName!=nil?baseName:@"", isAbstract ? @"abstract" : @""];
}

@end
