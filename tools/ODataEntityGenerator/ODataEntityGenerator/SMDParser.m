//
//  EntityGenerator.m
//  ODataEntityGenerator
//
//  Created by Andras Palfi on 2012.03.05..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import "SMDParser.h"

#import "EntityDescriptor.h"
#import "PropertyDescriptor.h"
#import "NSXMLElement+Additions.h"

// xml element types
static NSString * const RootElementName = @"Edmx";
static NSString * const DataServicesElementName = @"DataServices";
static NSString * const SchemaElementName = @"Schema";
static NSString * const EntityTypeElementName = @"EntityType";
static NSString * const ComplexTypeElementName = @"ComplexType";
static NSString * const KeyElementName = @"Key";
static NSString * const PropertyElementName = @"Property";
static NSString * const PropertyRefElementName = @"PropertyRef";
static NSString * const NavigationPropertyElementName = @"NavigationProperty";
static NSString * const AssociationElementName = @"Association";
static NSString * const AssociationSetElementName = @"AssociationSet";
static NSString * const EndElementName = @"End";
static NSString * const EntityContainerElementName = @"EntityContainer";
static NSString * const EntitySetElementName = @"EntitySet";
static NSString * const FunctionImportElementName = @"FunctionImport";
static NSString * const UsingElementName = @"Using";
static NSString * const FunctionElementName = @"Function";
static NSString * const DocumentationElementName = @"Documentation";
static NSString * const AnnotationElementName = @"AnnotationElement";

static NSString * const NamespaceAttributeName = @"Namespace";


@implementation SMDParser
{
    NSXMLDocument *xmlDocument;
    NSMutableDictionary *xmlNamespaces;
    NSMutableDictionary *entityDescriptors;
    NSString *defaultNamespace;
    NSDictionary *schemaElementParserMethods;
    NSDictionary *entityTypeElementParserMethods;
    NSDictionary *complexTypeElementParserMethods;
    NSSet *baseTypes;
}

+ (NSDictionary *)entityDescriptorsFromSMD:(NSXMLDocument *)anXmlDom {
    SMDParser *parser = [[SMDParser alloc] initWithXmlDoc:anXmlDom];
    
    return [parser parseDocument];
}

- (id)initWithXmlDoc:(NSXMLDocument *)anXmlDom {
    self = [super init];
    if (self) {
        xmlDocument = anXmlDom;
        
        entityDescriptors = [[NSMutableDictionary alloc] init];
        
        schemaElementParserMethods = [NSDictionary dictionaryWithObjectsAndKeys:
                                      NSStringFromSelector(@selector(parseEntityType:)), EntityTypeElementName,
                                      NSStringFromSelector(@selector(parseEntityContainer:)), EntityContainerElementName,
                                      NSStringFromSelector(@selector(parseEntitySet:)), EntitySetElementName,
                                      NSStringFromSelector(@selector(parseComplexType:)), ComplexTypeElementName,                              
                                      NSStringFromSelector(@selector(parseAssociation:)), AssociationElementName,
                                      NSStringFromSelector(@selector(parseUsing:)), UsingElementName,
                                      NSStringFromSelector(@selector(parseFunction:)), FunctionElementName,                              
                                      nil];
        
        entityTypeElementParserMethods = [NSDictionary dictionaryWithObjectsAndKeys:
                                          NSStringFromSelector(@selector(parseKeyNode:forEntityDescriptor:)), KeyElementName,
                                          NSStringFromSelector(@selector(parsePropertyNode:forEntityDescriptor:)), PropertyElementName,
                                          NSStringFromSelector(@selector(parseNavigationPropertyNode:forEntityDescriptor:)), NavigationPropertyElementName,                                          
                                          nil];
        
        complexTypeElementParserMethods = [NSDictionary dictionaryWithObjectsAndKeys:
                                          NSStringFromSelector(@selector(parsePropertyNode:forEntityDescriptor:)), PropertyElementName,
                                          NSStringFromSelector(@selector(parseDocumentationNode:forEntityDescriptor:)), DocumentationElementName,
                                          NSStringFromSelector(@selector(parseAnnotationNode:forEntityDescriptor:)), AnnotationElementName,
                                          nil];
        
        baseTypes = [NSSet setWithObjects:
                     @"boolean",
                     @"int32",
                     @"int16",
                     @"int64", 
                     @"byte",
                     @"double",
                     @"single",
                     @"guid",
                     @"sbyte",
                     @"string",
                     @"time",
                     @"datetimeoffset",
                     @"datetime",
                     @"decimal",
                     @"binary",
                     nil];

    }
    
    return self;
}

