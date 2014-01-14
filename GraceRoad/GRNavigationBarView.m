//
//  GRNavigationBarView.m
//  GraceRoad
//
//  Created by Lei on 13-12-28.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRNavigationBarView.h"
#import "GRViewService.h"

#import <QuartzCore/QuartzCore.h>

@interface GRNavigationBarView ()
{
    UIButton *_leftNavigationButton;
    UILabel *_titleLabel;
}
@end

@implementation GRNavigationBarView

- (void)_initializeContent
{
//    [self setBackgroundColor: [UIColor colorWithRed: 0.16f
//                                              green: 0.53f
//                                               blue: 0.78f
//                                              alpha: 1.00f]];
    
    [self setBackgroundColor: [UIColor colorWithRed: 0.16f
                                              green: 0.56f
                                               blue: 0.87f
                                              alpha: 1.00f]];
    CGRect rect = [self bounds];
    rect.size.height -= 2;
    
    _titleLabel = [[UILabel alloc] initWithFrame: rect];
    [_titleLabel setBackgroundColor: [UIColor clearColor]];
    [_titleLabel setTextAlignment: NSTextAlignmentCenter];
    [_titleLabel setFont: [UIFont boldSystemFontOfSize: 24]];
    [_titleLabel setTextColor: [UIColor whiteColor]];
    
    [self addSubview: _titleLabel];

    rect.origin.y += rect.size.height;
    rect.size.height = 2;
    
    UIView *lineView = [[UIView alloc] initWithFrame: rect];
    [lineView setBackgroundColor: [UIColor colorWithRed: 0.80f
                                                  green: 0.80f
                                                   blue: 0.81f
                                                  alpha: 1.00f]];
    //[lineView setAlpha: 0.7];
    [self addSubview: lineView];
    [lineView release];

    CGRect bounds = [self bounds];

    rect.size.height = 44 * 0.6;
    rect.origin = CGPointMake(10, (bounds.size.height - rect.size.height) / 2);
    rect.size.width = 123 * 0.6;
    
    _leftNavigationButton = [[UIButton alloc] initWithFrame: rect];
    [_leftNavigationButton setImage: [UIImage imageNamed: @"GRBackButton"]
                           forState: UIControlStateNormal];
    [_leftNavigationButton addTarget: self
                             action: @selector(_handleLeftButtonTappedEvent:)
                   forControlEvents: UIControlEventTouchUpInside];
    
    [_leftNavigationButton setAlpha: 0];
    
    [self addSubview: _leftNavigationButton];
}

- (UIButton *)leftNavigationButton
{
    return _leftNavigationButton;
}

- (void)setRightNavigationButton: (UIButton *)rightNavigationButton
{
    if (_rightNavigationButton != rightNavigationButton)
    {
        [_rightNavigationButton removeFromSuperview];
        
        _rightNavigationButton = rightNavigationButton;
        
        CGRect bounds = [self bounds];
        
        [_rightNavigationButton setFrame: CGRectMake(bounds.size.width - 40, 8, 28, 28)];
        
        [self addSubview: rightNavigationButton];
    }
}

- (void)_handleLeftButtonTappedEvent: (id)sender
{
    ERSC(GRViewServiceID,
         GRViewServicePopContentViewAction, nil, nil);
}

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self _initializeContent];
    }
    
    return self;
}

- (id)initWithCoder: (NSCoder *)aDecoder
{
    if ((self = [super initWithCoder: aDecoder]))
    {
        [self _initializeContent];
    }
    
    return self;
}

- (void)dealloc
{
    [_leftNavigationButton release];
    [_titleLabel release];
    
    [super dealloc];
}

- (void)setTitle: (NSString *)title
{
    [_titleLabel setText: title];
}

- (NSString *)title
{
    return [_titleLabel text];
}

- (void)needUpdateContentView: (id<GRContentView>)contentView
{
    [self setTitle: [contentView title]];
}

@end
