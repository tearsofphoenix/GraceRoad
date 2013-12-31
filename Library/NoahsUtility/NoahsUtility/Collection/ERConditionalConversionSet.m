//
//  ERConditionalConversionSet.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/9/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

//#import "ERConditionalConversionSet.h"
#import <NoahsUtility/NoahsUtility.h>
#import <UIKit/UIKit.h>

static NSMutableDictionary* ERConditionCalculators;

@implementation ERConditionalConversionSet

@synthesize conditionCollectionPath = _conditionCollectionPath;
@synthesize conditionCalculatorIdentifier = _conditionCalculatorIdentifier;
@synthesize conditionCalculatorParameter = _conditionCalculatorParameter;

+ (void)load
{
    
    @autoreleasepool
    {
        
        ERConditionCalculators = [[NSMutableDictionary alloc] init];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return [source isEqual: parameters];
          })
                                                 withIdentifier: ERConditionalConversionIsEqualCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return ![source isEqual: parameters];
          })
                                                 withIdentifier: ERConditionalConversionIsNotEqualCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return [source containsObject: parameters];
          })
                                                 withIdentifier: ERConditionalConversionContainsCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return [parameters containsObject: source];
          })
                                                 withIdentifier: ERConditionalConversionIsContainedInCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return source == nil;
          })
                                                 withIdentifier: ERConditionalConversionIsNullCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return source != nil;
          })
                                                 withIdentifier: ERConditionalConversionIsNotNullCalculator];

        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return ((source == nil) || (![source boolValue]));
          })
                                                 withIdentifier: ERConditionalConversionIsNullOrZeroCalculator];

        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return ((source != nil) && ((![source isKindOfClass: [NSNumber class]]) || ([source boolValue])));
          })
                                                 withIdentifier: ERConditionalConversionIsNotNullOrZeroCalculator];

        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return ((source == nil) || ([source length] == 0));
          })
                                                 withIdentifier: ERConditionalConversionIsNullOrZeroLengthStringCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              return ((source != nil) && ([source length] > 0));
          })
                                                 withIdentifier: ERConditionalConversionIsNotNullOrZeroLengthStringCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {
              UIImage *image = [UIImage imageWithContentsOfFile: source];
              return image != nil;
          })
                                                 withIdentifier: ERConditionalConversionImageIsNotNullCalculator];

        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {

              if ([parameters isKindOfClass: [NSArray class]])
              {

                  NSDate *dateA = [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: 0]];
                  NSDate *dateB = [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: 1]];

                  return [dateA isTheSameDayAs: dateB];

              }
              else if ([parameters isKindOfClass: [NSDate class]])
              {
                  return [source isTheSameDayAs: parameters];
              }
              else
              {
                  return NO;
              }
              
          })
                                                 withIdentifier: ERConditionalConversionIsTheSameDayCalculator];
        
        [ERConditionalConversionSet registerConditionCalculator:
         (^BOOL(id source, id parameters)
          {

              if ([parameters isKindOfClass: [NSArray class]])
              {

                  NSDate *dateA = [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: 0]];
                  NSDate *dateB = [source objectOrNilAtCollectionPath: [parameters objectOrNilAtIndex: 1]];

                  return ![dateA isTheSameDayAs: dateB];

              }
              else if ([parameters isKindOfClass: [NSDate class]])
              {
                  return ![source isTheSameDayAs: parameters];
              }
              else
              {
                  return YES;
              }

          })
                                                 withIdentifier: ERConditionalConversionIsNotTheSameDayCalculator];
        
    }
    
}

+ (void)registerConditionCalculator: (ERConditionalConversionCalculator)calculator
                     withIdentifier: (NSString *)identifier
{
    [ERConditionCalculators setObjectOrNil: [Block_copy(calculator) autorelease]
                                    forKey: identifier];
}

+ (ERConditionalConversionCalculator)conditionCalculatorWithIdentifier: (NSString *)identifier
{
    return  [ERConditionCalculators objectOrNilForKey: identifier];
}

- (void)dealloc
{

    [_conditionCollectionPath release];

    [_conditionCalculatorIdentifier release];

    [_conditionCalculatorParameter release];

    [super dealloc];
}

- (id)convert: (id)source into: (id)target
{
    
    id condition = [source objectOrNilAtCollectionPath: _conditionCollectionPath];
    
    ERConditionalConversionCalculator processor = [ERConditionalConversionSet conditionCalculatorWithIdentifier: _conditionCalculatorIdentifier];
    
    if (processor && processor(condition, _conditionCalculatorParameter))
    {
        
        id sourceValue = [self sourceValueDefinedFromSource: source target: target];
        
        id value = nil;
        if (_targetCollectionPath)
        {
            
            if ([_targetCollectionType isEqualToString: ERConversionCollectionDictionaryType])
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
                
                if ([_targetCollectionType isEqualToString: ERConversionCollectionDictionaryType])
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
    else
    {
        return target;
    }
    
}

@end
