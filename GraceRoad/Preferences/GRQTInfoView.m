//
//  GRQTInfoView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-24.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRQTInfoView.h"
#import "GRShared.h"
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
        
        CGFloat offset = 0;
        if (IsIPhone5)
        {
            offset = 50;
        }
        
        CGRect rect = CGRectMake(10, 20, 300, 120 + offset);
        _scriptureView = [[UITextView alloc] initWithFrame: rect];
        [_scriptureView setEditable: NO];
        [[_scriptureView layer] setCornerRadius: 6];
        [_scriptureView setFont: [UIFont systemFontOfSize: 16]];
        
        [self addSubview: _scriptureView];
        
        rect.origin.y += rect.size.height + 20;
        rect.size.height = 200 + offset;
        
        _questionView = [[UITextView alloc] initWithFrame: rect];
        [_questionView setEditable: NO];
        [[_questionView layer] setCornerRadius: 6];
        [_questionView setFont: [UIFont systemFontOfSize: 16]];
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
