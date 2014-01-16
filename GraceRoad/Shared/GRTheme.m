//
//  GRTheme.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-16.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRTheme.h"

@implementation GRTheme

+ (UIColor *)darkColor
{
    static UIColor* darkColor = nil;
    
    if (!darkColor)
    {
        darkColor = [[UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f] retain];
    }
    
    return darkColor;
}

@end
