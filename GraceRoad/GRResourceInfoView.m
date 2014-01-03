//
//  GRResourceInfoView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceInfoView.h"
#import "GRResourceKey.h"

@implementation GRResourceInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor: [UIColor whiteColor]];
    }
    return self;
}

- (void)dealloc
{
    [_resourceInfo release];
    
    [super dealloc];
}

- (void)setResourceInfo: (NSDictionary *)resourceInfo
{
    if (_resourceInfo != resourceInfo)
    {
        [_resourceInfo release];
        _resourceInfo = [resourceInfo retain];

        [self setTitle: _resourceInfo[GRResourceName]];
    }
}

@end
