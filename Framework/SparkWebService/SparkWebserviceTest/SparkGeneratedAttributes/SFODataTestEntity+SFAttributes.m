#import "SFODataAbstractEntity.h"
#import "SFODataEntity.h"
#import "SFODataProperty.h"
#import "SFODataTestEntity.h"
#import <Spark/SparkCore.h>
 
@interface SFODataTestEntity(SFAttribute)
 
@end
 
@implementation SFODataTestEntity(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Properties section)

+ (NSArray *)SF_attributes_SFODataTestEntity_property_name {
    NSMutableArray *SF_attributes_list_SFODataTestEntity_property_name = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFODataTestEntity_property_name"];
    if (SF_attributes_list_SFODataTestEntity_property_name != nil) {
        return SF_attributes_list_SFODataTestEntity_property_name;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"Name";
    [attributesArray addObject:attr1];

    SF_attributes_list_SFODataTestEntity_property_name = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFODataTestEntity_property_name"];
    
    return SF_attributes_list_SFODataTestEntity_property_name;
}

+ (NSArray *)SF_attributes_SFODataTestEntity_property_date {
    NSMutableArray *SF_attributes_list_SFODataTestEntity_property_date = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFODataTestEntity_property_date"];
    if (SF_attributes_list_SFODataTestEntity_property_date != nil) {
        return SF_attributes_list_SFODataTestEntity_property_date;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"Date";
    [attributesArray addObject:attr1];

    SF_attributes_list_SFODataTestEntity_property_date = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFODataTestEntity_property_date"];
    
    return SF_attributes_list_SFODataTestEntity_property_date;
}

+ (NSArray *)SF_attributes_SFODataTestEntity_property_cost {
    NSMutableArray *SF_attributes_list_SFODataTestEntity_property_cost = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFODataTestEntity_property_cost"];
    if (SF_attributes_list_SFODataTestEntity_property_cost != nil) {
        return SF_attributes_list_SFODataTestEntity_property_cost;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"Cost";
    [attributesArray addObject:attr1];

    SF_attributes_list_SFODataTestEntity_property_cost = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFODataTestEntity_property_cost"];
    
    return SF_attributes_list_SFODataTestEntity_property_cost;
}

+ (NSArray *)SF_attributes_SFODataTestEntity_property_total {
    NSMutableArray *SF_attributes_list_SFODataTestEntity_property_total = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFODataTestEntity_property_total"];
    if (SF_attributes_list_SFODataTestEntity_property_total != nil) {
        return SF_attributes_list_SFODataTestEntity_property_total;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataProperty *attr1 = [[SFODataProperty alloc] init];
    attr1.serializationKey = @"TotalCost";
    [attributesArray addObject:attr1];

    SF_attributes_list_SFODataTestEntity_property_total = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFODataTestEntity_property_total"];
    
    return SF_attributes_list_SFODataTestEntity_property_total;
}

+ (NSMutableDictionary *)SF_attributesFactoriesForProperties {
    NSMutableDictionary *attributesSFODataTestEntityFactoriesForPropertiesDict = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFSFODataTestEntityFactoriesForProperties"];
    if (attributesSFODataTestEntityFactoriesForPropertiesDict != nil) {
        return attributesSFODataTestEntityFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[SFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"SFSFODataTestEntityFactoriesForProperties"];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFODataTestEntity_property_name)] forKey:@"name"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFODataTestEntity_property_date)] forKey:@"date"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFODataTestEntity_property_cost)] forKey:@"cost"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFODataTestEntity_property_total)] forKey:@"total"];
    attributesSFODataTestEntityFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesSFODataTestEntityFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)SF_attributesForClass {
    NSMutableArray *SF_attributes_list__class_SFODataTestEntity = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL__class_SFODataTestEntity"];
    if (SF_attributes_list__class_SFODataTestEntity != nil) {
        return SF_attributes_list__class_SFODataTestEntity;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFODataEntity *attr1 = [[SFODataEntity alloc] init];
    attr1.entityName = @"TestEntity";
    [attributesArray addObject:attr1];

    SF_attributes_list__class_SFODataTestEntity = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL__class_SFODataTestEntity"];
    
    return SF_attributes_list__class_SFODataTestEntity;
}

#pragma mark - 

@end
