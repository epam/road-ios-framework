#import <Foundation/Foundation.h>
#import "SFSerializable.h"
#import "SFSerializableDate.h"
#import "SFSerializableCollection.h"
#import "SFDerived.h"
#import "SFSerializationTestObject.h"
#import "SFAttributedXMLCoder.h"
#import <Spark/SparkCore.h>
 
@interface SFSerializationTestObject(SFAttribute)
 
@end
 
@implementation SFSerializationTestObject(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Properties section)

+ (NSArray *)SF_attributes_SFSerializationTestObject_property_string2 {
    NSMutableArray *SF_attributes_list_SFSerializationTestObject_property_string2 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFSerializationTestObject_property_string2"];
    if (SF_attributes_list_SFSerializationTestObject_property_string2 != nil) {
        return SF_attributes_list_SFSerializationTestObject_property_string2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFDerived *attr1 = [[SFDerived alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list_SFSerializationTestObject_property_string2 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFSerializationTestObject_property_string2"];
    
    return SF_attributes_list_SFSerializationTestObject_property_string2;
}

+ (NSArray *)SF_attributes_SFSerializationTestObject_property_date1 {
    NSMutableArray *SF_attributes_list_SFSerializationTestObject_property_date1 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFSerializationTestObject_property_date1"];
    if (SF_attributes_list_SFSerializationTestObject_property_date1 != nil) {
        return SF_attributes_list_SFSerializationTestObject_property_date1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableDate *attr1 = [[SFSerializableDate alloc] init];
    attr1.format = @"dd/MM/yyyy HH:mm:ss Z";
    [attributesArray addObject:attr1];

    SF_attributes_list_SFSerializationTestObject_property_date1 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFSerializationTestObject_property_date1"];
    
    return SF_attributes_list_SFSerializationTestObject_property_date1;
}

+ (NSArray *)SF_attributes_SFSerializationTestObject_property_date2 {
    NSMutableArray *SF_attributes_list_SFSerializationTestObject_property_date2 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFSerializationTestObject_property_date2"];
    if (SF_attributes_list_SFSerializationTestObject_property_date2 != nil) {
        return SF_attributes_list_SFSerializationTestObject_property_date2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableDate *attr1 = [[SFSerializableDate alloc] init];
    attr1.format = @"MM.dd.yyyy HH:mm";
    attr1.decodingFormat = @"MM.dd.yyyy HH:mm:ss";
    [attributesArray addObject:attr1];

    SF_attributes_list_SFSerializationTestObject_property_date2 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFSerializationTestObject_property_date2"];
    
    return SF_attributes_list_SFSerializationTestObject_property_date2;
}

+ (NSArray *)SF_attributes_SFSerializationTestObject_property_unixTimestamp {
    NSMutableArray *SF_attributes_list_SFSerializationTestObject_property_unixTimestamp = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFSerializationTestObject_property_unixTimestamp"];
    if (SF_attributes_list_SFSerializationTestObject_property_unixTimestamp != nil) {
        return SF_attributes_list_SFSerializationTestObject_property_unixTimestamp;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableDate *attr1 = [[SFSerializableDate alloc] init];
    attr1.unixTimestamp = YES;
    [attributesArray addObject:attr1];

    SF_attributes_list_SFSerializationTestObject_property_unixTimestamp = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFSerializationTestObject_property_unixTimestamp"];
    
    return SF_attributes_list_SFSerializationTestObject_property_unixTimestamp;
}

+ (NSArray *)SF_attributes_SFSerializationTestObject_property_subObjects {
    NSMutableArray *SF_attributes_list_SFSerializationTestObject_property_subObjects = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFSerializationTestObject_property_subObjects"];
    if (SF_attributes_list_SFSerializationTestObject_property_subObjects != nil) {
        return SF_attributes_list_SFSerializationTestObject_property_subObjects;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableCollection *attr1 = [[SFSerializableCollection alloc] init];
    attr1.collectionClass = [SFSerializationTestObject class];
    [attributesArray addObject:attr1];

    SF_attributes_list_SFSerializationTestObject_property_subObjects = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFSerializationTestObject_property_subObjects"];
    
    return SF_attributes_list_SFSerializationTestObject_property_subObjects;
}

+ (NSArray *)SF_attributes_SFSerializationTestObject_property_subDictionary {
    NSMutableArray *SF_attributes_list_SFSerializationTestObject_property_subDictionary = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFSerializationTestObject_property_subDictionary"];
    if (SF_attributes_list_SFSerializationTestObject_property_subDictionary != nil) {
        return SF_attributes_list_SFSerializationTestObject_property_subDictionary;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableCollection *attr1 = [[SFSerializableCollection alloc] init];
    attr1.collectionClass = [SFSerializationTestObject class];
    [attributesArray addObject:attr1];

    SF_attributes_list_SFSerializationTestObject_property_subDictionary = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFSerializationTestObject_property_subDictionary"];
    
    return SF_attributes_list_SFSerializationTestObject_property_subDictionary;
}

+ (NSMutableDictionary *)SF_attributesFactoriesForProperties {
    NSMutableDictionary *attributesSFSerializationTestObjectFactoriesForPropertiesDict = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFSFSerializationTestObjectFactoriesForProperties"];
    if (attributesSFSerializationTestObjectFactoriesForPropertiesDict != nil) {
        return attributesSFSerializationTestObjectFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[SFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"SFSFSerializationTestObjectFactoriesForProperties"];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFSerializationTestObject_property_string2)] forKey:@"string2"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFSerializationTestObject_property_date1)] forKey:@"date1"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFSerializationTestObject_property_date2)] forKey:@"date2"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFSerializationTestObject_property_unixTimestamp)] forKey:@"unixTimestamp"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFSerializationTestObject_property_subObjects)] forKey:@"subObjects"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFSerializationTestObject_property_subDictionary)] forKey:@"subDictionary"];
    attributesSFSerializationTestObjectFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesSFSerializationTestObjectFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)SF_attributesForClass {
    NSMutableArray *SF_attributes_list__class_SFSerializationTestObject = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL__class_SFSerializationTestObject"];
    if (SF_attributes_list__class_SFSerializationTestObject != nil) {
        return SF_attributes_list__class_SFSerializationTestObject;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializable *attr1 = [[SFSerializable alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list__class_SFSerializationTestObject = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL__class_SFSerializationTestObject"];
    
    return SF_attributes_list__class_SFSerializationTestObject;
}

#pragma mark - 

@end
