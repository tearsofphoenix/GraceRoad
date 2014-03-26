//
//  GREventCell.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-26.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GREventCell.h"

@interface GREventCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation GREventCell

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        CGRect bounds = [self bounds];
        bounds.origin.x += 10;
        bounds.origin.y += 10;
        bounds.size.width -= 10 * 2;
        bounds.size.height -= 10 * 2;
        
        _label = [[UILabel alloc] initWithFrame: bounds];
        [self addSubview: _label];
    }
    return self;
}

- (void)dealloc
{
    [_label release];
    
    [super dealloc];
}

- (void)setEventInfo: (NSDictionary *)eventInfo
{
    if (_eventInfo != eventInfo)
    {
        [_eventInfo release];
        _eventInfo = [eventInfo retain];
        
        [_label setText: [_eventInfo[GRDateKey] stringByAppendingFormat: @"   %@", _eventInfo[GRContentKey]]];
    }
}

@end
