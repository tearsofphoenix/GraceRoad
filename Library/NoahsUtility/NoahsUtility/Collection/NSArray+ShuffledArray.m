//
//  NSArray+ShuffledArray.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 11/13/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+ShuffledArray.h"

#import <stdlib.h>

@implementation NSArray(ShuffledArray)

- (NSArray *)shuffledArray
{
    
    NSMutableArray *source = [self mutableCopy];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([source count])
    {
        
        int index = rand() % [source count];
        
        [array addObject: [source objectAtIndex: index]];
        
        [source removeObjectAtIndex: index];
        
    }
    
    [source release];
    
    return array;
}

@end
