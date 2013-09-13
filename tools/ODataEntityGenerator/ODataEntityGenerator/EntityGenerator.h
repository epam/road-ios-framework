//
//  EntityGenerator.h
//  ODataEntityGenerator
//
//  Created by  on 2012.03.07..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Generates source files based on the entities dictionary which should contains EntityDesciptors
 */
@interface EntityGenerator : NSObject

/**
 Writes out the generated classes using the entities dictionary.
 @param entities should contain EntityDescriptor classes as values and the type names as keys
 @param folderPath the output path where the files will be placed
 */
+ (void)writeEntities:(NSDictionary *)entities toFolder:(NSString *)folderPath;

@end
