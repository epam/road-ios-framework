#import "SecondAnnotatedClass.h"
#import "NSObject+SFAttributesInternal.h"
 
@interface SecondAnnotatedClass(SFAttribute)
 
@end
 
@implementation SecondAnnotatedClass(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Ivars section)

static NSMutableArray __weak *sf_attributes_list_SecondAnnotatedClass_ivar__someField = nil;

+ (NSArray *)sf_attributes_SecondAnnotatedClass_ivar__someField {
    if (sf_attributes_list_SecondAnnotatedClass_ivar__someField != nil) {
        return sf_attributes_list_SecondAnnotatedClass_ivar__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list_SecondAnnotatedClass_ivar__someField = attributesArray;
    
    return sf_attributes_list_SecondAnnotatedClass_ivar__someField;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForIvarsDict = nil;
    
+ (NSDictionary *)SF_attributesFactoriesForIvars {
    if (attributesSecondAnnotatedClassFactoriesForIvarsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForIvarsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForIvars];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_ivar__someField)] forKey:@"_someField"];
    attributesSecondAnnotatedClassFactoriesForIvarsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForIvarsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *sf_attributes_list_SecondAnnotatedClass_property_window = nil;

+ (NSArray *)sf_attributes_SecondAnnotatedClass_property_window {
    if (sf_attributes_list_SecondAnnotatedClass_property_window != nil) {
        return sf_attributes_list_SecondAnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomSFTestAttribute *attr2 = [[CustomSFTestAttribute alloc] init];
    attr2.property2 = @"Text2";
    attr2.intProperty = (2+2)*2;
    [attributesArray addObject:attr2];

    sf_attributes_list_SecondAnnotatedClass_property_window = attributesArray;
    
    return sf_attributes_list_SecondAnnotatedClass_property_window;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)SF_attributesFactoriesForProperties {
    if (attributesSecondAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_property_window)] forKey:@"window"];
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
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomSFTestAttribute *attr2 = [[CustomSFTestAttribute alloc] init];
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
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    
    return sf_attributes_list_SecondAnnotatedClass_method_viewDidLoad_p1;
}

static NSMutableDictionary __weak *attributesSecondAnnotatedClassFactoriesForMethodsDict = nil;
    
+ (NSDictionary *)SF_attributesFactoriesForMethods {
    if (attributesSecondAnnotatedClassFactoriesForMethodsDict != nil) {
        return attributesSecondAnnotatedClassFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_SecondAnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    attributesSecondAnnotatedClassFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesSecondAnnotatedClassFactoriesForMethodsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *sf_attributes_list__class_SecondAnnotatedClass = nil;

+ (NSArray *)SF_attributesForClass {
    if (sf_attributes_list__class_SecondAnnotatedClass != nil) {
        return sf_attributes_list__class_SecondAnnotatedClass;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomSFTestAttribute *attr2 = [[CustomSFTestAttribute alloc] init];
    attr2.property1 = @"Text1";
    [attributesArray addObject:attr2];

    sf_attributes_list__class_SecondAnnotatedClass = attributesArray;
    
    return sf_attributes_list__class_SecondAnnotatedClass;
}

#pragma mark - 

@end
