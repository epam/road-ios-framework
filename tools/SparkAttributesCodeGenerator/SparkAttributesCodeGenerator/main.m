//
//  main.m
//  SparkAttributesCodeGenerator
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

#import <Foundation/Foundation.h>
#import "ESDArgumentResolver.h"
#import "SourceFilesProcessor.h"
#import "Console.h"
#import "NSString+ExtendedAPI.h"
#import "NSFileManager+ExtendedAPI.h"

void PrintUsage();
void NotifyAboutStartProcessing(ESDArgumentResolver *cmdLineArguments);
void NotifyAboutFinishProcessing(ESDArgumentResolver *cmdLineArguments);
BOOL isValidParameters(ESDArgumentResolver *cmdLineArguments);

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        ESDArgumentResolver *cmdLineArguments = [[ESDArgumentResolver alloc] initWithArgv:argv argvCount:argc];
        
        if (!isValidParameters(cmdLineArguments)) {
            PrintUsage();
            return 1;
        }
        
        NotifyAboutStartProcessing(cmdLineArguments);
        [SourceFilesProcessor generateAttributeFactoriesIntoPath:cmdLineArguments.destinationPath fromSourceCodePath:cmdLineArguments.sourcePath];
        
        NotifyAboutFinishProcessing(cmdLineArguments);
    }
    return 0;
}

BOOL isValidParameters(ESDArgumentResolver *cmdLineArguments) {
    if ([NSString isNilOrEmpty:cmdLineArguments.sourcePath]) {
        [Console writeLine:@"ERROR: Path to source code was not specified"];
        return NO;
    }
    
    if ([NSString isNilOrEmpty:cmdLineArguments.destinationPath]) {
        [Console writeLine:@"ERROR: Path to destination folder was not specified"];
        return NO;
    }
    
    if (![NSFileManager isFolderAtPath:cmdLineArguments.sourcePath]) {
        [Console writeLine:@"ERROR: Path to source code doesn't point to directory"];
        return NO;
    }
    
    if (![NSFileManager isFolderAtPath:cmdLineArguments.destinationPath]) {
        [Console writeLine:@"ERROR: Path to destination folder doesn't point to directory"];
        return NO;
    }
    
    return YES;
}

void PrintUsage() {
    [Console writeLine:@"Attribute’s code generator."];
    [Console writeLine:@"Spark Framework tool"];
    [Console writeLine:@"Copyright (c) 2013 EPAM. All rights reserved."];
    [Console writeLine:@""];
    [Console writeLine:@"Usage:"];
    [Console writeLine:@""];
    [Console writeLine:@"SparkAttributesCodeGenerator –src=path to folder with source code –dst=path to destination folder where need to create attributes code"];
    [Console writeLine:@""];
}

void NotifyAboutStartProcessing(ESDArgumentResolver *cmdLineArguments) {
    [Console writeLine:@"Start source code processing"];
    [Console writeLine:[NSString stringWithFormat:@"Source code directory:%@", cmdLineArguments.sourcePath]];
    [Console writeLine:[NSString stringWithFormat:@"Directory for generated code:%@", cmdLineArguments.destinationPath]];
    [Console writeLine:@""];
}

void NotifyAboutFinishProcessing(ESDArgumentResolver *cmdLineArguments) {
    [Console writeLine:@"Done"];
    [Console writeLine:@""];
}