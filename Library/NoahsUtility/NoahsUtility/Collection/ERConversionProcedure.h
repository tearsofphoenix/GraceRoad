//
//  ERConversionBasicConfiguration.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <NoahsUtility/ERConversionConfiguration.h>

typedef id (^ERConversionConfigurationProcessor)(id source, id parameters);

#define ERConversionProcedureMappingFirstMatchingInCollectionMethod @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.mapping.first-matching-in-collection"
#define ERConversionProcedureMappingAllElementMatchingInCollectionMethod @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.mapping.all-matching-in-collection"

#define ERConversionProcedureParseUUIDStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.parse-uuid-string"
#define ERConversionProcedureParseDateStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.parse-date-string"
#define ERConversionProcedureParseURLStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.parse-url-string"
#define ERConversionProcedureApplyConversionProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.apply-conversion"
#define ERConversionProcedureGenerateJSONStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-json-string"
#define ERConversionProcedureGenerateStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-string"
#define ERConversionProcedureLowercaseStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.lowercase"
#define ERConversionProcedureUppercaseStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.uppercase"
#define ERConversionProcedureEncloseAsArrayProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.enclose-as-array"
#define ERConversionProcedureEncloseAsSetProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.enclose-as-set"
#define ERConversionProcedureEncloseAsDictionaryProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.enclose-as-dictionary"

#define ERConversionProcedureCreateArrayProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.create-array"
#define ERConversionProcedureCreateSetProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.create-set"
#define ERConversionProcedureCreateDictionaryProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.create-dictionary"

#define ERConversionProcedureExtractFamilyNameProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.extract-family-name"
#define ERConversionProcedureExtractGivenNameProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.extract-given-name"
#define ERConversionProcedureReformatNameProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.reformat-name"
#define ERConversionProcedureGenerateLatinTransliterationProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-latin-transliteration"
#define ERConversionProcedureExtractSubstringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.extract-substring"

#define ERConversionProcedureFormatDateStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.format-date-string"
#define ERConversionProcedureGenerateDateStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-date-string"
#define ERConversionProcedureGenerateHumanReadableDateDescriptionProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-human-readable-date-description"
#define ERConversionProcedureFormatDateStringWithTemplateProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.format-date-string-with-template"

#define ERConversionProcedureFormatToStringProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.format-to-string"
#define ERConversionProcedureRedirectProcessorIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.redirect"

#define ERConversionProcedureReplaceSubstringProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.replace-substring"

#define ERConversionProcedureIsEqualProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.is-equal"
#define ERConversionProcedureIsNotEqualProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.is-not-equal"
#define ERConversionProcedureIsNotZeroOrNilProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.is-not-zero-or-nil"
#define ERConversionProcedureIsNotZeroOrNilOrNAStringProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.is-not-zero-or-nil-or-na-string"
#define ERConversionProcedureIsZeroOrNilProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.is-zero-or-nil"
#define ERConversionProcedureIsZeroOrNilOrNAStringProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.is-zero-or-nil-or-na-string"

#define ERConversionProcedureNotProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.not"

#define ERConversionProcedureProcessProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.process"

#define ERConversionProcedureGenerateHTTPGetParameterProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-http-get-parameter"
#define ERConversionProcedureGenerateHTTPGetParameterDataProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.generate-http-get-parameter-data"
#define ERConversionProcedureConvertToDataProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.convert-to-data"

#define ERConversionProcedureJoinArrayToStringProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.join-array-to-string"
#define ERConversionProcedureSplitStringToArrayProcedureIdentifier @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.processor.split-string-to-array"

@interface ERConversionProcedure : ERConversionConfiguration
{
    
    NSString *_preprocessorIdentifier;
    id _preprocessorParameter;
    
    NSString *_postprocessorIdentifier;
    id _postprocessorParameter;
    
    NSDictionary *_map;
    NSString *_mappingMethod;
    id _noMatchingResult;
    
}

+ (void)registerConversionConfigurationProcessor: (ERConversionConfigurationProcessor)processor
                                  withIdentifier: (NSString *)identifier;

+ (ERConversionConfigurationProcessor)processorWithIdentifier: (NSString *)identifier;

@property(nonatomic, retain) NSString *preprocessorIdentifier;
@property(nonatomic, retain) id preprocessorParameter;

@property(nonatomic, retain) NSString *postprocessorIdentifier;
@property(nonatomic, retain) id postprocessorParameter;

@property(nonatomic, retain) NSDictionary *map;
@property(nonatomic, retain) NSString *mappingMethod;
@property(nonatomic, retain) id noMatchingResult;

@end
