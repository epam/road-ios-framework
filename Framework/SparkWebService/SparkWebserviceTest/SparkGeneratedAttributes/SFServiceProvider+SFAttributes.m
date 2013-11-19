#import <Spark/SparkServices.h>
#import "SFConcreteWebServiceClient.h"
 
@interface SFServiceProvider(SFAttribute)
 
@end
 
@implementation SFServiceProvider(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

+ (NSArray *)SF_attributes_SFServiceProvider_method_concreteWebServiceClient_p0 {
    NSMutableArray *SF_attributes_list_SFServiceProvider_method_concreteWebServiceClient_p0 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFServiceProvider_method_concreteWebServiceClient_p0"];
    if (SF_attributes_list_SFServiceProvider_method_concreteWebServiceClient_p0 != nil) {
        return SF_attributes_list_SFServiceProvider_method_concreteWebServiceClient_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFService *attr1 = [[SFService alloc] init];
    attr1.serviceClass = [SFConcreteWebServiceClient class];
    [attributesArray addObject:attr1];

    SF_attributes_list_SFServiceProvider_method_concreteWebServiceClient_p0 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFServiceProvider_method_concreteWebServiceClient_p0"];
    
    return SF_attributes_list_SFServiceProvider_method_concreteWebServiceClient_p0;
}

+ (NSMutableDictionary *)SF_attributesFactoriesForMethods {
    NSMutableDictionary *attributesSFServiceProviderFactoriesForMethodsDict = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFSFServiceProviderFactoriesForMethods"];
    if (attributesSFServiceProviderFactoriesForMethodsDict != nil) {
        return attributesSFServiceProviderFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[SFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"SFSFServiceProviderFactoriesForMethods"];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFServiceProvider_method_concreteWebServiceClient_p0)] forKey:@"concreteWebServiceClient"];
    attributesSFServiceProviderFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesSFServiceProviderFactoriesForMethodsDict;
}


#pragma mark - 

@end
