#import "SecondAnnotatedClass.h"
 
@interface SecondAnnotatedClass(ESDAttribute)
 
@end
 
@implementation SecondAnnotatedClass(ESDAttribute)
 
#pragma mark - Fill Attributes generated code (Fields section)

static NSMutableArray __weak *esd_attributes_list_SecondAnnotatedClass_field__someField = nil;

+ (NSArray *)esd_attributes_SecondAnnotatedClass_field__someField {
    if (esd_attributes_list_SecondAnnotatedClass_field__someField != nil) {
        return esd_attributes_list_SecondAnnotatedClass_field__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    esd_attributes_list_SecondAnnotatedClass_field__someField = attributesArray;
    
    return esd_attributes_list_SecondAnnotatedClass_field__someField;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForFieldsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForFields {
    if (attributesSecondAnnotatedClassFactoriesForFieldsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForFieldsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForFields]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_SecondAnnotatedClass_field__someField)] forKey:@"_someField"];
    attributesSecondAnnotatedClassFactoriesForFieldsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForFieldsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *esd_attributes_list_SecondAnnotatedClass_property_window = nil;

+ (NSArray *)esd_attributes_SecondAnnotatedClass_property_window {
    if (esd_attributes_list_SecondAnnotatedClass_property_window != nil) {
        return esd_attributes_list_SecondAnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property2 = @"Text2";
    attr2.intProperty = (2+2)*2;
    [attributesArray addObject:attr2];

    esd_attributes_list_SecondAnnotatedClass_property_window = attributesArray;
    
    return esd_attributes_list_SecondAnnotatedClass_property_window;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)attributesFactoriesForProperties {
    if (attributesSecondAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForProperties]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_SecondAnnotatedClass_property_window)] forKey:@"window"];
    attributesSecondAnnotatedClassFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 = nil;

+ (NSArray *)esd_attributes_SecondAnnotatedClass_method_viewDidLoad_p0 {
    if (esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 != nil) {
        return esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.property2 = @"Text2";
    [attributesArray addObject:attr2];

    esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    
    return esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0;
}

static NSMutableArray __weak *esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 = nil;

+ (NSArray *)esd_attributes_SecondAnnotatedClass_method_viewDidLoad_p1 {
    if (esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 != nil) {
        return esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    
    return esd_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForInstanceMethods {
    if (attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForInstanceMethods]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_SecondAnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_SecondAnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict;
}


#pragma mark - 

@end
