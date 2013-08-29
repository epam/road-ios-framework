#import "SFSerializationTestObject.h"
 
@interface SFSerializationTestObject(SFAttribute)
 
@end
 
@implementation SFSerializationTestObject(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *sf_attributes_list_SFSerializationTestObject_property_string2 = nil;

+ (NSArray *)sf_attributes_SFSerializationTestObject_property_string2 {
    if (sf_attributes_list_SFSerializationTestObject_property_string2 != nil) {
        return sf_attributes_list_SFSerializationTestObject_property_string2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFDerived *attr1 = [[SFDerived alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list_SFSerializationTestObject_property_string2 = attributesArray;
    
    return sf_attributes_list_SFSerializationTestObject_property_string2;
}

static NSMutableArray __weak *sf_attributes_list_SFSerializationTestObject_property_date1 = nil;

+ (NSArray *)sf_attributes_SFSerializationTestObject_property_date1 {
    if (sf_attributes_list_SFSerializationTestObject_property_date1 != nil) {
        return sf_attributes_list_SFSerializationTestObject_property_date1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableDate *attr1 = [[SFSerializableDate alloc] init];
    attr1.format = @"dd/MM/yyyy HH:mm:ss Z";
    attr1.encodingFormat = @"MM.dd.yyyy HH:mm:ss.AAA Z";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFSerializationTestObject_property_date1 = attributesArray;
    
    return sf_attributes_list_SFSerializationTestObject_property_date1;
}

static NSMutableArray __weak *sf_attributes_list_SFSerializationTestObject_property_date2 = nil;

+ (NSArray *)sf_attributes_SFSerializationTestObject_property_date2 {
    if (sf_attributes_list_SFSerializationTestObject_property_date2 != nil) {
        return sf_attributes_list_SFSerializationTestObject_property_date2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableDate *attr1 = [[SFSerializableDate alloc] init];
    attr1.format = @"MM.dd.yyyy HH:mm";
    attr1.decodingFormat = @"MM.dd.yyyy HH:mm:ss";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFSerializationTestObject_property_date2 = attributesArray;
    
    return sf_attributes_list_SFSerializationTestObject_property_date2;
}

static NSMutableArray __weak *sf_attributes_list_SFSerializationTestObject_property_unixTimestamp = nil;

+ (NSArray *)sf_attributes_SFSerializationTestObject_property_unixTimestamp {
    if (sf_attributes_list_SFSerializationTestObject_property_unixTimestamp != nil) {
        return sf_attributes_list_SFSerializationTestObject_property_unixTimestamp;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableDate *attr1 = [[SFSerializableDate alloc] init];
    attr1.unixTimestamp = YES;
    [attributesArray addObject:attr1];

    sf_attributes_list_SFSerializationTestObject_property_unixTimestamp = attributesArray;
    
    return sf_attributes_list_SFSerializationTestObject_property_unixTimestamp;
}

static NSMutableArray __weak *sf_attributes_list_SFSerializationTestObject_property_subObjects = nil;

+ (NSArray *)sf_attributes_SFSerializationTestObject_property_subObjects {
    if (sf_attributes_list_SFSerializationTestObject_property_subObjects != nil) {
        return sf_attributes_list_SFSerializationTestObject_property_subObjects;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableCollection *attr1 = [[SFSerializableCollection alloc] init];
    attr1.classOfItem = [SFSerializationTestObject class];
    [attributesArray addObject:attr1];

    sf_attributes_list_SFSerializationTestObject_property_subObjects = attributesArray;
    
    return sf_attributes_list_SFSerializationTestObject_property_subObjects;
}

static NSMutableArray __weak *sf_attributes_list_SFSerializationTestObject_property_subDictionary = nil;

+ (NSArray *)sf_attributes_SFSerializationTestObject_property_subDictionary {
    if (sf_attributes_list_SFSerializationTestObject_property_subDictionary != nil) {
        return sf_attributes_list_SFSerializationTestObject_property_subDictionary;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializableCollection *attr1 = [[SFSerializableCollection alloc] init];
    attr1.classOfItem = [SFSerializationTestObject class];
    [attributesArray addObject:attr1];

    sf_attributes_list_SFSerializationTestObject_property_subDictionary = attributesArray;
    
    return sf_attributes_list_SFSerializationTestObject_property_subDictionary;
}

static NSMutableDictionary __weak *attributesSFSerializationTestObjectFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)attributesFactoriesForProperties {
    if (attributesSFSerializationTestObjectFactoriesForPropertiesDict != nil) {
        return attributesSFSerializationTestObjectFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForProperties]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFSerializationTestObject_property_string2)] forKey:@"string2"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFSerializationTestObject_property_date1)] forKey:@"date1"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFSerializationTestObject_property_date2)] forKey:@"date2"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFSerializationTestObject_property_unixTimestamp)] forKey:@"unixTimestamp"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFSerializationTestObject_property_subObjects)] forKey:@"subObjects"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFSerializationTestObject_property_subDictionary)] forKey:@"subDictionary"];
    attributesSFSerializationTestObjectFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesSFSerializationTestObjectFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *sf_attributes_list__class_SFSerializationTestObject = nil;

+ (NSArray *)attributesForClass {
    if (sf_attributes_list__class_SFSerializationTestObject != nil) {
        return sf_attributes_list__class_SFSerializationTestObject;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFSerializable *attr1 = [[SFSerializable alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list__class_SFSerializationTestObject = attributesArray;
    
    return sf_attributes_list__class_SFSerializationTestObject;
}

#pragma mark - 

@end
