#import <Foundation/Foundation.h>
#import "RFTestAttribute.h"
#import "CustomRFTestAttribute.h"
#import "NSObject+RFAttributesInternal.h"
#import "SecondAnnotatedClass.h"
#import <ROAD/ROADCore.h>
 
@interface SecondAnnotatedClass(RFAttribute)
 
@end
 
@implementation SecondAnnotatedClass(RFAttribute)
 
#pragma mark - Fill Attributes generated code (Ivars section)

+ (NSArray *)RF_attributes_SecondAnnotatedClass_ivar__someField {
    NSMutableArray *RF_attributes_list_SecondAnnotatedClass_ivar__someField = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_SecondAnnotatedClass_ivar__someField"];
    if (RF_attributes_list_SecondAnnotatedClass_ivar__someField != nil) {
        return RF_attributes_list_SecondAnnotatedClass_ivar__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    RF_attributes_list_SecondAnnotatedClass_ivar__someField = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_SecondAnnotatedClass_ivar__someField"];
    
    return RF_attributes_list_SecondAnnotatedClass_ivar__someField;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForIvars {
    NSMutableDictionary *attributesSecondAnnotatedClassFactoriesForIvarsDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFSecondAnnotatedClassFactoriesForIvars"];
    if (attributesSecondAnnotatedClassFactoriesForIvarsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForIvarsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForIvars];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFSecondAnnotatedClassFactoriesForIvars"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_SecondAnnotatedClass_ivar__someField)] forKey:@"_someField"];
    attributesSecondAnnotatedClassFactoriesForIvarsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForIvarsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

+ (NSArray *)RF_attributes_SecondAnnotatedClass_property_window {
    NSMutableArray *RF_attributes_list_SecondAnnotatedClass_property_window = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_SecondAnnotatedClass_property_window"];
    if (RF_attributes_list_SecondAnnotatedClass_property_window != nil) {
        return RF_attributes_list_SecondAnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomRFTestAttribute *attr2 = [[CustomRFTestAttribute alloc] init];
    attr2.property2 = @"Text2";
    attr2.intProperty = (2 + 2) * 2;
    [attributesArray addObject:attr2];

    RF_attributes_list_SecondAnnotatedClass_property_window = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_SecondAnnotatedClass_property_window"];
    
    return RF_attributes_list_SecondAnnotatedClass_property_window;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForProperties {
    NSMutableDictionary *attributesSecondAnnotatedClassFactoriesForPropertiesDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFSecondAnnotatedClassFactoriesForProperties"];
    if (attributesSecondAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFSecondAnnotatedClassFactoriesForProperties"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_SecondAnnotatedClass_property_window)] forKey:@"window"];
    attributesSecondAnnotatedClassFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

+ (NSArray *)RF_attributes_SecondAnnotatedClass_method_viewDidLoad_p0 {
    NSMutableArray *RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_SecondAnnotatedClass_method_viewDidLoad_p0"];
    if (RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 != nil) {
        return RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomRFTestAttribute *attr2 = [[CustomRFTestAttribute alloc] init];
    attr2.property2 = @"Text2";
    attr2.property1 = @"Text1";
    [attributesArray addObject:attr2];

    RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_SecondAnnotatedClass_method_viewDidLoad_p0"];
    
    return RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0;
}

+ (NSArray *)RF_attributes_SecondAnnotatedClass_method_viewDidLoad_p1 {
    NSMutableArray *RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_SecondAnnotatedClass_method_viewDidLoad_p1"];
    if (RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 != nil) {
        return RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_SecondAnnotatedClass_method_viewDidLoad_p1"];
    
    return RF_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForMethods {
    NSMutableDictionary *attributesSecondAnnotatedClassFactoriesForMethodsDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFSecondAnnotatedClassFactoriesForMethods"];
    if (attributesSecondAnnotatedClassFactoriesForMethodsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFSecondAnnotatedClassFactoriesForMethods"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_SecondAnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_SecondAnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    attributesSecondAnnotatedClassFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForMethodsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)RF_attributesForClass {
    NSMutableArray *RF_attributes_list__class_SecondAnnotatedClass = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL__class_SecondAnnotatedClass"];
    if (RF_attributes_list__class_SecondAnnotatedClass != nil) {
        return RF_attributes_list__class_SecondAnnotatedClass;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomRFTestAttribute *attr2 = [[CustomRFTestAttribute alloc] init];
    attr2.property1 = @"Text1";
    [attributesArray addObject:attr2];

    RF_attributes_list__class_SecondAnnotatedClass = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL__class_SecondAnnotatedClass"];
    
    return RF_attributes_list__class_SecondAnnotatedClass;
}

#pragma mark - 

@end
