//
//  NSString+Words.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 1/7/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+Words.h"

#define ERStringMaximumWordLength 64

@implementation NSString (Words)

- (NSArray *)words
{
    
    NSMutableArray *words = [NSMutableArray array];
    
    [self enumerateSubstringsInRange: NSMakeRange(0, [self length])
                             options: NSStringEnumerationByWords
                          usingBlock: (^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
                                       {
                                           [words addObject: substring];
                                       })];
    
    return words;
}

- (NSRange)closestSelectableExpressionRangeArroundIndex: (NSInteger)index
{

    __block NSRange lastRange;
    
    __block NSRange result = NSMakeRange(NSNotFound, 0);

    NSInteger searchRangeStart = index - ERStringMaximumWordLength;
    NSInteger searchRangeEnd = index + ERStringMaximumWordLength;

    if (searchRangeStart < 0)
    {
        searchRangeStart = 0;
    }

    if (searchRangeEnd > [self length])
    {
        searchRangeEnd = [self length];
    }

    [self enumerateSubstringsInRange: NSMakeRange(searchRangeStart, searchRangeEnd - searchRangeStart)
                             options: NSStringEnumerationByWords
                          usingBlock: (^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
                                       {

                                           if (substringRange.location + substringRange.length <= index)
                                           {
                                               lastRange = substringRange;
                                           }
                                           else
                                           {
                                               
                                               if (substringRange.location <= index)
                                               {
                                                   result = substringRange;
                                               }
                                               else if ((substringRange.location - lastRange.location - lastRange.length) > 1)
                                               {
                                                   result = NSMakeRange(lastRange.location + lastRange.length,
                                                                        substringRange.location - lastRange.location - lastRange.length);
                                               }
                                               else
                                               {
                                                   result = lastRange;
                                               }

                                               *stop = YES;

                                           }
                                           
                                       })];

    if (result.location == NSNotFound)
    {
        result = NSMakeRange([self length], 0);
    }
    
    return result;
}

@end
