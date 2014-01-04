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

- (void)didSwitchOut
{
    
}

@end
