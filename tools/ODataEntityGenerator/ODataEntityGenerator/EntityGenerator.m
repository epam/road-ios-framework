//
//  EntityGenerator.m
//  ODataEntityGenerator
//
//  Created by Andras Palfi on 2012.03.07..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import "EntityGenerator.h"
#import "PropertyDescriptor.h"
#import "EntityDescriptor.h"

#import "Constants.h"

@implementation EntityGenerator
{
    NSDictionary *_entities;
    NSString *_outputPath;
    NSDictionary *_templates;
    NSDictionary *_nullableTypes;
    NSDictionary *_typeQualifiers;
    NSString *_defaultQualifier;
    NSString *_creationDateString;
    BOOL _readonlyProperties;
    BOOL _camelcaseProperties;
    NSDictionary *_standardTypeGenerators;
}

+ (void)writeEntities:(NSDictionary *)entities toFolder:(NSString *)folderPath {
    EntityGenerator *generator = [[EntityGenerator alloc] initWithEntities:entities folderPath:folderPath];
    
    [generator generateEntities];
}

- (id)initWithEntities:(NSDictionary *)entityDict folderPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _entities = entityDict;
        _outputPath = [path copy];
        NSString *templatesPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:templatesFilename];
        _templates = [NSDictionary dictionaryWithContentsOfFile:templatesPath];
        NSAssert(_templates != nil, @"Missing template file");

        _nullableTypes = [_templates objectForKey:nullableTypesKeyName];

        _typeQualifiers = [_templates objectForKey:typeQualifiersKeyName];
        NSAssert(_typeQualifiers != nil, @"Missing %@ key", typeQualifiersKeyName);
        
        _defaultQualifier = [_templates objectForKey:defaultQualifierKeyName];
        NSAssert(_defaultQualifier != nil, @"Missing %@ key", defaultQualifierKeyName);
        
        NSString *formatString = [_templates objectForKey:creationDateFormatStringKeyName];
        NSAssert(formatString != nil, @"Missing %@ key", creationDateFormatStringKeyName);

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
        _creationDateString = [dateFormatter stringFromDate:[NSDate date]];
        
        NSNumber *readonly = [_templates objectForKey:readonlyPropertiesKey];
        _readonlyProperties = [readonly boolValue];

        NSNumber *camelcase = [_templates objectForKey:camelcasePropertiesKey];
        _camelcaseProperties = [camelcase boolValue];
    }
    return self;
}

- (void)generateEntities
{
    for (EntityDescriptor *entity in [_entities allValues])
    {
        [self writeEntity:entity];
    }
}

- (NSString *) nameForProperty: (PropertyDescriptor *) aProperty
{
    NSString *propertyName = aProperty.name;
    if (_camelcaseProperties && (propertyName.length > 0))
    {
        NSString *firstLetter = [propertyName substringToIndex:1];
        NSString *remainder = [propertyName substringFromIndex:1];
        firstLetter = [firstLetter lowercaseString];
        propertyName = [NSString stringWithFormat:@"%@%@", firstLetter, remainder];
    }
    return propertyName;
}

