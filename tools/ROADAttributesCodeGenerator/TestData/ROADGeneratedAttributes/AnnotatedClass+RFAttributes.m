#import <Foundation/Foundation.h>
#import "ESDAttribute.h"
#import "CustomESDAttribute.h"
#import <ROAD/ROADCore.h>
#import "AnnotatedClass.h"
#import <ROAD/ROADCore.h>
#import <ROAD/ROADCore.h>
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
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_ivar__someField = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_ivar__someField"];
    
    return RF_attributes_list_AnnotatedClass_ivar__someField;
}

+ (NSArray *)RF_attributes_AnnotatedClass_ivar__someField3 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_ivar__someField3 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_ivar__someField3"];
    if (RF_attributes_list_AnnotatedClass_ivar__someField3 != nil) {
        return RF_attributes_list_AnnotatedClass_ivar__someField3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_ivar__someField3 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_ivar__someField3"];
    
    return RF_attributes_list_AnnotatedClass_ivar__someField3;
}

+ (NSArray *)RF_attributes_AnnotatedClass_ivar__someField4 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_ivar__someField4 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_ivar__someField4"];
    if (RF_attributes_list_AnnotatedClass_ivar__someField4 != nil) {
        return RF_attributes_list_AnnotatedClass_ivar__someField4;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_ivar__someField4 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_ivar__someField4"];
    
    return RF_attributes_list_AnnotatedClass_ivar__someField4;
}

+ (NSArray *)RF_attributes_AnnotatedClass_ivar__testPropStore1 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_ivar__testPropStore1 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_ivar__testPropStore1"];
    if (RF_attributes_list_AnnotatedClass_ivar__testPropStore1 != nil) {
        return RF_attributes_list_AnnotatedClass_ivar__testPropStore1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    CustomESDAttribute *attr1 = [[CustomESDAttribute alloc] init];
    attr1.property1 = @"PropStore1Text";
    attr1.property2 = @"PropStore1Text2//";
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_ivar__testPropStore1 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_ivar__testPropStore1"];
    
    return RF_attributes_list_AnnotatedClass_ivar__testPropStore1;
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
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_ivar__someField3)] forKey:@"_someField3"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_ivar__someField4)] forKey:@"_someField4"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_ivar__testPropStore1)] forKey:@"_testPropStore1"];
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
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property2 = @"*/";
    attr2.intProperty = (2 + 2) * 2;
    [attributesArray addObject:attr2];

    RF_attributes_list_AnnotatedClass_property_window = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_property_window"];
    
    return RF_attributes_list_AnnotatedClass_property_window;
}

