//
//  NSArray+LocaleComparision.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 2/28/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+LocaleComparision.h"

#import <NoahsService/NoahsService.h>

#import "NSArray+NSNull.h"

#import "NSArray+CollectionPath.h"

#import "NSDictionary+CollectionPath.h"

@implementation NSArray(LocaleComparision)

- (NSArray *)sortedArrayForUsage: (NSString *)usage
{
    
    if (usage)
    {
        return [self sortedArrayForUsages: [NSSet setWithObject: usage]];
    }
    else
    {
        return [self sortedArrayForUsages: nil];
    }
    
}

- (NSArray *)sortedArrayForUsages: (NSSet *)usages
{
    
    ERLocaleComparator comparator = ERSSC(ERLocaleServiceIdentifier,
                                          ERLocaleServiceComparatorForUsages_Action,
                                          [NSArray arrayWithObjectOrNil: usages]);
    
    return [self sortedArrayUsingComparator:
            (^NSComparisonResult(id object, id object2)
             {
                 return comparator(object, object2, usages);
             })];
    
}

- (NSArray *)sortedArrayForCollectionPath: (NSString *)collectionPath
                                    usage: (NSString *)usage
{
    
    if (usage)
    {
        return [self sortedArrayForCollectionPath: collectionPath
                                           usages: [NSSet setWithObject: usage]];
    }
    else
    {
        return [self sortedArrayForCollectionPath: collectionPath
                                           usages: nil];
    }
    
}

- (NSArray *)sortedArrayForCollectionPath: (NSString *)collectionPath
                                   usages: (NSSet *)usages
{
    
    ERLocaleComparator comparator = ERSSC(ERLocaleServiceIdentifier,
                                          ERLocaleServiceComparatorForUsages_Action,
                                          [NSArray arrayWithObjectOrNil: usages]);
    
    return [self sortedArrayUsingComparator:
            (^NSComparisonResult(id object, id object2)
             {
                 
                 id key = [object objectOrNilAtCollectionPath: collectionPath];
                 id key2 = [object2 objectOrNilAtCollectionPath: collectionPath];
                 
                 return comparator(key, key2, usages);
                 
             })];
    
}

@end
