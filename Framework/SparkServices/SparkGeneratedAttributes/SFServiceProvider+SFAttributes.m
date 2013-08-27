#import "SFServiceProvider.h"
#import <objc/runtime.h>
#import <Spark/SparkReflection.h>
#import "SFServiceProvider+SFTestService.h"
 
@interface SFServiceProvider(SFAttribute)
 
@end
 
@implementation SFServiceProvider(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *sf_attributes_list_SFServiceProvider_method_serviceInstance_p0 = nil;

+ (NSArray *)sf_attributes_SFServiceProvider_method_serviceInstance_p0 {
    if (sf_attributes_list_SFServiceProvider_method_serviceInstance_p0 != nil) {
        return sf_attributes_list_SFServiceProvider_method_serviceInstance_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFService *attr1 = [[SFService alloc] init];
    attr1.serviceClass = [SFTestService class];
    [attributesArray addObject:attr1];

    sf_attributes_list_SFServiceProvider_method_serviceInstance_p0 = attributesArray;
    
    return sf_attributes_list_SFServiceProvider_method_serviceInstance_p0;
}

static NSMutableDictionary __weak *attributesSFServiceProviderFactoriesForInstanceMethodsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForInstanceMethods {
    if (attributesSFServiceProviderFactoriesForInstanceMethodsDict != nil) {
        return attributesSFServiceProviderFactoriesForInstanceMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForInstanceMethods]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFServiceProvider_method_serviceInstance_p0)] forKey:@"serviceInstance"];
    attributesSFServiceProviderFactoriesForInstanceMethodsDict = dictionaryHolder;  
    
    return attributesSFServiceProviderFactoriesForInstanceMethodsDict;
}


#pragma mark - 

@end
