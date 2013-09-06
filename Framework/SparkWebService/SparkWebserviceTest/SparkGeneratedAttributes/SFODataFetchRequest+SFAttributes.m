#import "SFODataPrioritizedPredicate.h"
#import "SFODataExpression.h"
#import "NSSortDescriptor+SFOData.h"
#import "SFWebServiceURLBuilderParameter.h"
#import "SFODataFetchRequest.h"
 
@interface SFODataFetchRequest(SFAttribute)
 
@end
 
@implementation SFODataFetchRequest(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *SF_attributes_list__class_SFODataFetchRequest = nil;

+ (NSArray *)SF_attributesForClass {
    if (SF_attributes_list__class_SFODataFetchRequest != nil) {
        return SF_attributes_list__class_SFODataFetchRequest;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceURLBuilderParameter *attr1 = [[SFWebServiceURLBuilderParameter alloc] init];
    [attributesArray addObject:attr1];

    SF_attributes_list__class_SFODataFetchRequest = attributesArray;
    
    return SF_attributes_list__class_SFODataFetchRequest;
}

#pragma mark - 

@end
