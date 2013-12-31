//
//  NSArray+Groupping.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/5/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+Groupping.h"

#import "NSArray+LocaleComparision.h"

@implementation NSArray(Groupping)

- (NSArray *)grouppedArrayBySortingCollectionPath: (NSString *)collectionPath
                                           usages: (NSSet *)usages
                                   categoryGetter: (ERArrayCategoryGetter)categoryGetter
{

    
    NSArray *sortedArray = self;
    
    if (collectionPath)
    {
        sortedArray = [self sortedArrayForCollectionPath: collectionPath
                                                  usages: usages];
    }

    id lastSectionHeader = nil;
    NSMutableArray *finalArray = [NSMutableArray array];
    for (id element in sortedArray)
    {

        id sectionHeader = categoryGetter(element);

        if (![sectionHeader isEqual: lastSectionHeader])
        {

            lastSectionHeader = sectionHeader;

            [finalArray addObject: [NSMutableArray array]];

        }

        [[finalArray lastObject] addObject: element];

    }

    return finalArray;

}

@end
