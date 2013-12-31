//
//  NSArray+ReversedArray.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/3/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+ReversedArray.h"

@implementation NSArray(ReversedArray)

- (NSArray *)reversedArray
{
    
    NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:[self count]];
    
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator)
    {
        [reversedArray addObject:element];
    }
    
    return [NSArray arrayWithArray: reversedArray];
}

@end
