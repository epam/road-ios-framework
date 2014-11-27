//
//  ROADClassGenerator.m
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

#import "ROADClassGenerator.h"

@implementation ROADClassGenerator

+ (void)generateClassFromClassModel:(ROADClassModel*)classModel error:(NSError**)error outputDirectoryPath:(NSString*)outputDirectoryPath{
    NSArray* properties = [classModel properties];
    NSMutableString* body = [NSMutableString string];
    NSString* headerBody = [ROADClassGenerator headerWithClassName:[classModel.name stringByAppendingPathExtension:@"h"]];
    NSString* importBody = [ROADClassGenerator importLineInitWithClassName:classModel.name];
    NSString* propertiesBody = [ROADClassGenerator propertiesBodyInitInterfaceWithClassName:classModel.name];

    for (ROADPropertyModel* propertyModel in properties) {
        NSString* importLine;
        NSString* propertyBody = [ROADClassGenerator addProperty:propertyModel importLine:&importLine outputDirectoryPath:outputDirectoryPath];
        propertiesBody = [NSString stringWithFormat:@"%@\n%@\n",propertiesBody, propertyBody];
        if (importLine.length > 0) {
            importBody = [NSString stringWithFormat:@"%@\n%@",importBody, importLine];
        }
    }
    
    // generate .h file
    NSString* filePath = [[outputDirectoryPath stringByAppendingPathComponent:classModel.name] stringByAppendingPathExtension:@"h"];
    [body appendString:headerBody];
    [body appendFormat:@"\n%@", importBody];
    [body appendFormat:@"\n%@", propertiesBody];
    [body appendString:@"\n@end"];
    [ROADClassGenerator saveClassNamed:classModel.name withContent:body error:error outputFilePath:filePath];
    
    // generate .m file
    body = [NSMutableString string];
    headerBody = [ROADClassGenerator headerWithClassName:[classModel.name stringByAppendingPathExtension:@"m"]];
    importBody = [ROADClassGenerator importLineWithImportedClassName:classModel.name];
    propertiesBody = [ROADClassGenerator propertiesBodyInitImplementationWithClassName:classModel.name];
    [body appendString:headerBody];
    [body appendFormat:@"\n%@", importBody];
    [body appendFormat:@"\n%@", propertiesBody];
    filePath = [[outputDirectoryPath stringByAppendingPathComponent:classModel.name] stringByAppendingPathExtension:@"m"];
    [ROADClassGenerator saveClassNamed:classModel.name withContent:body error:error outputFilePath:filePath];
}

+ (void)saveClassNamed:(NSString*)name withContent:(NSString*)content error:(NSError**)error outputFilePath:(NSString*)outputFilePath{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:outputFilePath]){
        [fileManager removeItemAtPath:outputFilePath error:error];
    }
    [fileManager createFileAtPath:outputFilePath contents:(NSData*)content attributes:nil];
}

+ (NSString*)addProperty:(ROADPropertyModel*)propertyModel importLine:(NSString**)importLine outputDirectoryPath:(NSString*)outputDirectoryPath {
    NSString* propertyBody = @"";
    
    if ([propertyModel.propertyClassName isEqualToString:NSStringFromClass([NSString class])]) {
        propertyBody = [ROADClassGenerator propertyStringWithName:propertyModel.propertyName];
    }
    else if ([propertyModel.propertyClassName isEqualToString:NSStringFromClass([NSNumber class])]) {
        propertyBody = [ROADClassGenerator propertyNumberWithName:propertyModel.propertyName];
    }
    else if ([propertyModel.propertyClassName isEqualToString:NSStringFromClass([NSArray class])]) {
        propertyBody = [ROADClassGenerator propertyArrayWithName:propertyModel.propertyName withArraElementClassName:propertyModel.propertyType];
    }
    else if ([propertyModel.propertyClassName isEqualToString:NSStringFromClass([NSDate class])]) {
        propertyBody = [ROADClassGenerator propertyDateWithName:propertyModel.propertyName];
    }
    else {
        [ROADClassGenerator generateClassFromClassModel:propertyModel.propertyType error:nil outputDirectoryPath:outputDirectoryPath];
        propertyBody = [ROADClassGenerator propertyWithName:propertyModel.propertyName withPropertyClassName:propertyModel.propertyClassName];
        *importLine = [ROADClassGenerator importLineWithImportedClassName:propertyModel.propertyClassName];
    }
    return propertyBody;
}


