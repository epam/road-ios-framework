#import "RFWebServiceClient.h"
#import "RFWebServiceErrorHandler.h"
#import "RFWebServiceHeader.h"
#import "RFWebServiceCall.h"
#import "RFWebServiceURLBuilder.h"
#import "RFODataWebServiceURLBuilder.h"
 
@interface RFConcreteWebServiceClient(RFAttribute)
 
@end
 
@implementation RFConcreteWebServiceClient(RFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

+ (NSArray *)RF_attributes_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 {
    NSMutableArray *RF_attributes_list_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2"];
    if (RF_attributes_list_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 != nil) {
        return RF_attributes_list_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.relativePath = @"%%0%%";
    [attributesArray addObject:attr1];

    RFWebServiceHeader *attr2 = [[RFWebServiceHeader alloc] init];
    attr2.hearderFields = @{@"Accept" : @"application/json"};
    [attributesArray addObject:attr2];

    RFWebServiceErrorHandler *attr3 = [[RFWebServiceErrorHandler alloc] init];
    attr3.handlerClass = @"RFODataErrorHandler";
    [attributesArray addObject:attr3];

    RF_attributes_list_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2"];
    
    return RF_attributes_list_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2;
}

+ (NSArray *)RF_attributes_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 {
    NSMutableArray *RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3"];
    if (RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 != nil) {
        return RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3;
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

    RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3"];
    
    return RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3;
}

+ (NSArray *)RF_attributes_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 {
    NSMutableArray *RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4"];
    if (RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 != nil) {
        return RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4;
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
    attr3.hearderFields = @{@"Accept" : @"application/json"};
    [attributesArray addObject:attr3];

    RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4"];
    
    return RF_attributes_list_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4;
}

+ (NSArray *)RF_attributes_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 {
    NSMutableArray *RF_attributes_list_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2"];
    if (RF_attributes_list_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 != nil) {
        return RF_attributes_list_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    RF_attributes_list_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2"];
    
    return RF_attributes_list_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2;
}

+ (NSArray *)RF_attributes_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 {
    NSMutableArray *RF_attributes_list_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFAL_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2"];
    if (RF_attributes_list_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 != nil) {
        return RF_attributes_list_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    RFWebServiceCall *attr1 = [[RFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon.localizedMessage.locale";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    RF_attributes_list_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 = attributesArray;
    [[RFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"RFAL_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2"];
    
    return RF_attributes_list_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2;
}

+ (NSMutableDictionary *)RF_attributesFactoriesForMethods {
    NSMutableDictionary *attributesRFConcreteWebServiceClientFactoriesForMethodsDict = [[RFAttributeCacheManager attributeCache] objectForKey:@"RFRFConcreteWebServiceClientFactoriesForMethods"];
    if (attributesRFConcreteWebServiceClientFactoriesForMethodsDict != nil) {
        return attributesRFConcreteWebServiceClientFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super RF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[RFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"RFRFConcreteWebServiceClientFactoriesForMethods"];
    }
    
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_RFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2)] forKey:@"testErrorHandlerRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3)] forKey:@"loadDataWithFetchRequest:success:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_RFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4)] forKey:@"loadDataWithFetchRequest:someImportantParameter:success:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_RFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2)] forKey:@"testSerializationRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self RF_invocationForSelector:@selector(RF_attributes_RFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2)] forKey:@"testWrongSerializationRootWithSuccess:failure:"];
    attributesRFConcreteWebServiceClientFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesRFConcreteWebServiceClientFactoriesForMethodsDict;
}


#pragma mark - 

@end
