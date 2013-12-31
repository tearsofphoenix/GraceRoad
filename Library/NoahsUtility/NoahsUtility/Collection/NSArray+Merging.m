//
//  NSArray+Merging.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/4/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+Merging.h"

#import "NSDictionary+Merging.h"

#import "NSMutableArray+NSNull.h"

@implementation NSArray(Merging)

- (NSArray *)arrayMergedWithArray: (NSArray *)array
{

    NSMutableArray *result = [NSMutableArray arrayWithArray: self];

    int looper = 0;
    while (looper < [array count])
    {

        id value = [array objectAtIndex: looper];
        
        if (looper < [result count])
        {
            
            if ([value isKindOfClass: [NSDictionary class]])
            {

                id resultValue = [result objectAtIndex: looper];
                if ([resultValue isKindOfClass: [NSDictionary class]])
                {
                    [result setObject: [resultValue dictionaryMergedWithDictionary: value]
                              atIndex: looper];
                }
                else
                {
                    [result setObject: value atIndex: looper];
                }

            }
            else if ([value isKindOfClass: [NSArray class]])
            {

                id resultValue = [result objectAtIndex: looper];
                if ([resultValue isKindOfClass: [NSArray class]])
                {
                    [result setObject: [resultValue arrayMergedWithArray: value]
                              atIndex: looper];
                }
                else
                {
                    [result setObject: value atIndex: looper];
                }

            }
            else
            {
                [result setObject: value atIndex: looper];
            }

        }
        else
        {
            [result setObject: value
                      atIndex: looper];
        }

        ++looper;

    }

    return [NSArray arrayWithArray: result];
}

@end
