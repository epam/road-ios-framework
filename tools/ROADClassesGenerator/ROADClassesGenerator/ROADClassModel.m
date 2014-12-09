//
//  ROADClassModel.m
//  ROADClassesGenerator
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing
//

#import "ROADClassModel.h"

static NSMutableDictionary *models;

@implementation ROADClassModel {
    NSMutableArray *_properties;
    NSString *_name;
}

+ (NSMutableDictionary *)models {
    if (models == nil) {
        models = [[NSMutableDictionary alloc] init];
    }
    return models;
}

+ (BOOL)registerModel:(ROADClassModel *)model {
    [[ROADClassModel models] setObject:model forKey:[model name]];
    return YES;
}

+ (ROADClassModel *)registeredModelWithName:(NSString *)modelName {
    return [[ROADClassModel models] valueForKey:modelName];
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _properties = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addProperty:(ROADPropertyModel *)property {
    [_properties addObject:property];
}

- (NSArray*)properties {
    return [_properties copy];
}

- (NSString*)name {
    return (_prefix.length > 0) ? [NSString stringWithFormat:@"%@%@", _prefix, _name] : _name;
}

@end
