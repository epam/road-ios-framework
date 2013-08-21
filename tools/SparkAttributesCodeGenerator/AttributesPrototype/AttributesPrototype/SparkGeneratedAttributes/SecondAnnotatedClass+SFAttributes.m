#import "SecondAnnotatedClass.h"
 
@interface SecondAnnotatedClass(SFAttribute)
 
@end
 
@implementation SecondAnnotatedClass(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Fields section)

static NSMutableArray __weak *sf_attributes_list_SecondAnnotatedClass_field__someField = nil;

+ (NSArray *)sf_attributes_SecondAnnotatedClass_field__someField {
    if (sf_attributes_list_SecondAnnotatedClass_field__someField != nil) {
        return sf_attributes_list_SecondAnnotatedClass_field__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list_SecondAnnotatedClass_field__someField = attributesArray;
    
    return sf_attributes_list_SecondAnnotatedClass_field__someField;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForFieldsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForFields {
    if (attributesSecondAnnotatedClassFactoriesForFieldsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForFieldsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForFields]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_field__someField)] forKey:@"_someField"];
    attributesSecondAnnotatedClassFactoriesForFieldsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForFieldsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *sf_attributes_list_SecondAnnotatedClass_property_window = nil;

+ (NSArray *)sf_attributes_SecondAnnotatedClass_property_window {
    if (sf_attributes_list_SecondAnnotatedClass_property_window != nil) {
        return sf_attributes_list_SecondAnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property2 = @"Text2";
    attr2.intProperty = (2+2)*2;
    [attributesArray addObject:attr2];

    sf_attributes_list_SecondAnnotatedClass_property_window = attributesArray;
    
    return sf_attributes_list_SecondAnnotatedClass_property_window;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)attributesFactoriesForProperties {
    if (attributesSecondAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForProperties]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_property_window)] forKey:@"window"];
    attributesSecondAnnotatedClassFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 = nil;

+ (NSArray *)sf_attributes_SecondAnnotatedClass_method_viewDidLoad_p0 {
    if (sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 != nil) {
        return sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.property2 = @"Text2";
    [attributesArray addObject:attr2];

    sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    
    return sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p0;
}

static NSMutableArray __weak *sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 = nil;

+ (NSArray *)sf_attributes_SecondAnnotatedClass_method_viewDidLoad_p1 {
    if (sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 != nil) {
        return sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    
    return sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForInstanceMethods {
    if (attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForInstanceMethods]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForInstanceMethodsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *sf_attributes_list__class_SecondAnnotatedClass = nil;

+ (NSArray *)attributesForClass {
    if (sf_attributes_list__class_SecondAnnotatedClass != nil) {
        return sf_attributes_list__class_SecondAnnotatedClass;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    ESDAttribute *attr1 = [[ESDAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomESDAttribute *attr2 = [[CustomESDAttribute alloc] init];
    attr2.property1 = @"Text1";
    [attributesArray addObject:attr2];

    sf_attributes_list__class_SecondAnnotatedClass = attributesArray;
    
    return sf_attributes_list__class_SecondAnnotatedClass;
}

#pragma mark - 

@end
