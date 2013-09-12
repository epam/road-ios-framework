#import <Foundation/Foundation.h>
#import "ESDAttribute.h"
#import "CustomESDAttribute.h"
#import "AnnotatedClass.h"
 
@interface AnnotatedClass(SFAttribute)
 
@end
 
@implementation AnnotatedClass(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Ivars section)

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_ivar__someField = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_ivar__someField {
    if (SF_attributes_list_AnnotatedClass_ivar__someField != nil) {
        return SF_attributes_list_AnnotatedClass_ivar__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list_AnnotatedClass_ivar__someField = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_ivar__someField;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_ivar__someField3 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_ivar__someField3 {
    if (SF_attributes_list_AnnotatedClass_ivar__someField3 != nil) {
        return SF_attributes_list_AnnotatedClass_ivar__someField3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list_AnnotatedClass_ivar__someField3 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_ivar__someField3;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_ivar__someField4 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_ivar__someField4 {
    if (SF_attributes_list_AnnotatedClass_ivar__someField4 != nil) {
        return SF_attributes_list_AnnotatedClass_ivar__someField4;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list_AnnotatedClass_ivar__someField4 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_ivar__someField4;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_ivar__testPropStore1 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_ivar__testPropStore1 {
    if (SF_attributes_list_AnnotatedClass_ivar__testPropStore1 != nil) {
        return SF_attributes_list_AnnotatedClass_ivar__testPropStore1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    CustomESDAttribute *attr1 = [[CustomESDAttribute alloc] init];
    attr1.property1 = @"PropStore1Text";
    attr1.property2 = @"PropStore1Text2//";
    [attributesArray addObject:attr1];

    SF_attributes_list_AnnotatedClass_ivar__testPropStore1 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_ivar__testPropStore1;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForIvarsDict = nil;
    
+ (NSMutableDictionary *)SF_attributesFactoriesForIvars {
    if (attributesAnnotatedClassFactoriesForIvarsDict != nil) {
        return attributesAnnotatedClassFactoriesForIvarsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForIvars];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_ivar__someField)] forKey:@"_someField"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_ivar__someField3)] forKey:@"_someField3"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_ivar__someField4)] forKey:@"_someField4"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_ivar__testPropStore1)] forKey:@"_testPropStore1"];
    attributesAnnotatedClassFactoriesForIvarsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForIvarsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_property_window = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_property_window {
    if (SF_attributes_list_AnnotatedClass_property_window != nil) {
        return SF_attributes_list_AnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property2 = @"*/";
    attr2.intProperty = (2+2)*2;
    [attributesArray addObject:attr2];

    SF_attributes_list_AnnotatedClass_property_window = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_property_window;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_property_window2 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_property_window2 {
    if (SF_attributes_list_AnnotatedClass_property_window2 != nil) {
        return SF_attributes_list_AnnotatedClass_property_window2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property2 = @"*/";
    attr2.intProperty = (2+2)*2;
    [attributesArray addObject:attr2];

    SF_attributes_list_AnnotatedClass_property_window2 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_property_window2;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForPropertiesDict = nil;
    
+ (NSMutableDictionary *)SF_attributesFactoriesForProperties {
    if (attributesAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_property_window)] forKey:@"window"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_property_window2)] forKey:@"window2"];
    attributesAnnotatedClassFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_viewDidLoad_p0 {
    if (SF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 != nil) {
        return SF_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
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

    SF_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_viewDidLoad_p1 {
    if (SF_attributes_list_AnnotatedClass_method_viewDidLoad_p1 != nil) {
        return SF_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
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

    SF_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_viewDidLoad_p2 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_viewDidLoad_p2 {
    if (SF_attributes_list_AnnotatedClass_method_viewDidLoad_p2 != nil) {
        return SF_attributes_list_AnnotatedClass_method_viewDidLoad_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFAttribute *attr1 = [[SFAttribute alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list_AnnotatedClass_method_viewDidLoad_p2 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_viewDidLoad_p2;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 {
    if (SF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 != nil) {
        return SF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.relativePath = @"%%0%%";
    [attributesArray addObject:attr1];

    SFWebServiceHeader *attr2 = [[SFWebServiceHeader alloc] init];
    attr2.hearderFields = @{@"Accept" : @"application/json"};
    [attributesArray addObject:attr2];

    SFWebServiceErrorHandler *attr3 = [[SFWebServiceErrorHandler alloc] init];
    attr3.handlerClass = @"SFODataErrorHandler";
    [attributesArray addObject:attr3];

    SF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p3 {
    if (SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3 != nil) {
        return SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    [attributesArray addObject:attr1];

    SFWebServiceHeader *attr2 = [[SFWebServiceHeader alloc] init];
    attr2.hearderFields = @{@"Accept": @"application/json"};
    [attributesArray addObject:attr2];

    SFWebServiceURLBuilder *attr3 = [[SFWebServiceURLBuilder alloc] init];
    attr3.builderClass = [SFODataWebServiceURLBuilder class];
    [attributesArray addObject:attr3];

    SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p3;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p4 {
    if (SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4 != nil) {
        return SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.relativePath = @"?importantParameter=%%1%%";
    [attributesArray addObject:attr1];

    SFWebServiceURLBuilder *attr2 = [[SFWebServiceURLBuilder alloc] init];
    attr2.builderClass = [SFODataWebServiceURLBuilder class];
    [attributesArray addObject:attr2];

    SFWebServiceHeader *attr3 = [[SFWebServiceHeader alloc] init];
    attr3.hearderFields = @{@"Accept" : @"application/json"};
    [attributesArray addObject:attr3];

    SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_loadDataWithFetchRequest_p4;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_testSerializationRootWithSuccess_p2 {
    if (SF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2 != nil) {
        return SF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    SF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_testSerializationRootWithSuccess_p2;
}

static NSMutableArray __weak *SF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 = nil;

+ (NSArray *)SF_attributes_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 {
    if (SF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 != nil) {
        return SF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon.localizedMessage.locale";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    SF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2 = attributesArray;
    
    return SF_attributes_list_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForMethodsDict = nil;
    
+ (NSMutableDictionary *)SF_attributesFactoriesForMethods {
    if (attributesAnnotatedClassFactoriesForMethodsDict != nil) {
        return attributesAnnotatedClassFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_viewDidLoad_p2)] forKey:@"viewDidLoad:param2:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_testErrorHandlerRootWithSuccess_p2)] forKey:@"testErrorHandlerRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p3)] forKey:@"loadDataWithFetchRequest:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_loadDataWithFetchRequest_p4)] forKey:@"loadDataWithFetchRequest:someImportantParameter:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_testSerializationRootWithSuccess_p2)] forKey:@"testSerializationRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_AnnotatedClass_method_testWrongSerializationRootWithSuccess_p2)] forKey:@"testWrongSerializationRootWithSuccess:failure:"];
    attributesAnnotatedClassFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForMethodsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *SF_attributes_list__class_AnnotatedClass = nil;

+ (NSArray *)SF_attributesForClass {
    if (SF_attributes_list__class_AnnotatedClass != nil) {
        return SF_attributes_list__class_AnnotatedClass;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.dictionaryProperty = @{
                @"key1" : @"[value1",
                @"key2" : @"value2]"
              };
    attr2.arrayProperty = @[@'a',@'b',@'[', @'\'', @'[', @']', @'{', @'{', @'}', @'"', @'d', @'"'];
    attr2.blockProperty = ^(NSString* sInfo, int *result) {
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

    SF_attributes_list__class_AnnotatedClass = attributesArray;
    
    return SF_attributes_list__class_AnnotatedClass;
}

#pragma mark - 

@end