// entry point to parse the DOM
- (NSDictionary *)parseDocument {
    NSXMLElement *rootElement = xmlDocument.rootElement;

    NSAssert([RootElementName isEqualToString:rootElement.localName], @"Wrong root element");
    
    NSXMLElement *dataServicesElement = nil;
    if (rootElement.childCount==1)              
    {
        dataServicesElement = [rootElement.children objectAtIndex:0];
    }
    NSAssert([DataServicesElementName isEqualToString:dataServicesElement.localName], @"Wrong or missing DataServices element");

    for (NSXMLElement *schemaElement in dataServicesElement.children)
    {
        NSAssert([SchemaElementName isEqualToString:schemaElement.localName], @"Invalid element, only Schema allowed on this level");

        [self parseSchemaElement:schemaElement];
    }
    
    return entityDescriptors;
}

/**
 parses the Schema element: this contains the type descriptions
 */
- (void)parseSchemaElement:(NSXMLElement *)schemaElement {

    [self parseNamespaces:schemaElement];
    
    // check the mandatory namespace attribute
    defaultNamespace = [[schemaElement attributeForName:NamespaceAttributeName] stringValue];
    NSAssert(defaultNamespace!=nil,@"No Namespace attribute declared on Schema element");
    
    for (NSXMLElement *subElement in schemaElement.children) {
        
        NSString *methodNameToCall = [schemaElementParserMethods objectForKey:subElement.localName];

        if (methodNameToCall != nil) {
            SEL parseSelector = NSSelectorFromString(methodNameToCall);
            [self performSelector:parseSelector withObject:subElement];
        }
        else {
            //[self parseChildren:xmlNode];
            NSAssert(FALSE, @"Invalid schema schema sub element");
        }
    }
}

/**
 Collects the namespace information
 */
- (void)parseNamespaces:(NSXMLElement *)xmlElement {
    for (NSXMLNode *namespaceItem in xmlElement.namespaces) {
        [xmlNamespaces setObject:namespaceItem.stringValue forKey:namespaceItem.name];
    }
}

- (void)parseEntityType:(NSXMLElement *)anEntityNode {
    EntityDescriptor *newEntity = [[EntityDescriptor alloc] init];

    // get the name of the new class
    newEntity.name = [self typeNameFromAttribute:[anEntityNode attributeForName:@"Name"]];
    NSAssert(newEntity.name != nil, @"Missing name attribute for an EntityType");

    // get the base class, if any
    newEntity.baseName = [self typeNameFromAttribute:[anEntityNode attributeForName:@"BaseType"]];
        
    newEntity.isAbstract = [anEntityNode boolValueFromAttribute:@"Abstract"];
    
    // parse child nodes
    [self parseChildNodesOfElement:anEntityNode forEntityDescriptor:newEntity usingParserMethods:entityTypeElementParserMethods];
    
    // save the entity to the entity container
    [entityDescriptors setObject:newEntity forKey:newEntity.name];
}

- (void)parseComplexType:(NSXMLElement *)aComplexType {
    EntityDescriptor *newEntity = [[EntityDescriptor alloc] init];
    
    newEntity.name = [self typeNameFromAttribute:[aComplexType attributeForName:@"Name"]];
    NSAssert(newEntity.name != nil, @"Missing name attribute for an EntityType");
    
    // get the base class, if any
    newEntity.baseName = [self typeNameFromAttribute:[aComplexType attributeForName:@"BaseType"]];
    
    newEntity.isAbstract = [aComplexType boolValueFromAttribute:@"Abstract"];
    
    // parse child nodes
    [self parseChildNodesOfElement:aComplexType forEntityDescriptor:newEntity usingParserMethods:complexTypeElementParserMethods];
    
    // save the entity to the entity container
    [entityDescriptors setObject:newEntity forKey:newEntity.name];
}

