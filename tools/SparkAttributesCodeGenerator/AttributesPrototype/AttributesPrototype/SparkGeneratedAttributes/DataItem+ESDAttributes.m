#import "DataItem.h"
 
@interface DataItem(ESDAttribute)
 
@end
 
@implementation DataItem(ESDAttribute)
 
#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *esd_attributes_list_DataItem_property_intProperty1 = nil;

+ (NSArray *)esd_attributes_DataItem_property_intProperty1 {
    if (esd_attributes_list_DataItem_property_intProperty1 != nil) {
        return esd_attributes_list_DataItem_property_intProperty1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    IncrementValueESDAttribute *attr1 = [[IncrementValueESDAttribute alloc] init];
    attr1.intValue = 1;
    [attributesArray addObject:attr1];

    esd_attributes_list_DataItem_property_intProperty1 = attributesArray;
    
    return esd_attributes_list_DataItem_property_intProperty1;
}

static NSMutableArray __weak *esd_attributes_list_DataItem_property_intProperty2 = nil;

+ (NSArray *)esd_attributes_DataItem_property_intProperty2 {
    if (esd_attributes_list_DataItem_property_intProperty2 != nil) {
        return esd_attributes_list_DataItem_property_intProperty2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    IncrementValueESDAttribute *attr1 = [[IncrementValueESDAttribute alloc] init];
    attr1.intValue = 3;
    [attributesArray addObject:attr1];

    esd_attributes_list_DataItem_property_intProperty2 = attributesArray;
    
    return esd_attributes_list_DataItem_property_intProperty2;
}

static NSMutableArray __weak *esd_attributes_list_DataItem_property_intProperty3 = nil;

+ (NSArray *)esd_attributes_DataItem_property_intProperty3 {
    if (esd_attributes_list_DataItem_property_intProperty3 != nil) {
        return esd_attributes_list_DataItem_property_intProperty3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    IncrementValueESDAttribute *attr1 = [[IncrementValueESDAttribute alloc] init];
    attr1.intValue = 2;
    [attributesArray addObject:attr1];

    esd_attributes_list_DataItem_property_intProperty3 = attributesArray;
    
    return esd_attributes_list_DataItem_property_intProperty3;
}

static NSMutableDictionary __weak *attributesDataItemFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)attributesFactoriesForProperties {
    if (attributesDataItemFactoriesForPropertiesDict != nil) {
        return attributesDataItemFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForProperties]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_DataItem_property_intProperty1)] forKey:@"intProperty1"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_DataItem_property_intProperty2)] forKey:@"intProperty2"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_DataItem_property_intProperty3)] forKey:@"intProperty3"];
    attributesDataItemFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesDataItemFactoriesForPropertiesDict;
}


#pragma mark - 

@end