#pragma mark --

+ (NSString*)headerWithClassName:(NSString*)className {
    NSMutableString* headerBody = [NSMutableString string];
    [headerBody appendString:@"//"];
    [headerBody appendFormat:@"\n// %@", className];
    [headerBody appendString:@"\n\n// Generated file"];
    [headerBody appendString:@"\n"];
    [headerBody appendString:@"\n"];
    return headerBody;
}

+ (NSString*)importLineInitWithClassName:(NSString*)className {
    return @"#import <ROAD/ROADSerialization.h>";
}

+ (NSString*)importLineWithImportedClassName:(NSString*)className {
    return [NSString stringWithFormat:@"#import \"%@.h\"", className];
}

+ (NSString*)propertiesBodyInitInterfaceWithClassName:(NSString*)className {
    return [NSString stringWithFormat:@"\n@interface %@ : %@\n", className, NSStringFromClass([NSObject class])];
}

+ (NSString*)propertiesBodyInitImplementationWithClassName:(NSString*)className {
    return [NSString stringWithFormat:@"\n@implementation %@ \n\n@end", className];
}

+ (NSString*)propertyStringWithName:(NSString*)propertyName {
    NSMutableString* propertyBody = [NSMutableString string];
    [propertyBody appendFormat:@"RF_ATTRIBUTE(RFSerializable, serializationKey = @\"%@\");", propertyName];
    [propertyBody appendFormat:@"\n@property (nonatomic) %@ *%@;",NSStringFromClass([NSString class]), propertyName];
    return propertyBody;
}

+ (NSString*)propertyNumberWithName:(NSString*)propertyName {
    NSMutableString* propertyBody = [NSMutableString string];
    [propertyBody appendFormat:@"RF_ATTRIBUTE(RFSerializable, serializationKey = @\"%@\");", propertyName];
    [propertyBody appendFormat:@"\n@property (nonatomic) %@ *%@;",NSStringFromClass([NSNumber class]), propertyName];
    return propertyBody;
}

+ (NSString*)propertyDateWithName:(NSString*)propertyName {
    NSMutableString* propertyBody = [NSMutableString string];
    [propertyBody appendString:@"RF_ATTRIBUTE(RFSerializable)"];
    [propertyBody appendFormat:@"\nRF_ATTRIBUTE(RFSerializableDate, format = @\"yyyy/MM/dd HH:mm:ss Z\")"];
    [propertyBody appendFormat:@"\n@property (nonatomic) %@ *%@;", NSStringFromClass([NSDate class]), propertyName];
    return propertyBody;
}

+ (NSString*)propertyArrayWithName:(NSString*)propertyName withArraElementClassName:(NSString*)className{
    NSMutableString* propertyBody = [NSMutableString string];
    [propertyBody appendFormat:@"RF_ATTRIBUTE(RFSerializable, serializationKey = @\"%@\");", propertyName];
    [propertyBody appendFormat:@"\nRF_ATTRIBUTE(RFSerializableCollection, collectionClass = [%@ class]);", className];
    [propertyBody appendFormat:@"\n@property (nonatomic) %@ *%@;",NSStringFromClass([NSArray class]), propertyName];
    return propertyBody;
}

+ (NSString*)propertyWithName:(NSString*)propertyName withPropertyClassName:(NSString*)className {
    NSMutableString* propertyBody = [NSMutableString string];
    [propertyBody appendFormat:@"RF_ATTRIBUTE(RFSerializable, serializationKey = @\"%@\");", propertyName];
    [propertyBody appendFormat:@"\n@property (nonatomic) %@ *%@;", className, propertyName];
    return propertyBody;
}

@end
