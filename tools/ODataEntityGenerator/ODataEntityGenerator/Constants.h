//
//  Constants.h
//  ODataEntityGenerator
//
//  Created by Yuru Taustahuzau on 8/20/13.
//  Copyright (c) 2013 EPAM Systems. All rights reserved.
//

#ifndef ODataEntityGenerator_Constants_h
#define ODataEntityGenerator_Constants_h

static NSString * const templatesFilename = @"templates.plist";
static NSString * const serviceTemplatesFilename = @"serviceTemplates.plist";
static NSString * const nullableTypesKeyName = @"nullableTypeMappings";
static NSString * const typeQualifiersKeyName = @"typeQualifiers";
static NSString * const defaultQualifierKeyName = @"defaultQualifier";
static NSString * const creationDateFormatStringKeyName = @"creationDateFormatString";
static NSString * const readonlyPropertiesKey = @"readonlyProperties";

static NSString * const headerfile_key = @"headerfile";
static NSString * const headerfile_property_key = @"headerfile_property";

static NSString * const codefile_key = @"codefile";
static NSString * const codefile_property_key = @"codefile_property";

static NSString * const propertytype_array_key = @"propertytype_array";
static NSString * const propertytype_readonly_array_key = @"propertytype_readonly_array";
static NSString * const forwarddeclaration_key = @"forward_declaration";
static NSString * const codefileImportKey = @"codefile_import";
static NSString * const codefilePropertyMemberKey = @"codefile_propertymember";
static NSString * const camelcasePropertiesKey = @"camelcaseProperties";

static NSString * const webClientName = @"webClientName";
static NSString * const webClientNameVariable = @"$webClientName$";
static NSString * const serviceDeclaration = @"serviceDeclaration";
static NSString * const serviceDeclarationVariable = @"$service_declaration$";

static NSString * const forwarddeclarationVariable = @"$forwarddeclarations$";
static NSString * const creationdateVariable = @"$creationdate$";
static NSString * const classnameVariable = @"$classname$";
static NSString * const entitySetNameVariable = @"$entity_set_name$";
static NSString * const baseclassVariable = @"$baseclass$";
static NSString * const propertiesVariable = @"$properties$";
static NSString * const importsVariable = @"$imports$";
static NSString * const propertyMembersVariable = @"$propertymembers$";

static NSString * const originalPropertyNameVariable = @"$originalpropertyname$";
static NSString * const propertyNameVariable = @"$propertyname$";
static NSString * const propertyTypeVariable = @"$propertytype$";
static NSString * const propertyQualifierVariable = @"$propertyqualifier$";

static NSString * const readonlyPropertyQualifier = @"readonly";

static NSString * const entityNameVariable = @"SF_ATTRIBUTE(SFODataEntity)";
static NSString * const collectionTypeAnnotationVariable = @"$collectionTypeAnnotation$";
static NSString * const collectionAnnotationKey = @"collectionAnnotation";

static NSString * const dateFormatKey = @"dateFormat";
static NSString * const dateFormatStringKey = @"dateFormatString";
static NSString * const dateFormatVariable = @"$dateFormat$";

#endif
