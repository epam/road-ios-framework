//
//  ESDArgumentResolver.m
//  PreprocessorAttributeParser
//
//  Created by Lippai Zoltan on 3/13/13.
//  Copyright (c) 2013 Lippai Zoltan. All rights reserved.
//

#import "ESDArgumentResolver.h"

@interface ESDArgumentResolver() {
    NSMutableArray *_cmdLineArguments;
    
    NSString *_sourcePathArgValue;
    NSString *_destinationPathArgValue;
}

@end

@implementation ESDArgumentResolver

@dynamic sourcePath;
@dynamic destinationPath;

- (id)initWithArgv:(const char **)argv argvCount:(const int)argc {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _cmdLineArguments = [NSMutableArray array];
    _sourcePathArgValue = nil;
    _destinationPathArgValue = nil;
    
    
    for (int index = 1; index < argc; index++) {
        NSString *cmdLineArgument = [NSString stringWithCString:argv[index] encoding:NSUTF8StringEncoding];
        cmdLineArgument = [cmdLineArgument stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [_cmdLineArguments addObject:cmdLineArgument];
    }
    
    return self;
}

- (NSString *)sourcePath {
    if (_sourcePathArgValue != nil) {
        return _sourcePathArgValue;
    }
    
    _sourcePathArgValue = [self cmdLineArgumentValueForSwith:@"-src"];
    return _sourcePathArgValue;
}

- (NSString *)destinationPath {
    if (_destinationPathArgValue != nil) {
        return _destinationPathArgValue;
    }
    
    _destinationPathArgValue = [self cmdLineArgumentValueForSwith:@"-dst"];
    return _destinationPathArgValue;
}

- (NSString *)cmdLineArgumentValueForSwith:(NSString *)aSwitch {

    for (NSString *currentCmdLineArgument in _cmdLineArguments) {
        if ([currentCmdLineArgument hasPrefix:aSwitch]) {
            return [self valueFromArgument:currentCmdLineArgument];
        }
    }
    
    return nil;
}

- (NSString *)valueFromArgument:(NSString *)currentCmdLineArgument {
    NSArray *currentCmdLineArgumentParts = [currentCmdLineArgument componentsSeparatedByString:@"="];
    
    return ([currentCmdLineArgumentParts count] < 2) ? nil : currentCmdLineArgumentParts[1];
}

@end
