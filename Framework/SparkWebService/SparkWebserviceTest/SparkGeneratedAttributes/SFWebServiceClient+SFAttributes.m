#import <objc/runtime.h>
#import "SFWebServiceCall.h"
#import "SFWebServiceClient+DynamicMethod.h"
#import <Spark/SparkSerialization.h>
#import <Spark/SparkServices.h>
#import "SFWebServiceCancellable.h"
#import "SFSerializationDelegate.h"
#import "SFWebServiceCallParameterEncoder.h"
#import "SFWebServiceHeader.h"
#import "SFDownloader.h"
#import "SFWebServiceLogger.h"
#import "SFWebServiceURLBuilder.h"
#import "SFWebServiceSerializationHandler.h"
#import "SFWebServiceClientStatusCodes.h"
#import "SFBasicAuthenticationProvider.h"
#import "SFAuthenticating.h"
#import "SFWebServiceBasicURLBuilder.h"
#import "SFWebServiceClient.h"
#import "SFDefaultSerializer.h"
#import "SFAuthenticating.h"
#import "SFWebServiceClient+DynamicTest.h"
 
@interface SFWebServiceClient(SFAttribute)
 
@end
 
@implementation SFWebServiceClient(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpRequestPath_p3 = nil;

+ (NSArray *)sf_attributes_SFWebServiceClient_method_dynamicTestHttpRequestPath_p3 {
    if (sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpRequestPath_p3 != nil) {
        return sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpRequestPath_p3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = YES;
    attr1.method = @"GET";
    attr1.relativePath = @"%%0%%";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpRequestPath_p3 = attributesArray;
    
    return sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpRequestPath_p3;
}

static NSMutableArray __weak *sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpsRequestPath_p3 = nil;

+ (NSArray *)sf_attributes_SFWebServiceClient_method_dynamicTestHttpsRequestPath_p3 {
    if (sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpsRequestPath_p3 != nil) {
        return sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpsRequestPath_p3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled = NO;
    attr1.method = @"GET";
    attr1.relativePath = @"%%0%%";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpsRequestPath_p3 = attributesArray;
    
    return sf_attributes_list_SFWebServiceClient_method_dynamicTestHttpsRequestPath_p3;
}

static NSMutableArray __weak *sf_attributes_list_SFWebServiceClient_method_dynamicDownloadTest_p3 = nil;

+ (NSArray *)sf_attributes_SFWebServiceClient_method_dynamicDownloadTest_p3 {
    if (sf_attributes_list_SFWebServiceClient_method_dynamicDownloadTest_p3 != nil) {
        return sf_attributes_list_SFWebServiceClient_method_dynamicDownloadTest_p3;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.relativePath = @"/example=%%0%%";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFWebServiceClient_method_dynamicDownloadTest_p3 = attributesArray;
    
    return sf_attributes_list_SFWebServiceClient_method_dynamicDownloadTest_p3;
}

static NSMutableArray __weak *sf_attributes_list_SFWebServiceClient_method_downloadJSONWithSuccess_p2 = nil;

+ (NSArray *)sf_attributes_SFWebServiceClient_method_downloadJSONWithSuccess_p2 {
    if (sf_attributes_list_SFWebServiceClient_method_downloadJSONWithSuccess_p2 != nil) {
        return sf_attributes_list_SFWebServiceClient_method_downloadJSONWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:3];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.serializationDisabled= YES;
    attr1.relativePath = @"/?time=1";
    [attributesArray addObject:attr1];

    SFWebServiceLogger *attr2 = [[SFWebServiceLogger alloc] init];
    attr2.loggerType = @"SFLogMessageTypeConsoleOnly";
    [attributesArray addObject:attr2];

    SFWebServiceHeader *attr3 = [[SFWebServiceHeader alloc] init];
    attr3.hearderFields = @{@"authorization" : @"Basic ZXBhbTplcGFt"};
    [attributesArray addObject:attr3];

    sf_attributes_list_SFWebServiceClient_method_downloadJSONWithSuccess_p2 = attributesArray;
    
    return sf_attributes_list_SFWebServiceClient_method_downloadJSONWithSuccess_p2;
}

static NSMutableArray __weak *sf_attributes_list_SFWebServiceClient_method_loadSmallListWithSuccess_p2 = nil;

+ (NSArray *)sf_attributes_SFWebServiceClient_method_loadSmallListWithSuccess_p2 {
    if (sf_attributes_list_SFWebServiceClient_method_loadSmallListWithSuccess_p2 != nil) {
        return sf_attributes_list_SFWebServiceClient_method_loadSmallListWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.method = @"GET";
    attr1.relativePath = @"/?time=1";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFWebServiceClient_method_loadSmallListWithSuccess_p2 = attributesArray;
    
    return sf_attributes_list_SFWebServiceClient_method_loadSmallListWithSuccess_p2;
}

static NSMutableArray __weak *sf_attributes_list_SFWebServiceClient_method_loadBigListWithSuccess_p2 = nil;

+ (NSArray *)sf_attributes_SFWebServiceClient_method_loadBigListWithSuccess_p2 {
    if (sf_attributes_list_SFWebServiceClient_method_loadBigListWithSuccess_p2 != nil) {
        return sf_attributes_list_SFWebServiceClient_method_loadBigListWithSuccess_p2;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.method = @"GET";
    attr1.relativePath = @"/?time=10";
    [attributesArray addObject:attr1];

    sf_attributes_list_SFWebServiceClient_method_loadBigListWithSuccess_p2 = attributesArray;
    
    return sf_attributes_list_SFWebServiceClient_method_loadBigListWithSuccess_p2;
}

static NSMutableArray __weak *sf_attributes_list_SFWebServiceClient_method_loadListWithHeaderValueForTestKey1_p4 = nil;

+ (NSArray *)sf_attributes_SFWebServiceClient_method_loadListWithHeaderValueForTestKey1_p4 {
    if (sf_attributes_list_SFWebServiceClient_method_loadListWithHeaderValueForTestKey1_p4 != nil) {
        return sf_attributes_list_SFWebServiceClient_method_loadListWithHeaderValueForTestKey1_p4;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    SFWebServiceCall *attr1 = [[SFWebServiceCall alloc] init];
    attr1.method = @"GET";
    attr1.relativePath = @"/?time=1";
    [attributesArray addObject:attr1];

    SFWebServiceHeader *attr2 = [[SFWebServiceHeader alloc] init];
    attr2.hearderFields = @{@"testKey1" : @"%%0%%"};
    [attributesArray addObject:attr2];

    sf_attributes_list_SFWebServiceClient_method_loadListWithHeaderValueForTestKey1_p4 = attributesArray;
    
    return sf_attributes_list_SFWebServiceClient_method_loadListWithHeaderValueForTestKey1_p4;
}

static NSMutableDictionary __weak *attributesSFWebServiceClientFactoriesForMethodsDict = nil;
    
+ (NSDictionary *)attributesFactoriesForMethods {
    if (attributesSFWebServiceClientFactoriesForMethodsDict != nil) {
        return attributesSFWebServiceClientFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributesFactoriesForMethods]];
    
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFWebServiceClient_method_dynamicTestHttpRequestPath_p3)] forKey:@"dynamicTestHttpRequestPath:success:failure:"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFWebServiceClient_method_dynamicTestHttpsRequestPath_p3)] forKey:@"dynamicTestHttpsRequestPath:success:failure:"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFWebServiceClient_method_dynamicDownloadTest_p3)] forKey:@"dynamicDownloadTest:success:failure:"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFWebServiceClient_method_downloadJSONWithSuccess_p2)] forKey:@"downloadJSONWithSuccess:failure:"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFWebServiceClient_method_loadSmallListWithSuccess_p2)] forKey:@"loadSmallListWithSuccess:failure:"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFWebServiceClient_method_loadBigListWithSuccess_p2)] forKey:@"loadBigListWithSuccess:failure:"];
    [dictionaryHolder setObject:[self invocationForSelector:@selector(sf_attributes_SFWebServiceClient_method_loadListWithHeaderValueForTestKey1_p4)] forKey:@"loadListWithHeaderValueForTestKey1:prepareBlock:success:failure:"];
    attributesSFWebServiceClientFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesSFWebServiceClientFactoriesForMethodsDict;
}


#pragma mark - 

@end
