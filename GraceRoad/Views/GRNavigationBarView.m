//
//  GRNavigationBarView.m
//  GraceRoad
//
//  Created by Lei on 13-12-28.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRNavigationBarView.h"
#import "GRViewService.h"
#import "GRTheme.h"
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
    [self setBackgroundColor: [GRTheme blueColor]];
    
    CGRect bounds = [self bounds];
    
    _leftNavigationButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60, bounds.size.height)];
    [_leftNavigationButton setImageEdgeInsets: UIEdgeInsetsMake(8, 10, 8, 15)];
    [_leftNavigationButton setImage: [UIImage imageNamed: @"GRBackButton"]
                           forState: UIControlStateNormal];
    [_leftNavigationButton addTarget: self
                             action: @selector(_handleLeftButtonTappedEvent:)
                   forControlEvents: UIControlEventTouchUpInside];

    [_leftNavigationButton setAlpha: 0];
    
    [self addSubview: _leftNavigationButton];
    
    CGRect rect = bounds;
    rect.origin.x = 60;
    rect.size.width = bounds.size.width - rect.origin.x - bounds.size.height;
    
    _titleLabel = [[UILabel alloc] initWithFrame: rect];
    
    [_titleLabel setBackgroundColor: [UIColor clearColor]];
    [_titleLabel setTextAlignment: NSTextAlignmentCenter];
    [_titleLabel setFont: [UIFont boldSystemFontOfSize: 24]];
    [_titleLabel setTextColor: [UIColor whiteColor]];
    [_titleLabel setAdjustsFontSizeToFitWidth: YES];
    [_titleLabel setNumberOfLines: 1];
    
    [self addSubview: _titleLabel];

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
        
        [_rightNavigationButton setFrame: CGRectMake(bounds.size.width - bounds.size.height - 4,
                                                     0, bounds.size.height, bounds.size.height)];
        
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
