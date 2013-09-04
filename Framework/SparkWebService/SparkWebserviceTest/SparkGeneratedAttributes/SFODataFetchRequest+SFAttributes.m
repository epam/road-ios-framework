#import "SFODataFetchRequest.h"
 
@interface SFODataFetchRequest(SFAttribute)
 
@end
 
@implementation SFODataFetchRequest(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *sf_attributes_list__class_SFODataFetchRequest = nil;

+ (NSArray *)attributesForClass {
    if (sf_attributes_list__class_SFODataFetchRequest != nil) {
        return sf_attributes_list__class_SFODataFetchRequest;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFWebServiceURLBuilderParameter *attr1 = [[SFWebServiceURLBuilderParameter alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list__class_SFODataFetchRequest = attributesArray;
    
    return sf_attributes_list__class_SFODataFetchRequest;
}

#pragma mark - 

@end