- (void)addAssociation:(NSString *)association usingEndElement:(NSXMLElement *)endElement asTargetEndElement:(NSXMLElement *)targetEndElement {
    NSArray *endElements = @[endElement, targetEndElement];
    for (NSXMLElement *element in endElements) {
        NSXMLElement *anotherElement = [endElements lastObject];
        if (anotherElement == element) {
            anotherElement = [endElements objectAtIndex:0];
        }
        
        EntityDescriptor *entityDescriptor = [entityDescriptors objectForKey:[self typeNameFromAttribute:[element attributeForName:@"Type"]]];
        NSAssert(entityDescriptor!=nil, @"Invalid Type attribute of <end> element in Association");
        
        // add the attributes
        PropertyDescriptor *navigationProperty;
        
        for (PropertyDescriptor *property in entityDescriptor.properties) {
            if ([property.association isEqualToString:association]) {
                navigationProperty = property;
                break;
            }
        }
        
        navigationProperty.isAssociationProperty = YES;
        navigationProperty.typeName = [self typeNameFromAttribute:[anotherElement attributeForName:@"Type"]];
        
        // get the multiplicity for the other element cause this should be set on this element
        NSString *multiplicity = [[anotherElement attributeForName:@"Multiplicity"] stringValue];
        if ([multiplicity isEqualToString:@"0..1"]) {
            navigationProperty.nullable = YES;
            navigationProperty.maxLength = 1;
        }
        else if ([multiplicity isEqualToString:@"1"]) {
            navigationProperty.nullable = NO;
            navigationProperty.maxLength = 1;
        }
        else if ([multiplicity isEqualToString:@"*"]) {
            navigationProperty.nullable = YES;
            navigationProperty.maxLength = INT_MAX;
            navigationProperty.isCollection = YES;
        }
        else {
            NSAssert(FALSE, @"Invalid Multiplicity on <End> element");
        }
    }
}

- (void)parseAssociation:(NSXMLElement *)anAssociation {

    NSXMLElement *firstEndElement = nil;
    NSXMLElement *secondEndElement = nil;

    // get the two end points
    int currentEndElement = 0;
    for (NSXMLElement *childNode in [anAssociation children]) {
        if ([childNode.localName isEqualToString:@"End"]) {
            if (currentEndElement==0) {
                firstEndElement = childNode;
                currentEndElement++;
            } 
            else {
                secondEndElement = childNode;
                break;
            }
       }
    }
    
    NSAssert(firstEndElement!=nil && secondEndElement!=nil, @"Missing <End> element");

    NSString *associationName = [[anAssociation attributeForName:@"Name"] stringValue];
    
    // get the entity descriptors
    [self addAssociation:associationName usingEndElement:firstEndElement asTargetEndElement:secondEndElement];
    [self addAssociation:associationName usingEndElement:secondEndElement asTargetEndElement:firstEndElement];
}

- (void)parseEntityContainer:(NSXMLElement *)anEntityContainer {
    // data sets - cannot really map to objc context

    for (NSXMLElement *subElement in anEntityContainer.children) {
        
        NSString *methodNameToCall = [schemaElementParserMethods objectForKey:subElement.localName];
        
        if (methodNameToCall != nil) {
            SEL parseSelector = NSSelectorFromString(methodNameToCall);
            [self performSelector:parseSelector withObject:subElement];
        }
    }
}

- (void)parseUsing:(NSXMLElement *)aUsingElement {
    // not supported yet
}

- (void)parseFunction:(NSXMLElement *)aFunction {
    // not supported yet
}

- (void)parseEntitySet:(NSXMLElement *)entitySet {
    NSString *entitySetName = [[entitySet attributeForName:@"Name"] stringValue];
    EntityDescriptor *entityDescriptor = [entityDescriptors objectForKey:[self typeNameFromAttribute:[entitySet attributeForName:@"EntityType"]]];
    entityDescriptor.entitySetName = entitySetName;
}

- (void)parseKeyNode:(NSXMLElement *)keyElement forEntityDescriptor:(EntityDescriptor *)anEntityDescriptor {
}

- (void)parseNavigationPropertyNode:(NSXMLElement *)propertyElement forEntityDescriptor:(EntityDescriptor *)anEntityDescriptor {
    PropertyDescriptor *newProperty = [[PropertyDescriptor alloc] init];
    
    newProperty.name = [[propertyElement attributeForName:@"Name"] stringValue];
    NSAssert(newProperty.name != nil, @"Missing name attribute for a Property");
    
    newProperty.association = [self valueWithoutNamespace:[[propertyElement attributeForName:@"Relationship"] stringValue]];

    [anEntityDescriptor addProperty:newProperty];
}

- (void) parseChildNodesOfElement:(NSXMLElement *)element forEntityDescriptor:(EntityDescriptor *)entityDescriptor usingParserMethods:(NSDictionary *)parserMethods {

    for (NSXMLElement *childElement in element.children) {
    
        NSString *methodNameToCall = [entityTypeElementParserMethods objectForKey:childElement.localName];
    
        if (methodNameToCall != nil) {
            SEL parseSelector = NSSelectorFromString(methodNameToCall);
            [self performSelector:parseSelector withObject:childElement withObject:entityDescriptor];
        }
        else {
            NSAssert(FALSE, @"Invalid schema child sub element");
        }
    }
}

