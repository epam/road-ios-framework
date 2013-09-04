#import "SFODataAbstractEntity.h"
#import "SFODataEntity.h"
#import "SFODataProperty.h"
#import "SFODataTestEntity.h"
 
@interface SFODataTestEntity(SFAttribute)
 
@end
 
@implementation SFODataTestEntity(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *sf_attributes_list_SFODataTestEntity_property_name = nil;

+ (NSArray *)sf_attributes_SFODataTestEntity_property_name {
    if (sf_attributes_list_SFODataTestEntity_property_name != nil) {
        return sf_attributes_list_SFODataTestEntity_property_name;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"Name";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFODataTestEntity_property_name = attributesArray;
    
    return sf_attributes_list_SFODataTestEntity_property_name;
}

static NSMutableArray __weak *sf_attributes_list_SFODataTestEntity_property_date = nil;

+ (NSArray *)sf_attributes_SFODataTestEntity_property_date {
    if (sf_attributes_list_SFODataTestEntity_property_date != nil) {
        return sf_attributes_list_SFODataTestEntity_property_date;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"Date";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFODataTestEntity_property_date = attributesArray;
    
    return sf_attributes_list_SFODataTestEntity_property_date;
}

static NSMutableArray __weak *sf_attributes_list_SFODataTestEntity_property_cost = nil;

+ (NSArray *)sf_attributes_SFODataTestEntity_property_cost {
    if (sf_attributes_list_SFODataTestEntity_property_cost != nil) {
        return sf_attributes_list_SFODataTestEntity_property_cost;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"Cost";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFODataTestEntity_property_cost = attributesArray;
    
    return sf_attributes_list_SFODataTestEntity_property_cost;
}

static NSMutableArray __weak *sf_attributes_list_SFODataTestEntity_property_total = nil;

+ (NSArray *)sf_attributes_SFODataTestEntity_property_total {
    if (sf_attributes_list_SFODataTestEntity_property_total != nil) {
        return sf_attributes_list_SFODataTestEntity_property_total;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"TotalCost";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFODataTestEntity_property_total = attributesArray;
    
    return sf_attributes_list_SFODataTestEntity_property_total;
}

static NSMutableDictionary __weak *attributesSFODataTestEntityFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)attributesFactoriesForProperties {
    if (attributesSFODataTestEntityFactoriesForPropertiesDict != nil) {
        return attributesSFODataTestEntityFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForProperties]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFODataTestEntity_property_name)] forKey:@"name"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFODataTestEntity_property_date)] forKey:@"date"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFODataTestEntity_property_cost)] forKey:@"cost"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFODataTestEntity_property_total)] forKey:@"total"];
    attributesSFODataTestEntityFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesSFODataTestEntityFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *sf_attributes_list__class_SFODataTestEntity = nil;

+ (NSArray *)attributesForClass {
    if (sf_attributes_list__class_SFODataTestEntity != nil) {
        return sf_attributes_list__class_SFODataTestEntity;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataEntity *attr1 = [[SFODataEntity alloc] init];
    attr1.entityName = @"TestEntity";
    [attributesArray addObject:attr1];

    sf_attributes_list__class_SFODataTestEntity = attributesArray;
    
    return sf_attributes_list__class_SFODataTestEntity;
}

#pragma mark - 

@end