- (void)generateProperty:(PropertyDescriptor *)aProperty templateKey:(NSString *)aTemplateKey propertiesOutputString:(NSMutableString *)propertiesOutputString
{
    NSString *propertyName = [self nameForProperty:aProperty];

    // header properties
    NSMutableString *headerPropertyString = [NSMutableString stringWithString:[_templates objectForKey:aTemplateKey]];
    
    // replace name
    [headerPropertyString replaceOccurrencesOfString:propertyNameVariable withString:propertyName options:0 range:NSMakeRange(0, [headerPropertyString length])];
    
    // replace annotation name
    [headerPropertyString replaceOccurrencesOfString:originalPropertyNameVariable withString:aProperty.name options:0 range:NSMakeRange(0, [headerPropertyString length])];

    // replace type:  association type cannot be built in types
    NSString* typeString = nil;
    if (aProperty.isCollection)
    {
        // Adding collection annotation
        NSMutableString *collectionAnnotationString = [[NSMutableString alloc] initWithString:[_templates objectForKey:collectionAnnotationKey]];
        [collectionAnnotationString replaceOccurrencesOfString:propertyTypeVariable withString:aProperty.typeName options:0 range:NSMakeRange(0, [collectionAnnotationString length])];
        [headerPropertyString replaceOccurrencesOfString:collectionTypeAnnotationVariable withString:collectionAnnotationString options:0 range:NSMakeRange(0, [headerPropertyString length])];
        
        // for array create the array declaration
        if (aProperty.maxLength == INT_MAX)
        {
            NSString *arrayType;
            if (_readonlyProperties)
                arrayType = [_templates objectForKey:propertytype_readonly_array_key];
            else
                arrayType = [_templates objectForKey:propertytype_array_key];
            // replace the possible type declaration in the array type - like template classes in c++
            typeString = [arrayType stringByReplacingOccurrencesOfString:propertyTypeVariable withString:aProperty.typeName];
        }
        else
        {
            typeString = [self typeStringForProperty:aProperty];
        }
    }
    else
    {
        // Removing space for collection annotation
        [headerPropertyString replaceOccurrencesOfString:collectionTypeAnnotationVariable withString:@"" options:0 range:NSMakeRange(0, [headerPropertyString length])];
        typeString = [self typeStringForProperty:aProperty];
    }
    
    // replace date format
    NSString *dateFormat = [_templates objectForKey:dateFormatKey];
    NSMutableString *dateFormatString = [[_templates objectForKey:dateFormatStringKey] mutableCopy];
    [dateFormatString replaceOccurrencesOfString:dateFormatVariable withString:dateFormat options:0 range:NSMakeRange(0, [dateFormatString length])];
    if ([typeString isEqualToString:@"NSDate *"]) {
        [headerPropertyString replaceOccurrencesOfString:dateFormatVariable withString:dateFormatString options:0 range:NSMakeRange(0, [headerPropertyString length])];
    }
    else {
        [headerPropertyString replaceOccurrencesOfString:dateFormatVariable withString:@"" options:0 range:NSMakeRange(0, [headerPropertyString length])];
    }
    
    [headerPropertyString replaceOccurrencesOfString:propertyTypeVariable withString:typeString options:0 range:NSMakeRange(0, [headerPropertyString length])];
    
    
    // set the qualifier
    [headerPropertyString replaceOccurrencesOfString:propertyQualifierVariable withString:[self propertyQualifierForTypeString:typeString] options:0 range:NSMakeRange(0, [headerPropertyString length])];
    
    
    // TODO: what to do with the other fields?
    //        BOOL nullable;
    //        int fixedLength;
    //        int maxLength;
    //        int precision;
    //        BOOL isUnicode;
    
    [propertiesOutputString appendString:headerPropertyString];
}

- (void)generateProperties:(EntityDescriptor *)anEntity headerOutputString:(NSMutableString *)headerOutputString codeOutputString:(NSMutableString *)codeOutputString
{
    // contains all property declaration in the header file
    NSMutableString *headerPropertiesOutputString = [NSMutableString string];
    
    // contains all property declaration in the code file
    NSMutableString *codePropertiesOutputString = [NSMutableString string];

    // contains all forward declarations to referenced generated classes
    NSMutableString *forwardDeclarations = [NSMutableString string];

    // all necessary #import directives
    NSMutableString *imports = [NSMutableString string];

    // backing members for properties
    NSMutableString *members = [NSMutableString string];
    
    // build up the property list
    for (PropertyDescriptor *aProperty in anEntity.properties)
    {
        [self generateProperty:aProperty templateKey:headerfile_property_key propertiesOutputString:headerPropertiesOutputString];
        [self generateProperty:aProperty templateKey:codefile_property_key propertiesOutputString:codePropertiesOutputString];
        if ([self isGeneratedType:aProperty.typeName])
        {
            if (aProperty.maxLength != INT_MAX)
            {
                NSString *classForwardDeclaration = [_templates objectForKey:forwarddeclaration_key];
                classForwardDeclaration = [classForwardDeclaration stringByReplacingOccurrencesOfString:propertyTypeVariable withString:aProperty.typeName];
                [forwardDeclarations appendString:classForwardDeclaration];
            }
            
            NSString *codeImportDeclaration = [_templates objectForKey:codefileImportKey];
            codeImportDeclaration = [codeImportDeclaration stringByReplacingOccurrencesOfString:classnameVariable withString:aProperty.typeName];
            [imports appendString:codeImportDeclaration];
        }
        [self generateProperty:aProperty templateKey:codefilePropertyMemberKey propertiesOutputString:members];
    }
    
    // add the properties to the file
    [headerOutputString replaceOccurrencesOfString:propertiesVariable withString:headerPropertiesOutputString options:0 range:NSMakeRange(0, [headerOutputString length])];
    
    // add the forward declarations
    [headerOutputString replaceOccurrencesOfString:forwarddeclarationVariable withString:forwardDeclarations options:0 range:NSMakeRange(0, [headerOutputString length])];

    // add necessary imports
    [codeOutputString replaceOccurrencesOfString:importsVariable withString:imports options:0 range:NSMakeRange(0, [codeOutputString length])];

    // add necessary backing members
    [codeOutputString replaceOccurrencesOfString:propertyMembersVariable withString:members options:0 range:NSMakeRange(0, [codeOutputString length])];
}