- (void)parsePropertyNode:(NSXMLElement *)propertyElement forEntityDescriptor:(EntityDescriptor *)anEntityDescriptor {
    PropertyDescriptor *newProperty = [[PropertyDescriptor alloc] init];
    
    newProperty.name = [[propertyElement attributeForName:@"Name"] stringValue];
    NSAssert(newProperty.name != nil, @"Missing name attribute for a Property");
    
    NSString *typeName = [self typeNameFromAttribute:[propertyElement attributeForName:@"Type"]];
    
    if ([typeName compare:@"Collection(" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 11)] == NSOrderedSame)
    {
        NSString *collectionType = [typeName substringWithRange:NSMakeRange(11, typeName.length - 12)];
        newProperty.typeName = collectionType;
        newProperty.isCollection = YES;
        newProperty.maxLength = INT_MAX;
        newProperty.nullable = [propertyElement boolValueFromAttribute:@"Nullable" defaultValue:YES];
    }
    else
    {
        newProperty.typeName = typeName;
        newProperty.nullable = [propertyElement boolValueFromAttribute:@"Nullable" defaultValue:YES];
        newProperty.maxLength = [propertyElement intValueFromAttribute:@"MaxLength"];
        newProperty.fixedLength = [propertyElement intValueFromAttribute:@"FixedLength"];
    }
    
    NSAssert(newProperty.typeName != nil, @"Missing type attribute for a Property");
    
    newProperty.precision = [propertyElement intValueFromAttribute:@"Precision"];
    newProperty.isUnicode = [propertyElement boolValueFromAttribute:@"Unicode"];
    
    [anEntityDescriptor addProperty:newProperty];
}

- (void)parseDocumentationNode:(NSXMLElement *)documentElement forEntityDescriptor:(EntityDescriptor *)anEntityDescriptor {
}

- (void)parseAnnotationNode:(NSXMLElement *)documentElement forEntityDescriptor:(EntityDescriptor *)anEntityDescriptor {
}

- (NSString *)typeNameFromAttribute:(NSXMLNode *)attributeNode {
    if (attributeNode==nil) {
        return nil;
    }
    
    //NSString *namespace = (NSString *)[xmlNamespaces objectForKey:attributeNode.prefix];
    NSString *attributeValue = [attributeNode stringValue];

    BOOL collection = NO;
    if ([attributeValue compare:@"Collection(" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 11)] == NSOrderedSame)
    {
        attributeValue = [attributeValue substringWithRange:NSMakeRange(11, attributeValue.length - 12)];
        collection = YES;
    }
    
    NSArray *nameComponents = [attributeValue componentsSeparatedByString:@"."];
    
    // get the name
    NSString *name = [nameComponents lastObject];

    NSMutableString *nameToReturn = [NSMutableString string];
    
    // use prefixes for the non-basic types
    if (![baseTypes containsObject:[name lowercaseString]])
    {
        // get all the prefixes without the name
        NSMutableArray *prefixes = [NSMutableArray arrayWithArray:nameComponents];
        [prefixes removeLastObject];
        
        [nameToReturn appendFormat:@"%@_",defaultNamespace];
        if (prefixes != nil) {
            for (NSString *prefix in prefixes) {
                // do not use the optional "Edm" prefix and the default namespace prefix. Add any other prefixes to the name
                if (!(([prefix compare:@"edm" options:NSCaseInsensitiveSearch]==NSOrderedSame) ||
                      ([prefix compare:defaultNamespace options:NSCaseInsensitiveSearch]==NSOrderedSame))) {
                    [nameToReturn appendFormat:@"%@_", prefix];                
                }
            }
        }
    }
    [nameToReturn appendString:name];
    
    if (collection)
        return [NSString stringWithFormat:@"Collection(%@)", nameToReturn];
    return [NSString stringWithString:nameToReturn];
}

- (NSString *)valueWithoutNamespace:(NSString *)value {
    NSString *valueWithoutNamcespace = value;
    NSRange rangeOfNameSpace = [value rangeOfString:defaultNamespace];
    if (rangeOfNameSpace.location != NSNotFound) {
        rangeOfNameSpace.length++;
        valueWithoutNamcespace = [value stringByReplacingCharactersInRange:rangeOfNameSpace withString:@""];
    }
    
    return valueWithoutNamcespace;
}

@end
