#import "SFWebServiceClient.h"
#import "SFWebServiceErrorHandler.h"
#import "SFWebServiceHeader.h"
#import "SFWebServiceCall.h"
#import "SFWebServiceURLBuilder.h"
#import "SFODataWebServiceURLBuilder.h"
 
@interface SFConcreteWebServiceClient(SFAttribute)
 
@end
 
@implementation SFConcreteWebServiceClient(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *SF_attributes_list_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 = nil;

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2 {
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
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2;
}

static NSMutableArray __weak *SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 = nil;

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3 {
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
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3;
}

static NSMutableArray __weak *SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 = nil;

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4 {
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
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4;
}

static NSMutableArray __weak *SF_attributes_list_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 = nil;

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2 {
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
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2;
}

static NSMutableArray __weak *SF_attributes_list_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 = nil;

+ (NSArray *)SF_attributes_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2 {
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
    
    return SF_attributes_list_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2;
}

static NSMutableDictionary __weak *attributesSFConcreteWebServiceClientFactoriesForMethodsDict = nil;
    
+ (NSMutableDictionary *)SF_attributesFactoriesForMethods {
    if (attributesSFConcreteWebServiceClientFactoriesForMethodsDict != nil) {
        return attributesSFConcreteWebServiceClientFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testErrorHandlerRootWithSuccess_p2)] forKey:@"testErrorHandlerRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p3)] forKey:@"loadDataWithFetchRequest:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_loadDataWithFetchRequest_p4)] forKey:@"loadDataWithFetchRequest:someImportantParameter:success:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testSerializationRootWithSuccess_p2)] forKey:@"testSerializationRootWithSuccess:failure:"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(SF_attributes_SFConcreteWebServiceClient_method_testWrongSerializationRootWithSuccess_p2)] forKey:@"testWrongSerializationRootWithSuccess:failure:"];
    attributesSFConcreteWebServiceClientFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesSFConcreteWebServiceClientFactoriesForMethodsDict;
}


#pragma mark - 

@end
