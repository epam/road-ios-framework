#import "SFWebServiceClient.h"
#import "SFWebServiceErrorHandler.h"
#import "SFWebServiceHeader.h"
#import "SFWebServiceCall.h"
#import "SFWebServiceURLBuilder.h"
#import "SFODataWebServiceURLBuilder.h"
#import "SFFormData.h"
#import "SFMultipartData.h"
#import "SFConcreteWebServiceClient.h"
#import <Spark/SparkCore.h>
 
@interface SFConcreteWebServiceClient(SFAttribute)
 
@end
 
@implementation SFConcreteWebServiceClient(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2;
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

    SF_attributes_list_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2;
}

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3;
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

    SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3;
}

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4;
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

    SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4;
}

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    SF_attributes_list_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2;
}

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.serializationRoot = @"coord.lon.localizedMessage.locale";
    attr1.successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]];
    [attributesArray addObject:attr1];

    SF_attributes_list_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2;
}

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = YES;
    [attributesArray addObject:attr1];

    SFMultipartData *attr2 = [[SFMultipartData alloc] init];
    attr2.boundary = @"sdfsfsf";
    [attributesArray addObject:attr2];

    SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3;
}

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = YES;
    [attributesArray addObject:attr1];

    SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3;
}

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0 {
    NSMutableArray *SF_attributes_list_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0 = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0"];
    if (SF_attributes_list_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0 != nil) {
        return SF_attributes_list_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = YES;
    [attributesArray addObject:attr1];

    SF_attributes_list_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0 = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0"];
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0;
}

+ (NSMutableDictionary *)SF_attributesFactoriesForMethods {
    NSMutableDictionary *attributesSFConcreteWebServiceClientFactoriesForMethodsDict = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFSFConcreteWebServiceClientFactoriesForMethods"];
    if (attributesSFConcreteWebServiceClientFactoriesForMethodsDict != nil) {
        return attributesSFConcreteWebServiceClientFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
        [[SFAttributeCacheManager attributeCache] setObject:dictionaryHolder forKey:@"SFSFConcreteWebServiceClientFactoriesForMethods"];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2)] forKey:@"testErrorHandlerRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3)] forKey:@"loadDataWithFetchRequest:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4)] forKey:@"loadDataWithFetchRequest:someImportantParameter:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2)] forKey:@"testSerializationRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2)] forKey:@"testWrongSerializationRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testMultipartDataWithAttachment_p3)] forKey:@"testMultipartDataWithAttachment:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testMultipartDataWithAttachments_p3)] forKey:@"testMultipartDataWithAttachments:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testMethodWithoutBlocks_p0)] forKey:@"testMethodWithoutBlocks"];
    attributesSFConcreteWebServiceClientFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesSFConcreteWebServiceClientFactoriesForMethodsDict;
}


#pragma mark - 

@end
