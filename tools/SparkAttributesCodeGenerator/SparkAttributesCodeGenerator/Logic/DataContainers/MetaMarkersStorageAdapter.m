//
//  MetaMarkersDataHandler.m
//  AttributesResearchLab
//
//  
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
// 
//  Redistributions of source code must retain the above copyright notice, this 
// list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this 
// list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "MetaMarkersStorageAdapter.h"

@interface MetaMarkersStorageAdapter() {
    NSMutableDictionary *_metaMarkers;
    NSUInteger _dataCount;
    NSString *_metaMarkerFormat;
}

@end

@implementation MetaMarkersStorageAdapter

- (id)initForStorage:(NSMutableDictionary *)metaMarkers withPrefix:(NSString *)metaMarkerPrefix {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _metaMarkers = metaMarkers;
    _metaMarkerFormat = [NSString stringWithFormat:@"%%%@%%ld%%%%", metaMarkerPrefix];
    _dataCount = 0;
    
    return self;
}

- (NSString *)addData:(NSString *)data {
    if (data == nil) {
        return @"";
    }
    
    NSString *metaMarker = [NSString stringWithFormat:_metaMarkerFormat, (long)_dataCount];
    ++_dataCount;
    
    [_metaMarkers setObject:data forKey:metaMarker];
    
    return metaMarker;
}

@end
