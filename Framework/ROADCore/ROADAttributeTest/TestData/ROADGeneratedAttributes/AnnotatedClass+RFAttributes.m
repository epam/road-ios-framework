#import "AnnotatedClass.h"
#import <ROAD/ROADCore.h>
 
@interface AnnotatedClass(RFAttribute)
 
@end
 
@implementation AnnotatedClass(RFAttribute)
 
#pragma mark - Fill Attributes generated code (Ivars section)

+ (NSArray *)RF_attributes_AnnotatedClass_ivar__someField {
    NSMutableArray *RF_attributes_list_AnnotatedClass_ivar__someField = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_ivar__someField"];
    if (RF_attributes_list_AnnotatedClass_ivar__someField != nil) {
        return RF_attributes_list_AnnotatedClass_ivar__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_ivar__someField = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_ivar__someField"];
    
    return RF_attributes_list_AnnotatedClass_ivar__someField;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForIvars {
    NSMutableDictionary *attributesAnnotatedClassFactoriesForIvarsDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAnnotatedClassFactoriesForIvars"];
    if (attributesAnnotatedClassFactoriesForIvarsDict != nil) {
        return attributesAnnotatedClassFactoriesForIvarsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForIvars];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFAnnotatedClassFactoriesForIvars"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_ivar__someField)] forKey:@"_someField"];
    attributesAnnotatedClassFactoriesForIvarsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForIvarsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

+ (NSArray *)RF_attributes_AnnotatedClass_property_window {
    NSMutableArray *RF_attributes_list_AnnotatedClass_property_window = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_property_window"];
    if (RF_attributes_list_AnnotatedClass_property_window != nil) {
        return RF_attributes_list_AnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomRFTestAttribute *attr2 = [[CustomRFTestAttribute alloc] init];
    attr2.property2 = @"TestStringForProp";
    attr2.property1 = @"TestStringForProp";
    [attributesArray addObject:attr2];

    RF_attributes_list_AnnotatedClass_property_window = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_property_window"];
    
    return RF_attributes_list_AnnotatedClass_property_window;
}

+ (NSArray *)RF_attributes_TestProtocol_property_prop {
    NSMutableArray *RF_attributes_list_TestProtocol_property_prop = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_TestProtocol_property_prop"];
    if (RF_attributes_list_TestProtocol_property_prop != nil) {
        return RF_attributes_list_TestProtocol_property_prop;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomRFTestAttribute *attr2 = [[CustomRFTestAttribute alloc] init];
    attr2.property2 = @"TestStringForProp2ForProperty";
    attr2.intProperty = (2 + 2) * 2;
    [attributesArray addObject:attr2];

    RF_attributes_list_TestProtocol_property_prop = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_TestProtocol_property_prop"];
    
    return RF_attributes_list_TestProtocol_property_prop;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForProperties {
    NSMutableDictionary *attributesTestProtocolFactoriesForPropertiesDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFTestProtocolFactoriesForProperties"];
    if (attributesTestProtocolFactoriesForPropertiesDict != nil) {
        return attributesTestProtocolFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFTestProtocolFactoriesForProperties"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_property_window)] forKey:@"window"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_TestProtocol_property_prop)] forKey:@"prop"];
    attributesTestProtocolFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesTestProtocolFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

+ (NSArray *)RF_attributes_AnnotatedClass_method_viewDidLoad_p0 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p0"];
    if (RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 != nil) {
        return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomRFTestAttribute *attr2 = [[CustomRFTestAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.property2 = @"Text2";
    [attributesArray addObject:attr2];

    RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p0"];
    
    return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
}

+ (NSArray *)RF_attributes_TestProtocol_method_doSmth_p0 {
    NSMutableArray *RF_attributes_list_TestProtocol_method_doSmth_p0 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_TestProtocol_method_doSmth_p0"];
    if (RF_attributes_list_TestProtocol_method_doSmth_p0 != nil) {
        return RF_attributes_list_TestProtocol_method_doSmth_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    RFTestAttribute *attr1 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomRFTestAttribute *attr2 = [[CustomRFTestAttribute alloc] init];
    attr2.property2 = @"TestStringForProp2ForMethod";
    attr2.property1 = @"TestStringForProp1ForMethod";
    [attributesArray addObject:attr2];

    RF_attributes_list_TestProtocol_method_doSmth_p0 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_TestProtocol_method_doSmth_p0"];
    
    return RF_attributes_list_TestProtocol_method_doSmth_p0;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForMethods {
    NSMutableDictionary *attributesTestProtocolFactoriesForMethodsDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFTestProtocolFactoriesForMethods"];
    if (attributesTestProtocolFactoriesForMethodsDict != nil) {
        return attributesTestProtocolFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFTestProtocolFactoriesForMethods"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_TestProtocol_method_doSmth_p0)] forKey:@"doSmth"];
    attributesTestProtocolFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesTestProtocolFactoriesForMethodsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)RF_attributesForClass {
    NSMutableArray *RF_attributes_list__class_AnnotatedClass = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL__class_AnnotatedClass"];
    if (RF_attributes_list__class_AnnotatedClass != nil) {
        return RF_attributes_list__class_AnnotatedClass;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    NSObject *attr1 = [[NSObject alloc] init];
    [attributesArray addObject:attr1];

    RFTestAttribute *attr2 = [[RFTestAttribute alloc] init];
    [attributesArray addObject:attr2];

    CustomRFTestAttribute *attr3 = [[CustomRFTestAttribute alloc] init];
    attr3.property2 = @"TestStringForProp2ForProtocol";
    attr3.property1 = @"TestStringForProp1ForProtocol";
    [attributesArray addObject:attr3];

    RF_attributes_list__class_AnnotatedClass = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL__class_AnnotatedClass"];
    
    return RF_attributes_list__class_AnnotatedClass;
}

#pragma mark - 

@end