+ (NSArray *)RF_attributes_AnnotatedClass_property_window2 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_property_window2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_property_window2"];
    if (RF_attributes_list_AnnotatedClass_property_window2 != nil) {
        return RF_attributes_list_AnnotatedClass_property_window2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property2 = @"*/";
    attr2.intProperty = (2 + 2) * 2;
    [attributesArray addObject:attr2];

    RF_attributes_list_AnnotatedClass_property_window2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_property_window2"];
    
    return RF_attributes_list_AnnotatedClass_property_window2;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForProperties {
    NSMutableDictionary *attributesAnnotatedClassFactoriesForPropertiesDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAnnotatedClassFactoriesForProperties"];
    if (attributesAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFAnnotatedClassFactoriesForProperties"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_property_window)] forKey:@"window"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_property_window2)] forKey:@"window2"];
    attributesAnnotatedClassFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

+ (NSArray *)RF_attributes_AnnotatedClass_method_viewDidLoad_p0 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p0"];
    if (RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 != nil) {
        return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.property2 = @"Text2//";
    attr2.property3 = @"Text1";
    attr2.property4 = @"Text2//";
    attr2.property5 = @"Text1";
    attr2.property6 = @"Text2//";
    [attributesArray addObject:attr2];

    RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p0"];
    
    return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
}

+ (NSArray *)RF_attributes_AnnotatedClass_method_viewDidLoad_p1 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p1"];
    if (RF_attributes_list_AnnotatedClass_method_viewDidLoad_p1 != nil) {
        return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.property2 = @"/*";
    attr2.property1 = @"Text1";
    attr2.property2 = @"/*";
    [attributesArray addObject:attr2];

    RF_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p1"];
    
    return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
}

+ (NSArray *)RF_attributes_AnnotatedClass_method_viewDidLoad_p2 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_viewDidLoad_p2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p2"];
    if (RF_attributes_list_AnnotatedClass_method_viewDidLoad_p2 != nil) {
        return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFAttribute *attr1 = [[RFAttribute alloc] init];
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_method_viewDidLoad_p2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_viewDidLoad_p2"];
    
    return RF_attributes_list_AnnotatedClass_method_viewDidLoad_p2;
}

+ (NSArray *)RF_attributes_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2"];
    if (RF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 != nil) {
        return RF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.relativePath = @"%%0%%";
    [attributesArray addObject:attr1];

    RFWebServiceHeader *attr2 = [[RFWebServiceHeader alloc] init];
    attr2.hearderFields = @{@"Accept": @"application/json"};
    [attributesArray addObject:attr2];

    RFWebServiceErrorHandler *attr3 = [[RFWebServiceErrorHandler alloc] init];
    attr3.handlerClass = @"RFODataErrorHandler";
    [attributesArray addObject:attr3];

    RF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2"];
    
    return RF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2;
}

+ (NSArray *)RF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p3 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_loadDataWithFetchRequest_p3"];
    if (RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3 != nil) {
        return RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    [attributesArray addObject:attr1];

    RFWebServiceHeader *attr2 = [[RFWebServiceHeader alloc] init];
    attr2.hearderFields = @{@"Accept": @"application/json"};
    [attributesArray addObject:attr2];

    RFWebServiceURLBuilder *attr3 = [[RFWebServiceURLBuilder alloc] init];
    attr3.builderClass = [RFODataWebServiceURLBuilder class];
    [attributesArray addObject:attr3];

    RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_loadDataWithFetchRequest_p3"];
    
    return RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3;
}

+ (NSArray *)RF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p4 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_loadDataWithFetchRequest_p4"];
    if (RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4 != nil) {
        return RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.relativePath = @"?importantParameter=%%1%%";
    [attributesArray addObject:attr1];

    RFWebServiceURLBuilder *attr2 = [[RFWebServiceURLBuilder alloc] init];
    attr2.builderClass = [RFODataWebServiceURLBuilder class];
    [attributesArray addObject:attr2];

    RFWebServiceHeader *attr3 = [[RFWebServiceHeader alloc] init];
    attr3.hearderFields = @{@"Accept": @"application/json"};
    [attributesArray addObject:attr3];

    RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_loadDataWithFetchRequest_p4"];
    
    return RF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4;
}

+ (NSArray *)RF_attributes_AnnotatedClass_method_testSerializationRootWithSuccess_p2 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_testSerializationRootWithSuccess_p2"];
    if (RF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2 != nil) {
        return RF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_testSerializationRootWithSuccess_p2"];
    
    return RF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2;
}

+ (NSArray *)RF_attributes_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 {
    NSMutableArray *RF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2"];
    if (RF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 != nil) {
        return RF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon.localizedMessage.locale";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    RF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2"];
    
    return RF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForMethods {
    NSMutableDictionary *attributesAnnotatedClassFactoriesForMethodsDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAnnotatedClassFactoriesForMethods"];
    if (attributesAnnotatedClassFactoriesForMethodsDict != nil) {
        return attributesAnnotatedClassFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFAnnotatedClassFactoriesForMethods"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_viewDidLoad_p2)] forKey:@"viewDidLoad:param2:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2)] forKey:@"testErrorHandlerRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p3)] forKey:@"loadDataWithFetchRequest:success:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p4)] forKey:@"loadDataWithFetchRequest:someImportantParameter:success:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_testSerializationRootWithSuccess_p2)] forKey:@"testSerializationRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2)] forKey:@"testWrongSerializationRootWithSuccess:failure:"];
    attributesAnnotatedClassFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForMethodsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)RF_attributesForClass {
    NSMutableArray *RF_attributes_list__class_AnnotatedClass = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL__class_AnnotatedClass"];
    if (RF_attributes_list__class_AnnotatedClass != nil) {
        return RF_attributes_list__class_AnnotatedClass;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.dictionaryProperty = @{
                                    @"key1": @"[value1",
                                    @"key2": @"value2]"
                                    };
    attr2.arrayProperty = @[@'a', @'b', @'[', @'\'', @'[', @']', @'{', @'{', @'}', @'"', @'d', @'"'];
    attr2.blockProperty = ^(NSString *sInfo, int *result) {
                 if (sInfo == nil) {
                     *result = 1;
                     return;
                 }
                 
                 if ([sInfo length] == 0) {
                     *result = 2;
                     return;
                 }
                 
                 *result = 0;
             };
    [attributesArray addObject:attr2];

    RF_attributes_list__class_AnnotatedClass = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL__class_AnnotatedClass"];
    
    return RF_attributes_list__class_AnnotatedClass;
}

#pragma mark - 

@end
