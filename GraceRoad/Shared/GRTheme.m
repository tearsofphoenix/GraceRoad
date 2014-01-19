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

+ (UIColor *)blueColor
{
    static UIColor *blueColor = nil;
    if (!blueColor)
    {
        blueColor = [[UIColor colorWithRed: 0.16f
                                     green: 0.56f
                                      blue: 0.87f
                                     alpha: 1.00f] retain];
    }
    
    return blueColor;
}

+ (UIColor *)lightBlueColor
{
    static UIColor *lightBlueColor = nil;
    if (!lightBlueColor)
    {
        lightBlueColor = [[UIColor colorWithRed: 0.79
                                          green: 0.85
                                           blue: 0.96
                                          alpha: 1] retain];
    }
    
    return lightBlueColor;
}

+ (UIColor *)headerBlueColor
{
    static UIColor *headerBlueColor = nil;
    
    if (!headerBlueColor)
    {
        headerBlueColor = [[UIColor colorWithRed: 83 / 255.0
                                          green: 152 / 255.0
                                           blue: 253 / 255.0
                                           alpha: 0.8] retain];
    }
    
    return headerBlueColor;
}

+ (UILabel *)newheaderLabel
{
    UILabel *headerLabel = [[UILabel alloc] init];
    
    [headerLabel setBackgroundColor: [GRTheme headerBlueColor]];
    [headerLabel setTextColor: [UIColor whiteColor]];
    
    return [headerLabel autorelease];
}

@end
