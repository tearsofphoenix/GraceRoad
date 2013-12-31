//
//  GRResourceView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceView.h"

@implementation GRResourceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor: [UIColor greenColor]];
    }
    return self;
}

- (NSString *)title
{
    return @"资料";
}

@end
