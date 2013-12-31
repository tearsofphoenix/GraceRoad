//
//  ERConversionConfiguration.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ERConversionCollectionAnyType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.any"
#define ERConversionCollectionElementType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.element"
#define ERConversionCollectionSetType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.set"
#define ERConversionCollectionArrayType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.array"
#define ERConversionCollectionDictionaryType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.dictionary"
#define ERConversionCollectionAnyNoZeroLengthStringType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.any.no-zero-length-string"
#define ERConversionCollectionElementNoZeroLengthStringType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.element.no-zero-length-string"
#define ERConversionCollectionSetNoZeroLengthStringType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.set.no-zero-length-string"
#define ERConversionCollectionArrayNoZeroLengthStringType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.array.no-zero-length-string"
#define ERConversionCollectionDictionaryNoZeroLengthStringType @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.collection.dictionary.no-zero-length-string"

#define ERConversionTargetReplaceMode @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.target-mode.replace"
#define ERConversionTargetMergeMode @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.target-mode.merge"
#define ERConversionTargetAppendMode @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.target-mode.append"
#define ERConversionTargetInsertMode @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.target-mode.insert"
#define ERConversionTargetIncludeMode @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.target-mode.include"

#define ERConversionSourceDirectionMode @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.source-mode.direction"
#define ERConversionSourceReflectionMode @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.source-mode.reflection"

@interface ERConversionConfiguration: NSObject
{
    
    NSString *_sourceCollectionPath;

    id _value;

    NSString *_sourceMode;
    
    NSString *_expectedSourceCollectionType;
    
    NSString *_targetCollectionPath;
    
    NSString *_targetMode;
    
}

@property(nonatomic, retain) NSString *sourceCollectionPath;
@property(nonatomic, retain) id value;
@property(nonatomic, retain) NSString *sourceMode;

@property(nonatomic, retain) NSString *expectedSourceCollectionType;

@property(nonatomic, retain) NSString *targetCollectionPath;

@property(nonatomic, retain) NSString *targetMode;

- (id)sourceValueDefinedFromSource: (id)source
                            target: (id)target;

- (id)convert: (id)source;

- (id)convert: (id)source
         into: (id)target;

+ (id)     fillValue: (id)value
    atCollectionPath: (NSString *)targetCollectionPath
           forTarget: (id)target
      withTargetMode: (NSString *)targetMode;

+ (id)ensureSource: (id)source
  isCollectionType: (NSString *)collectionType;

@end
