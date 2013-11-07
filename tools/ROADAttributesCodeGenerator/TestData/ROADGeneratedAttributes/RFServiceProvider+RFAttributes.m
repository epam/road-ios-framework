#import <ROAD/ROADServices.h>
#import "ODataWebClient.h"
 
@interface RFServiceProvider(RFAttribute)
 
@end
 
@implementation RFServiceProvider(RFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

+ (NSArray *)RF_attributes_RFServiceProvider_method_odataWebClient_p0 {
    NSMutableArray *RF_attributes_list_RFServiceProvider_method_odataWebClient_p0 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_RFServiceProvider_method_odataWebClient_p0"];
    if (RF_attributes_list_RFServiceProvider_method_odataWebClient_p0 != nil) {
        return RF_attributes_list_RFServiceProvider_method_odataWebClient_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFService *attr1 = [[RFService alloc] init];
    attr1.serviceClass = [[ODataWebClient class];
    [attributesArray addObject:attr1];

    RF_attributes_list_RFServiceProvider_method_odataWebClient_p0 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_RFServiceProvider_method_odataWebClient_p0"];
    
    return RF_attributes_list_RFServiceProvider_method_odataWebClient_p0;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForMethods {
    NSMutableDictionary *attributesRFServiceProviderFactoriesForMethodsDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFRFServiceProviderFactoriesForMethods"];
    if (attributesRFServiceProviderFactoriesForMethodsDict != nil) {
        return attributesRFServiceProviderFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFRFServiceProviderFactoriesForMethods"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_RFServiceProvider_method_odataWebClient_p0)] forKey:@"odataWebClient"];
    attributesRFServiceProviderFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesRFServiceProviderFactoriesForMethodsDict;
}


#pragma mark - 

@end
