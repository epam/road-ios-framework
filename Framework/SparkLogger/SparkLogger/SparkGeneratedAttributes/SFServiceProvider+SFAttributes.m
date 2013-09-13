#import <Spark/SparkServices.h>
#import "SFLogger.h"
#import <Spark/SparkServices.h>
#import "SparkLogger.h"
#import "SFServiceProvider+SFLogger.h"
 
@interface SFServiceProvider(SFAttribute)
 
@end
 
@implementation SFServiceProvider(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *sf_attributes_list_SFServiceProvider_method_logger_p0 = nil;

+ (NSArray *)sf_attributes_SFServiceProvider_method_logger_p0 {
    if (sf_attributes_list_SFServiceProvider_method_logger_p0 != nil) {
        return sf_attributes_list_SFServiceProvider_method_logger_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFService *attr1 = [[SFService alloc] init];
    attr1.serviceClass = [SFLogger class];
    attr1.serviceClass = [SFLogger class];
    [attributesArray addObject:attr1];

    sf_attributes_list_SFServiceProvider_method_logger_p0 = attributesArray;
    
    return sf_attributes_list_SFServiceProvider_method_logger_p0;
}

static NSMutableDictionary __weak *attributesSFServiceProviderFactoriesForMethodsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForMethods {
    if (attributesSFServiceProviderFactoriesForMethodsDict != nil) {
        return attributesSFServiceProviderFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForMethods]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFServiceProvider_method_logger_p0)] forKey:@"logger"];
    attributesSFServiceProviderFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesSFServiceProviderFactoriesForMethodsDict;
}


#pragma mark - 

@end
