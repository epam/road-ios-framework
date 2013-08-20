#import "AnnotatedClass.h"
 
@interface AnnotatedClass(ESDAttribute)
 
@end
 
@implementation AnnotatedClass(ESDAttribute)
 
#pragma mark - Fill Attributes generated code (Fields section)

static NSMutableArray __weak *esd_attributes_list_AnnotatedClass_field__someField = nil;

+ (NSArray *)esd_attributes_AnnotatedClass_field__someField {
    if (esd_attributes_list_AnnotatedClass_field__someField != nil) {
        return esd_attributes_list_AnnotatedClass_field__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    esd_attributes_list_AnnotatedClass_field__someField = attributesArray;
    
    return esd_attributes_list_AnnotatedClass_field__someField;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForFieldsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForFields {
    if (attributesAnnotatedClassFactoriesForFieldsDict != nil) {
        return attributesAnnotatedClassFactoriesForFieldsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForFields]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_AnnotatedClass_field__someField)] forKey:@"_someField"];
    attributesAnnotatedClassFactoriesForFieldsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForFieldsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *esd_attributes_list_AnnotatedClass_property_window = nil;

+ (NSArray *)esd_attributes_AnnotatedClass_property_window {
    if (esd_attributes_list_AnnotatedClass_property_window != nil) {
        return esd_attributes_list_AnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property2 = @"Text2";
    attr2.intProperty = (2+2)*2;
    [attributesArray addObject:attr2];

    esd_attributes_list_AnnotatedClass_property_window = attributesArray;
    
    return esd_attributes_list_AnnotatedClass_property_window;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)attributesFactoriesForProperties {
    if (attributesAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForProperties]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_AnnotatedClass_property_window)] forKey:@"window"];
    attributesAnnotatedClassFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *esd_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = nil;

+ (NSArray *)esd_attributes_AnnotatedClass_method_viewDidLoad_p0 {
    if (esd_attributes_list_AnnotatedClass_method_viewDidLoad_p0 != nil) {
        return esd_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.property2 = @"Text2";
    [attributesArray addObject:attr2];

    esd_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    
    return esd_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
}

static NSMutableArray __weak *esd_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = nil;

+ (NSArray *)esd_attributes_AnnotatedClass_method_viewDidLoad_p1 {
    if (esd_attributes_list_AnnotatedClass_method_viewDidLoad_p1 != nil) {
        return esd_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    esd_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    
    return esd_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForInstanceMethodsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForInstanceMethods {
    if (attributesAnnotatedClassFactoriesForInstanceMethodsDict != nil) {
        return attributesAnnotatedClassFactoriesForInstanceMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForInstanceMethods]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_AnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(esd_attributes_AnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    attributesAnnotatedClassFactoriesForInstanceMethodsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForInstanceMethodsDict;
}


#pragma mark - 

@end
