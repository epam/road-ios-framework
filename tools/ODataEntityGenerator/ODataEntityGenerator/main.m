//
//  main.m
//  ODataEntityGenerator
//
//  Created by  on 2012.03.05..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SMDParser.h"
#import "EntityGenerator.h"
#import "ServiceGenerator.h"

static NSString* paramURL = @"-url";
static NSString* paramFile = @"-file";
static NSString* paramOutput = @"-out";

// Use apostrophes (') to type the url for parsing the entities.
// You also need to include the templates.plist file next to the executable when parsing.


void PresentUsageInformation() {
    printf("\n");
    printf("Parameters:\n");
    printf("\t--url <input url> the url where the SMD can be found.\n");
    printf("\t--file <input file> the path of the file which contains the SMD\n");
    printf("\t--out <path> the local file path where the generated classes will be written\n");
    printf("At least the --file or --url and the --out must be specified\n");
}

int main(int argc, const char * argv[]) {

    @autoreleasepool {

        NSUserDefaults *appParams = [NSUserDefaults standardUserDefaults];
        
        NSString *inputURLString = [appParams stringForKey:paramURL];
        NSURL *inputURL = (inputURLString != nil ? [NSURL URLWithString:inputURLString] : nil);
        if (inputURL == nil)
        {
            inputURLString = [appParams stringForKey:paramFile];
            inputURL = (inputURLString != nil ? [[NSURL alloc] initFileURLWithPath:inputURLString] : nil);
        }

        if (inputURL == nil)
            inputURL = [NSURL URLWithString:@"http://services.odata.org/OData/OData.svc/$metadata"];
        
        NSString *outputPath = [appParams stringForKey:paramOutput];
        
        if (inputURL!=nil && outputPath!=nil)
        {
            // validate the output directory
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath isDirectory:&isDir] && (!isDir)) {
                printf("Problems with the output dir");
                return 1;
            }
            
            // validate the input xml
            NSError *error = nil;
            NSXMLDocument *xmlDom = [[NSXMLDocument alloc] initWithContentsOfURL:inputURL options:NSXMLDocumentValidate error:&error];
            if (xmlDom == nil) {
                printf("Problems with the input: %s", [[error description] cStringUsingEncoding:NSUTF8StringEncoding]);
                return 1;
            }
            
            NSDictionary *entityDescriptors = [SMDParser entityDescriptorsFromSMD:xmlDom];
            
            [EntityGenerator writeEntities:entityDescriptors toFolder:outputPath];
            
            [ServiceGenerator writeEntities:entityDescriptors toFolder:outputPath];
            
            printf("\ndone");
        }
        else {
            PresentUsageInformation();
        }
    }
    
    return 0;
}
