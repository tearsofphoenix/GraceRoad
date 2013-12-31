//
//  ERConversionSet.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERConversionSet.h"

#import "NSDictionary+CollectionPath.h"
#import "NSMutableDictionary+CollectionPath.h"

@implementation ERConversionSet

@synthesize configurations = _configurations;
@synthesize targetCollectionType = _targetCollectionType;

- (void)dealloc
{

    [_configurations release];

    [_targetCollectionType release];
    
    [super dealloc];

}

- (id)convert: (id)source into: (id)target
{
    
    id sourceValue = [self sourceValueDefinedFromSource: source target: target];
    
    id value = nil;
    if (_targetCollectionPath)
    {
        
        if ((!_targetCollectionType) || [_targetCollectionType isEqualToString: ERConversionCollectionDictionaryType])
        {
            value = [NSMutableDictionary dictionary];
        }
        else
        {
            value = [NSMutableArray array];
        }
        
    }
    else
    {
        
        if (target)
        {
            value = target;
        }
        else
        {
            
            if ((!_targetCollectionType) || [_targetCollectionType isEqualToString: ERConversionCollectionDictionaryType])
            {
                value = [NSMutableDictionary dictionary];
            }
            else
            {
                value = [NSMutableArray array];
            }
            
        }
        
    }
    
    for (ERConversionConfiguration *configuration in _configurations)
    {
        [configuration convert: sourceValue into: value];
    }
    
    return [ERConversionConfiguration fillValue: value
                               atCollectionPath: _targetCollectionPath
                                      forTarget: target
                                 withTargetMode: _targetMode];
    
}

@end
