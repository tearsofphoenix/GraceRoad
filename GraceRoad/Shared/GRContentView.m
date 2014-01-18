//
//  GRContentView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-3.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRContentView.h"

@interface GRContentView ()
{
    BOOL _isContentValid;
}
@end

@implementation GRContentView

- (id)initWithFrame: (CGRect)frame
{
    if ((self = [super initWithFrame: frame]))
    {
        [self setClipsToBounds: YES];
        [self setBackgroundColor: [UIColor colorWithRed: 0.93f
                                                  green: 0.95f
                                                   blue: 0.96f
                                                  alpha: 1.00f]];
    }
    
    return self;
}

- (void)setTitle: (NSString *)title
{
    if (_title != title)
    {
        [_title release];
        _title = [title retain];
        
        if (_delegate)
        {
            [_delegate needUpdateContentView: self];
        }else
        {
            _isContentValid = NO;
        }
    }
}

- (void)setDelegate: (id<GRContentViewDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
    }
    
    if (!_isContentValid)
    {
        _isContentValid = YES;
        
        [_delegate needUpdateContentView: self];
    }
}

- (void)willSwitchIn
{
    
}

- (void)didSwitchIn
{
    
}

- (void)didSwitchOut
{
    
}

- (UIButton *)rightNavigationButton
{
    return nil;
}

@end
