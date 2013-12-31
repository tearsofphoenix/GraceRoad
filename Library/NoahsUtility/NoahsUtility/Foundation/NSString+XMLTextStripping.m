//
//  NSString+XMLTextStripping.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 1/7/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+XMLTextStripping.h"

@implementation NSString (XMLTextStripping)

- (NSString *)XMLTextStripped
{
    
    NSRange range;
    
    NSString *string = [[self copy] autorelease];
    
    while ((range = [string rangeOfString: @"<[^>]+>"
                                  options: NSRegularExpressionSearch]).location != NSNotFound)
    {
        string = [string stringByReplacingCharactersInRange: range
                                                 withString: @""];
    }
    
    return string;
}

@end
