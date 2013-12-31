//
//  ERConversionConfiguration.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

//#import "ERConversionConfiguration.h"
//
//#import "NSArray+NSNull.h"
//#import "NSDictionary+NSNull.h"
//
//#import "NSMutableDictionary+NSNull.h"
//
//#import "NSDictionary+CollectionPath.h"
//#import "NSMutableDictionary+CollectionPath.h"
//
//#import "NSMutableDictionary+Merging.h"
//
//#import "NSArray+Filtering.h"
//#import "NSSet+Filtering.h"
//#import "NSDictionary+Filtering.h"

#import <NoahsUtility/NoahsUtility.h>

@implementation ERConversionConfiguration

@synthesize sourceCollectionPath = _sourceCollectionPath;
@synthesize targetCollectionPath = _targetCollectionPath;
@synthesize targetMode = _targetMode;
@synthesize sourceMode = _sourceMode;
@synthesize value = _value;

@synthesize expectedSourceCollectionType = _expectedSourceCollectionType;

- (void)dealloc
{

    [_sourceCollectionPath release];
    [_targetCollectionPath release];

    [_value release];

    [_sourceMode release];
    [_targetMode release];

    [_expectedSourceCollectionType release];

    [super dealloc];
}

- (id)sourceValueDefinedFromSource: (id)source
                            target: (id)target
{

    id value = _value;
    if (!value)
    {
        
        if ([_sourceMode isEqualToString: ERConversionSourceReflectionMode])
        {
            value = [target objectOrNilAtCollectionPath: _sourceCollectionPath];
        }
        else if ([_sourceMode isEqualToString: ERConversionSourceDirectionMode])
        {
            value = [source objectOrNilAtCollectionPath: _sourceCollectionPath];
        }
        else
        {
            value = [source objectOrNilAtCollectionPath: _sourceCollectionPath];
        }
        
    }
    else if ([value isKindOfClass: [NSNull class]])
    {
        value = nil;
    }

    value = [ERConversionConfiguration ensureSource: value isCollectionType: _expectedSourceCollectionType];

    return value;
    
}

- (id)convert: (id)source
{
    return [self convert: source into: nil];
}

- (id)convert: (id)source
         into: (id)target
{
    
    id value = [self sourceValueDefinedFromSource: source target: target];
    
    return [ERConversionConfiguration fillValue: value
                               atCollectionPath: _targetCollectionPath
                                      forTarget: target
                                 withTargetMode: _targetMode];
    
}

+ (id)     fillValue: (id)value
    atCollectionPath: (NSString *)targetCollectionPath
           forTarget: (id)target
      withTargetMode: (NSString *)targetMode
{
    
    if (targetCollectionPath)
    {
        
        if ([targetMode isEqualToString: ERConversionTargetReplaceMode])
        {
            [target setObjectOrNil: value
                  atCollectionPath: targetCollectionPath];
        }
        else if ([targetMode isEqualToString: ERConversionTargetInsertMode])
        {
            
            id collection = [target objectOrNilAtCollectionPath: targetCollectionPath];
            if (!collection)
            {
                
                collection = [NSMutableArray array];
                
                [target setObjectOrNil: collection
                      atCollectionPath: targetCollectionPath];
                
            }
            
            [collection addObject: value];
            
        }
        else if ([targetMode isEqualToString: ERConversionTargetIncludeMode])
        {
            
            id collection = [target objectOrNilAtCollectionPath: targetCollectionPath];
            if (!collection)
            {
                
                collection = [NSMutableSet set];
                
                [target setObjectOrNil: collection
                      atCollectionPath: targetCollectionPath];
                
            }
            
            [collection addObject: value];
            
        }
        else if ([targetMode isEqualToString: ERConversionTargetMergeMode])
        {
            
            id collection = [target objectOrNilAtCollectionPath: targetCollectionPath];
            if (!collection)
            {
                
                collection = [NSMutableDictionary dictionary];
                
                [target setObjectOrNil: collection
                      atCollectionPath: targetCollectionPath];
                
            }
            
            [collection mergeWithDictionary: value];
            
        }
        else if ([targetMode isEqualToString: ERConversionTargetAppendMode])
        {
            
            id collection = [target objectOrNilAtCollectionPath: targetCollectionPath];
            if (!collection)
            {
                
                collection = [NSMutableArray array];
                
            }
            
            [collection addObjectsFromArray: value];
            
        }
        else
        {
            [target setObjectOrNil: value
                  atCollectionPath: targetCollectionPath];
        }
        
        return target;
    }
    else
    {
        
        if ([targetMode isEqualToString: ERConversionTargetReplaceMode])
        {
            return value;
        }
        else if ([targetMode isEqualToString: ERConversionTargetInsertMode])
        {
            
            if (!target)
            {
                target = [NSMutableArray array];
            }
            
            [target addObject: value];
            
            return target;
            
        }
        else if ([targetMode isEqualToString: ERConversionTargetIncludeMode])
        {
            
            if (!target)
            {
                target = [NSMutableSet set];
            }
            
            [target addObject: value];
            
            return target;
            
        }
        else if ([targetMode isEqualToString: ERConversionTargetMergeMode])
        {
            
            if (!target)
            {
                target = [NSMutableDictionary dictionary];
            }
            
            [target mergeWithDictionary: value];
            
            return target;
            
        }
        else if ([targetMode isEqualToString: ERConversionTargetAppendMode])
        {
            
            if (!target)
            {
                target = [NSMutableArray array];
            }
            
            [target addObjectsFromArray: value];
            
            return target;
            
        }
        else
        {
            return value;
        }
        
    }
    
}

