//
//  EntityGenerator.h
//  ODataEntityGenerator
//
//  Created by Andras Palfi on 2012.03.05..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Creates EntityDescriptors by parsing the given Service Metadata Document of an OData service. It has to be a CSDL document which is packed using the EDMX format.
 */
@interface SMDParser : NSObject

/**
 Creates a dictionary which contains the parsed EntityDescriptors using the name of the classes as the key.
 @param anXmlDom the XML DOM which contains the service metadata
 @return dictionary with the parsed EntityDescriptors
 */
+ (NSDictionary *)entityDescriptorsFromSMD:(NSXMLDocument *)anXmlDom;

@end
