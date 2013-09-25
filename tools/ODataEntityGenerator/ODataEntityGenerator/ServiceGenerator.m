//
//  ServiceGenerator.m
//  ODataEntityGenerator
//
//  Created by Yuru Taustahuzau on 8/20/13.
//  Copyright (c) 2013 EPAM Systems. All rights reserved.
//

#import "ServiceGenerator.h"

#import "EntityDescriptor.h"
#import "Constants.h"

@implementation ServiceGenerator {
    NSDictionary *_entities;
    NSString *_outputPath;
    NSDictionary *_templates;
    NSString *_creationDateString;
}

+ (void)writeEntities:(NSDictionary *)entities toFolder:(NSString *)folderPath {
    ServiceGenerator *generator = [[ServiceGenerator alloc] initWithEntities:entities folderPath:folderPath];
    
    [generator generateEntities];
}

- (id)initWithEntities:(NSDictionary *)entityDict folderPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _entities = entityDict;
        _outputPath = [path copy];
        NSString *templatesPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:serviceTemplatesFilename];
        _templates = [NSDictionary dictionaryWithContentsOfFile:templatesPath];
        NSAssert(_templates != nil, @"Missing template file");
        
        NSString *formatString = [_templates objectForKey:creationDateFormatStringKeyName];
        NSAssert(formatString != nil, @"Missing %@ key", creationDateFormatStringKeyName);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        _creationDateString = [dateFormatter stringFromDate:[NSDate date]];
        
    }
    return self;
}

- (void)generateEntities
{
    // represents the whole header file
    NSMutableString *headerOutputString = [NSMutableString stringWithString:[_templates objectForKey:headerfile_key]];
    
    // represents the whole code file
    NSMutableString *codeOutputString = [NSMutableString stringWithString:[_templates objectForKey:codefile_key]];
    
    // Replace name of web client
    NSString *webClient = [_templates objectForKey:webClientName];
    [headerOutputString replaceOccurrencesOfString:webClientNameVariable withString:webClient options:0 range:NSMakeRange(0, [headerOutputString length])];
    [codeOutputString replaceOccurrencesOfString:webClientNameVariable withString:webClient options:0 range:NSMakeRange(0, [codeOutputString length])];
    
    // set the creation date
    [headerOutputString replaceOccurrencesOfString:creationdateVariable withString:_creationDateString options:0 range:NSMakeRange(0, [headerOutputString length])];
    [codeOutputString replaceOccurrencesOfString:creationdateVariable withString:_creationDateString options:0 range:NSMakeRange(0, [codeOutputString length])];
    
    NSString *services = [self generateServices];
    [headerOutputString replaceOccurrencesOfString:serviceDeclarationVariable withString:services options:0 range:NSMakeRange(0, [headerOutputString length])];
    
    NSString *outputFileName = [_outputPath stringByAppendingPathComponent:webClient];
    NSString *headerFileName = [outputFileName stringByAppendingPathExtension:@"h"];
    NSString *codeFileName = [outputFileName stringByAppendingPathExtension:@"m"];
    
    NSError *error;
    [headerOutputString writeToFile:headerFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [codeOutputString writeToFile:codeFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (NSString *)generateServices {
    NSMutableString *services = [[NSMutableString alloc] init];
    
    NSString *serviceDeclarationTemplate = [_templates objectForKey:serviceDeclaration];
    for (EntityDescriptor *entityDescriptor in _entities.allValues) {
        if (entityDescriptor.entitySetName) {
            NSMutableString *service = [serviceDeclarationTemplate mutableCopy];
            // Name service
            [service replaceOccurrencesOfString:entitySetNameVariable withString:entityDescriptor.entitySetName options:NSLiteralSearch range:NSMakeRange(0, [service length])];
            // Add prototype class
            [service replaceOccurrencesOfString:classnameVariable withString:entityDescriptor.name options:NSLiteralSearch range:NSMakeRange(0, [service length])];
            
            [services appendString:service];
        }
    }
    
    return services;
}

@end
