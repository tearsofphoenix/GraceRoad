//
//  GRServeView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRServeView.h"
#import <Kal/Kal.h>

@interface GRServeView()<KalViewDelegate>
{
    KalLogic *_logic;
    KalView *_calendarView;
}

@property (nonatomic, retain) NSDate *selectedDate;

@end

@implementation GRServeView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"服事"];
        
        CGRect rect = [self bounds];
        rect.size.height = 320;
        
        _logic = [[KalLogic alloc] initForDate: [NSDate date]];
        _calendarView = [[KalView alloc] initWithFrame: rect
                                              delegate: self
                                                 logic: _logic];
        
        [self addSubview: _calendarView];
    }
    return self;
}

- (void)dealloc
{
    [_logic release];
    [_calendarView release];
    
    [super dealloc];
}

- (void)showPreviousMonth
{
    
}

- (void)showFollowingMonth
{
    
}

- (void)didSelectDate: (KalDate *)date
{
    [self setSelectedDate: [date NSDate]];
    
    [_logic moveToMonthForDate: _selectedDate];
}

@end
