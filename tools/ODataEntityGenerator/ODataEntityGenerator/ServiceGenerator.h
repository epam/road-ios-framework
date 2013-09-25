//
//  ServiceGenerator.h
//  ODataEntityGenerator
//
//  Created by Yuru Taustahuzau on 8/20/13.
//  Copyright (c) 2013 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceGenerator : NSObject

/**
 Writes out the generated web client with service to get the entities from web services.
 @param entities should contain EntityDescriptor classes as values and the type names as keys
 @param folderPath the output path where the web client class will be placed
 */
+ (void)writeEntities:(NSDictionary *)entities toFolder:(NSString *)folderPath;

@end
