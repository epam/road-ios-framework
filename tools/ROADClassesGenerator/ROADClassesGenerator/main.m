//
//  main.m
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

#import <Foundation/Foundation.h>
#import "ROADJSONParser.h"
#import "ROADClassModel.h"
#import "ROADClassGenerator.h"
#import "RFArgumentResolver.h"
#import "RFConsole.h"

void PrintUsage();
void NotifyAboutStartProcessing(RFArgumentResolver *cmdLineArguments);
void NotifyAboutFinishProcessing(RFArgumentResolver *cmdLineArguments);
BOOL isValidParameters(RFArgumentResolver *cmdLineArguments);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        RFArgumentResolver *cmdLineArguments = [[RFArgumentResolver alloc] initWithArgv:argv argvCount:argc];
        
        if (!isValidParameters(cmdLineArguments)) {
            PrintUsage();
            return 1;
        }
        
        NotifyAboutStartProcessing(cmdLineArguments);
        NSError *error = nil;
        
        [ROADJSONParser parseJSONFromFilePath:cmdLineArguments.sourcePath error:&error];
        if (!error) {
            NSDictionary *models = [ROADClassModel models];
            [models enumerateKeysAndObjectsUsingBlock:^(NSString *key, ROADClassModel *obj, BOOL *stop) {
                NSError *error = nil;
                [ROADClassGenerator generateClassFromClassModel:obj error:&error prefix:cmdLineArguments.prefix outputDirectoryPath:cmdLineArguments.outputDirectoryPath];
                if (!error) {
                    [RFConsole writeLine:[NSString stringWithFormat:@"Class %@ generation complete!", key]];
                }
                else {
                    [RFConsole writeLine:[NSString stringWithFormat:@"ERROR: for %@ class generation!", key]];
                }
            }];
            NotifyAboutFinishProcessing(cmdLineArguments);
        }
        else {
            [RFConsole writeLine:@"ERROR: json parsing"];
        }
    }
    return 0;
}

BOOL isValidParameters(RFArgumentResolver *cmdLineArguments) {
    if (cmdLineArguments.sourcePath.length == 0) {
        [RFConsole writeLine:@"ERROR: Path to source file was not specified"];
        return NO;
    }
    BOOL isDir;
    BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:cmdLineArguments.sourcePath isDirectory:&isDir];
    if (!dirExists) {
        [RFConsole writeLine:[NSString stringWithFormat:@"ERROR: Source json file not exist at path %@", cmdLineArguments.sourcePath]];
        return NO;
    }
    
    dirExists = [[NSFileManager defaultManager] fileExistsAtPath:cmdLineArguments.outputDirectoryPath isDirectory:&isDir];
    if (!dirExists) {
        [RFConsole writeLine:[NSString stringWithFormat:@"ERROR: Output directory not exist at path %@", cmdLineArguments.outputDirectoryPath]];
    }
    else if (!isDir) {
        [RFConsole writeLine:[NSString stringWithFormat:@"ERROR: Output directory is not a directory at path %@", cmdLineArguments.outputDirectoryPath]];
    }
    
    if (!isDir || !dirExists) {
        return NO;
    }
    
    return YES;
}

void PrintUsage() {
    [RFConsole writeLine:@"Classes generator."];
    [RFConsole writeLine:@"ROAD Framework tool"];
    [RFConsole writeLine:@"Copyright (c) 2014 EPAM. All rights reserved."];
    [RFConsole writeLine:@""];
    [RFConsole writeLine:@"Usage:"];
    [RFConsole writeLine:@""];
    [RFConsole writeLine:@"ROADClassesGenerator –src=path to json file –out=path for generated code"];
    [RFConsole writeLine:@"Optional parameters: -prefix=prefix for generated classes names"];
    [RFConsole writeLine:@""];
}

void NotifyAboutStartProcessing(RFArgumentResolver *cmdLineArguments) {
    [RFConsole writeLine:@"Start source code processing"];
    [RFConsole writeLine:[NSString stringWithFormat:@"Source json path:%@", cmdLineArguments.sourcePath]];
    [RFConsole writeLine:[NSString stringWithFormat:@"Directory for generated code:%@", cmdLineArguments.outputDirectoryPath]];
    if (cmdLineArguments.prefix.length > 0) {
        [RFConsole writeLine:[NSString stringWithFormat:@"Prefix for generated classes names:%@", cmdLineArguments.prefix]];
    }
    [RFConsole writeLine:@""];
}

void NotifyAboutFinishProcessing(RFArgumentResolver *cmdLineArguments) {
    [RFConsole writeLine:@"Done"];
    [RFConsole writeLine:@""];
}
