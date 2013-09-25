//
//  NSBundle+SFParameterList.h
//  SparkCore
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


#import <Foundation/Foundation.h>

extern NSString * const kSFPlistFileExtension;

/**
 Convenience methods to fetch plist file paths with less code.
 */
@interface NSBundle (SFParameterList)

/**
 Convenience method to return a path for a plist file of a given name.
 @param plistResourceName The name of the plist file.
 @result The string representation for the path pointing to the plist file.
 */
- (NSString *)SF_pathForPlistResource:(NSString *)plistResourceName;

/**
 Returns the resource path for the plist file with the same name as the receiver's class name.
 @result Returns the path string for the plist file.
 */
- (NSString *)SF_pathForOwnedPlist;

/**
 Convenience method to return an NSURL representation of the path to a plist file in the bundle of a specified name.
 @param plistResourceName The name of the plist file.
 @result The url object containing the path.
 */
- (NSURL *)SF_urlForPlistResource:(NSString *)plistResourceName;

@end