+ (id)ensureSource: (id)source
  isCollectionType: (NSString *)collectionType
{
    
    if (source && collectionType)
    {
        
        if ([source isKindOfClass: [NSArray class]])
        {
            
            if ([collectionType isEqualToString: ERConversionCollectionElementType])
            {
                return [source objectOrNilAtIndex: 0];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionElementNoZeroLengthStringType])
            {
                return [[source filteredArrayUsingBlock:
                         (^BOOL (id element)
                          {
                              return !([element isKindOfClass: [NSNull class]] ||
                                       ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                          })] objectOrNilAtIndex: 0];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayType])
            {
                return source;
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayNoZeroLengthStringType])
            {
                return [source filteredArrayUsingBlock:
                        (^BOOL (id element)
                         {
                             return !([element isKindOfClass: [NSNull class]] ||
                                      ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                         })];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetType])
            {
                return [NSMutableSet setWithArray: source];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetNoZeroLengthStringType])
            {
                return [[NSMutableSet setWithArray: source] filteredSetUsingBlock:
                        (^BOOL (id element)
                         {
                             return !([element isKindOfClass: [NSNull class]] ||
                                      ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                         })];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryType])
            {

                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                [source enumerateObjectsUsingBlock:
                 (^(id object, NSUInteger index, BOOL *stop)
                  {
                      [dictionary setObject: object forKey: [[NSNumber numberWithInteger: index] stringValue]];
                  })];
                
                return dictionary;
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryNoZeroLengthStringType])
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                [source enumerateObjectsUsingBlock:
                 (^(id object, NSUInteger index, BOOL *stop)
                  {
                      [dictionary setObject: object forKey: [[NSNumber numberWithInteger: index] stringValue]];
                  })];
                
                return [dictionary filteredDictionaryUsingBlock:
                        (^BOOL (id key, id element)
                         {
                             return !([element isKindOfClass: [NSNull class]] ||
                                      ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                         })];
            }
            else
            {
                return source;
            }
            
        }
        else if ([source isKindOfClass: [NSSet class]])
        {
            
            if ([collectionType isEqualToString: ERConversionCollectionElementType])
            {
                return [source anyObject];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionElementNoZeroLengthStringType])
            {
                return [[source filteredSetUsingBlock:
                         (^BOOL (id element)
                          {
                              return !([element isKindOfClass: [NSNull class]] ||
                                       ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                          })] anyObject];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayType])
            {
                return [source allObjects];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayNoZeroLengthStringType])
            {
                return [[source filteredSetUsingBlock:
                         (^BOOL (id element)
                          {
                              return !([element isKindOfClass: [NSNull class]] ||
                                       ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                          })] allObjects];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetType])
            {
                return source;
            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetNoZeroLengthStringType])
            {
                return [source filteredSetUsingBlock:
                        (^BOOL (id element)
                         {
                             return !([element isKindOfClass: [NSNull class]] ||
                                      ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                         })];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryType])
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                [[source allObjects] enumerateObjectsUsingBlock:
                 (^(id object, NSUInteger index, BOOL *stop)
                  {
                      [dictionary setObject: object forKey: [[NSNumber numberWithInteger: index] stringValue]];
                  })];
                
                return dictionary;
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryNoZeroLengthStringType])
            {

                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                [[[source filteredSetUsingBlock:
                   (^BOOL (id element)
                    {
                        return !([element isKindOfClass: [NSNull class]] ||
                                 ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                    })] allObjects] enumerateObjectsUsingBlock:
                 (^(id object, NSUInteger index, BOOL *stop)
                  {
                      [dictionary setObject: object forKey: [[NSNumber numberWithInteger: index] stringValue]];
                  })];
                
                return dictionary;
            }
            else
            {
                return source;
            }
            
        }
        else if ([source isKindOfClass: [NSDictionary class]])
        {
            
            if ([collectionType isEqualToString: ERConversionCollectionElementType])
            {
                return [source objectOrNilForKey: [[source allKeys] objectOrNilAtIndex: 0]];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionElementNoZeroLengthStringType])
            {
                
                id dictionary = [source filteredDictionaryUsingBlock:
                                 (^BOOL (id key, id element)
                                  {
                                      return !([element isKindOfClass: [NSNull class]] ||
                                               ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                                  })];
                
                return [dictionary objectOrNilForKey: [[dictionary allKeys] objectOrNilAtIndex: 0]];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayType])
            {
                
                NSMutableArray *array = [NSMutableArray array];
                
                [source enumerateKeysAndObjectsUsingBlock:
                 (^(id key, id object, BOOL *stop)
                  {
                      [array addObject: object];
                  })];
                
                return array;
                
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayNoZeroLengthStringType])
            {
                
                NSMutableArray *array = [NSMutableArray array];
                
                [[source filteredDictionaryUsingBlock:
                  (^BOOL (id key, id element)
                   {
                       return !([element isKindOfClass: [NSNull class]] ||
                                ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                   })] enumerateKeysAndObjectsUsingBlock:
                 (^(id key, id object, BOOL *stop)
                  {
                      [array addObject: object];
                  })];
                
                return array;

            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetType])
            {
                
                NSMutableSet *set = [NSMutableSet set];
                
                [source enumerateKeysAndObjectsUsingBlock:
                 (^(id key, id object, BOOL *stop)
                  {
                      [set addObject: object];
                  })];
                
                return set;
                
            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetNoZeroLengthStringType])
            {
                
                NSMutableSet *set = [NSMutableSet set];
                
                [[source filteredDictionaryUsingBlock:
                  (^BOOL (id key, id element)
                   {
                       return !([element isKindOfClass: [NSNull class]] ||
                                ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                   })] enumerateKeysAndObjectsUsingBlock:
                 (^(id key, id object, BOOL *stop)
                  {
                      [set addObject: object];
                  })];
                
                return set;
                
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryType])
            {
                return source;
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryNoZeroLengthStringType])
            {
             
                return [source filteredDictionaryUsingBlock:
                        (^BOOL (id key, id element)
                         {
                             return !([element isKindOfClass: [NSNull class]] ||
                                      ([element isKindOfClass: [NSString class]] && ([element length] == 0)));
                         })];
                
            }
            else
            {
                return source;
            }
            
        }
        else
        {
            /*
            if ([source isKindOfClass: [NSString class]])
            {
                if ([[source uppercaseString] isEqualToString: @"N/A"])
                {
                    source = [NSNull null];
                }
            }
             */
            
            if ([collectionType isEqualToString: ERConversionCollectionElementType])
            {
                return source;
            }
            else if ([collectionType isEqualToString: ERConversionCollectionElementNoZeroLengthStringType])
            {
                
                if (!([source isKindOfClass: [NSNull class]] ||
                      ([source isKindOfClass: [NSString class]] && ([source length] == 0))))
                {
                    return source;
                }
                else
                {
                    return nil;
                }
                
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayType])
            {
                return [NSMutableArray arrayWithObject: source];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionArrayNoZeroLengthStringType])
            {
                
                if (!([source isKindOfClass: [NSNull class]] ||
                      ([source isKindOfClass: [NSString class]] && ([source length] == 0))))
                {
                    return [NSMutableArray arrayWithObject: source];
                }
                else
                {
                    return [NSMutableArray array];
                }
                
            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetType])
            {
                return [NSMutableSet setWithObject: source];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionSetNoZeroLengthStringType])
            {
                
                if (!([source isKindOfClass: [NSNull class]] ||
                      ([source isKindOfClass: [NSString class]] && ([source length] == 0))))
                {
                    return [NSMutableSet setWithObject: source];
                }
                else
                {
                    return [NSMutableSet set];
                }
                
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryType])
            {
                return [NSDictionary dictionaryWithKey: [[NSNumber numberWithInteger: 0] stringValue]
                                           objectOrNil: source];
            }
            else if ([collectionType isEqualToString: ERConversionCollectionDictionaryNoZeroLengthStringType])
            {
                
                if (!([source isKindOfClass: [NSNull class]] ||
                      ([source isKindOfClass: [NSString class]] && ([source length] == 0))))
                {
                    return [NSDictionary dictionaryWithKey: [[NSNumber numberWithInteger: 0] stringValue]
                                               objectOrNil: source];
                }
                else
                {
                    return [NSDictionary dictionary];
                }
                
            }
            else
            {
                return source;
            }
            
        }
        
    }
    else
    {
        return source;
    }
    
}

@end
