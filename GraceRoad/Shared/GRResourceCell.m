//
//  GRResourceCell.m
//  GraceRoad
//
//  Created by Lei on 14-1-18.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRResourceCell.h"

@implementation GRResourceCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGRect bounds = [self bounds];
    [[self imageView] setFrame: CGRectMake(10, 2, 36, 36)];
    [[self imageView] setContentMode: UIViewContentModeScaleAspectFill];
}

@end