- (void)writeEntity:(EntityDescriptor *)anEntity
{
    // represents the whole header file
    NSMutableString *headerOutputString = [NSMutableString stringWithString:[_templates objectForKey:headerfile_key]];
    
    // represents the whole code file
    NSMutableString *codeOutputString = [NSMutableString stringWithString:[_templates objectForKey:codefile_key]];
    
    // set the class name
    [headerOutputString replaceOccurrencesOfString:classnameVariable withString:anEntity.name options:0 range:NSMakeRange(0, [headerOutputString length])];
    // If collection name is not empty add its value into annotation
    if (anEntity.entitySetName) {
        [headerOutputString replaceOccurrencesOfString:entityNameVariable withString:[NSString stringWithFormat:@"SF_ATTRIBUTE(SFODataEntity, entityName = @\"%@\")", anEntity.entitySetName] options:0 range:NSMakeRange(0, [headerOutputString length])];
    }
    [codeOutputString replaceOccurrencesOfString:classnameVariable withString:anEntity.name options:0 range:NSMakeRange(0, [codeOutputString length])];
    
    // set the base class
    NSString *baseClass;
    if (anEntity.baseName != nil)
        baseClass = anEntity.baseName;
    else
        baseClass = @"SFODataAbstractEntity";
    [headerOutputString replaceOccurrencesOfString:baseclassVariable withString:baseClass options:0 range:NSMakeRange(0, [headerOutputString length])];
    [codeOutputString replaceOccurrencesOfString:baseclassVariable withString:baseClass options:0 range:NSMakeRange(0, [codeOutputString length])];
    
    // set the creation date
    // set the base class
    [headerOutputString replaceOccurrencesOfString:creationdateVariable withString:_creationDateString options:0 range:NSMakeRange(0, [headerOutputString length])];
    [codeOutputString replaceOccurrencesOfString:creationdateVariable withString:_creationDateString options:0 range:NSMakeRange(0, [codeOutputString length])];

    [self generateProperties:anEntity headerOutputString:headerOutputString codeOutputString:codeOutputString];
    
    NSString *outputFileName = [_outputPath stringByAppendingPathComponent:anEntity.name];
    NSString *headerFileName = [outputFileName stringByAppendingPathExtension:@"h"];
    NSString *codeFileName = [outputFileName stringByAppendingPathExtension:@"m"];
    
    NSError *error;
    [headerOutputString writeToFile:headerFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [codeOutputString writeToFile:codeFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (BOOL)isGeneratedType:(NSString *)typeName
{
    return [_entities objectForKey:typeName]!=nil;
}

- (NSString *)typeStringForProperty:(PropertyDescriptor *)property
{
    NSString *lowerCasedType = [property.typeName lowercaseString];
    NSString *mappedType;
    mappedType = [_nullableTypes objectForKey:lowerCasedType];
    if (mappedType == nil)
    {
        // check the existence of the referenced type
        NSAssert([_entities objectForKey:property.typeName]!=nil, @"The referenced class type doesn't exist: %@", property.typeName);
        
        // class must be a pointer
        mappedType = [NSString stringWithFormat:@"%@ *", property.typeName];
    }
    
    return mappedType;
}

- (NSString *)propertyQualifierForTypeString:(NSString *)typeString
{
    if (_readonlyProperties)
        return readonlyPropertyQualifier;

    NSString *qualifierToReturn = [_typeQualifiers objectForKey:typeString];
    if (qualifierToReturn == nil)
    {
        qualifierToReturn = _defaultQualifier;
    }
    
    return qualifierToReturn;
}

@end
