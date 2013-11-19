#import "SFODataPrioritizedPredicate.h"
#import "SFODataExpression.h"
#import "NSSortDescriptor+SFOData.h"
#import "SFWebServiceURLBuilderParameter.h"
#import "SFODataFetchRequest.h"
#import <Spark/SparkCore.h>
 
@interface SFODataFetchRequest(SFAttribute)
 
@end
 
@implementation SFODataFetchRequest(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Class section)

+ (NSArray *)SF_attributesForClass {
    NSMutableArray *SF_attributes_list__class_SFODataFetchRequest = [[SFAttributeCacheManager attributeCache] objectForKey:@"SFAL__class_SFODataFetchRequest"];
    if (SF_attributes_list__class_SFODataFetchRequest != nil) {
        return SF_attributes_list__class_SFODataFetchRequest;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceURLBuilderParameter *attr1 = [[SFWebServiceURLBuilderParameter alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list__class_SFODataFetchRequest = attributesArray;
    [[SFAttributeCacheManager attributeCache] setObject:attributesArray forKey:@"SFAL__class_SFODataFetchRequest"];
    
    return SF_attributes_list__class_SFODataFetchRequest;
}

#pragma mark - 

@end
