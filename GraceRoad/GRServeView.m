//
//  GRServeView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRServeView.h"

@interface GRServeView()

@property (nonatomic, retain) NSDate *selectedDate;

@end

@implementation GRServeView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"服事"];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)showPreviousMonth
{
    
}

- (void)showFollowingMonth
{
    
}

@end
