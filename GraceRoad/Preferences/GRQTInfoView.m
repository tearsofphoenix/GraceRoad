//
//  GRQTInfoView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-24.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRQTInfoView.h"
#import <QuartzCore/QuartzCore.h>

@interface GRQTInfoView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *scriptureView;
@property (nonatomic, strong) UITextView *questionView;

@end

@implementation GRQTInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];

        [self setHideTabbar: YES];
        [self addSubview: _titleLabel];
        
        _scriptureView = [[UITextView alloc] initWithFrame: CGRectMake(10, 20, 300, 120)];
        [_scriptureView setEditable: NO];
        [[_scriptureView layer] setCornerRadius: 6];
        [self addSubview: _scriptureView];
        
        _questionView = [[UITextView alloc] initWithFrame: CGRectMake(10, 160, 300, 200)];
        [_questionView setEditable: NO];
        [[_questionView layer] setCornerRadius: 6];
        [self addSubview: _questionView];
    }
    return self;
}

- (void)dealloc
{
    [_titleLabel release];
    [_scriptureView release];
    [_questionView release];
    
    [_QTInfo release];
    
    [super dealloc];
}

- (void)setQTInfo: (NSDictionary *)QTInfo
{
    if (_QTInfo != QTInfo)
    {
        [_QTInfo release];
        _QTInfo = [QTInfo retain];

        [self setTitle: _QTInfo[@"title"]];
        [_scriptureView setText: _QTInfo[@"scripture"]];
        [_questionView setText: _QTInfo[@"questions"]];
    }
}

@end
