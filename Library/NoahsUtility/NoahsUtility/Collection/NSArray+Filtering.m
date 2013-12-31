//
//  NSArray+Filtering.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+Filtering.h"

@implementation NSArray (Filtering)

- (NSArray *)filteredArrayUsingBlock: (ERUtilityCollectionFilterBlock)block
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (id element in self)
    {
        if (block(element))
        {
            [array addObject: element];
        }
    }
    
    return [NSArray arrayWithArray: array];
}

@end
