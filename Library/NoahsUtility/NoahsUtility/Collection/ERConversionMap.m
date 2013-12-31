//
//  ERConversionMap.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERConversionMap.h"

#import "NSDictionary+CollectionPath.h"
#import "NSMutableDictionary+CollectionPath.h"

#import "NSDictionary+NSNull.h"
#import "NSMutableDictionary+NSNull.h"

#import "ERConditionalConversionSet.h"

@implementation ERConversionMap

@synthesize targetElementType = _targetElementType;
@synthesize expectedSourceElementCollectionType = _expectedSourceElementCollectionType;

@synthesize filteringCalculatorIdentifier = _filteringCalculatorIdentifier;
@synthesize filteringCalculatorParameter = _filteringCalculatorParameter;
@synthesize filteringCollectionPath = _filteringCollectionPath;

- (void)dealloc
{

    [_targetElementType release];
    [_expectedSourceElementCollectionType release];

    [_filteringCollectionPath release];
    [_filteringCalculatorIdentifier release];
    
    [_filteringCalculatorParameter release];

    [super dealloc];

}

- (id)convert: (id)source into: (id)target
{

    id sourceValue = [self sourceValueDefinedFromSource: source target: target];

    id value = nil;
    if ([_targetCollectionType isEqualToString: ERConversionCollectionDictionaryType])
    {
        value = [NSMutableDictionary dictionary];
    }
    else
    {
        value = [NSMutableArray array];
    }
    
    for (id key in sourceValue)
    {
        
        id sourceElement = key;
        if ([sourceValue isKindOfClass: [NSDictionary class]])
        {
            sourceElement = [sourceValue objectOrNilForKey: key];
        }
        
        sourceElement = [ERConversionConfiguration ensureSource: sourceElement
                                               isCollectionType: _expectedSourceElementCollectionType];
        
        id condition = [sourceElement objectOrNilAtCollectionPath: _filteringCollectionPath];
        
        ERConditionalConversionCalculator processor = [ERConditionalConversionSet conditionCalculatorWithIdentifier: _filteringCalculatorIdentifier];
        
        if ((!_filteringCollectionPath) || (processor && processor(condition, _filteringCalculatorParameter)))
        {
            
            id targetElement = nil;
            if ((!_targetElementType) || [_targetElementType isEqualToString: ERConversionCollectionDictionaryType])
            {
                targetElement = [NSMutableDictionary dictionary];
            }
            else
            {
                targetElement = [NSArray array];
            }
            
            for (ERConversionConfiguration *configuration in _configurations)
            {
                [configuration convert: sourceElement into: targetElement];
            }
            
            if ([_targetElementType isEqualToString: ERConversionCollectionSetType])
            {
                targetElement = [NSMutableSet setWithArray: targetElement];
            }
            
            if ([_targetCollectionType isEqualToString: ERConversionCollectionDictionaryType])
            {
                [value setObjectOrNil: targetElement
                               forKey: sourceElement];
            }
            else
            {
                [value addObject: targetElement];
            }
        
        }
        
    }
    
    if ([_targetCollectionType isEqualToString: ERConversionCollectionSetType])
    {
        value = [NSMutableSet setWithArray: value];
    }
    
    return [ERConversionConfiguration fillValue: value
                               atCollectionPath: _targetCollectionPath
                                      forTarget: target
                                 withTargetMode: _targetMode];
    
}

@end
