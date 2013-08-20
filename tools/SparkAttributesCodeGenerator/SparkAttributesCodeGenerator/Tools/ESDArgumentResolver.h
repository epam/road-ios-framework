//
//  ESDArgumentResolver.h
//  PreprocessorAttributeParser
//
//  Created by Lippai Zoltan on 3/13/13.
//  Copyright (c) 2013 Lippai Zoltan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESDArgumentResolver : NSObject

@property(nonatomic, readonly) NSString *sourcePath;
@property(nonatomic, readonly) NSString *destinationPath;

- (id)initWithArgv:(const char **)argv argvCount:(const int)argc;

@end
