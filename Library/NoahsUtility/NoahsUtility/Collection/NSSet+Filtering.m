//
//  NSSet+Filtering.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSSet+Filtering.h"

@implementation NSSet (Filtering)

- (NSSet *)filteredSetUsingBlock: (ERUtilityCollectionFilterBlock)block
{
    
    NSMutableSet *set = [NSMutableSet set];
    for (id element in self)
    {
        if (block(element))
        {
            [set addObject: element];
        }
    }
    
    return [NSSet setWithSet: set];
}

@end
