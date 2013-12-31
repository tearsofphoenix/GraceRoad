//
//  NSArray+ToggledMatrixArray.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 11/13/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+ToggledMatrixArray.h"

@implementation NSArray (ToggledMatrixArray)

- (NSArray *)toggledMatrixArray
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    BOOL hasNext = YES;
    
    NSInteger looper = 0;
    while (hasNext)
    {
        
        BOOL subarrayHasNext = NO;
        
        NSMutableArray *subarray = [NSMutableArray array];
        
        for (NSArray *selfSubarray in self)
        {
            
            if (looper < [selfSubarray count])
            {
                [subarray addObject: [selfSubarray objectAtIndex: looper]];
            }
            
            subarrayHasNext = subarrayHasNext || (looper + 1 < [selfSubarray count]);
        }
        
        [array addObject: subarray];
        
        hasNext = subarrayHasNext;
        
        ++looper;
    }
    
    return array;
    
}

@end
