//
//  GRUserProfileView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-6.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRUserProfileView.h"
#import "GRLoginView.h"
#import "GRUserDetailView.h"
#import "GRDataService.h"

@interface GRUserProfileView ()
{
    GRLoginView *_loginView;
    GRUserDetailView *_detailView;
}
@end


@implementation GRUserProfileView

- (void)_createDetailViewWithAnimation: (BOOL)animate
{
    [self setTitle: @"我的信息"];
    
    _detailView = [[GRUserDetailView alloc] initWithFrame: [self bounds]];
    [self addSubview: _detailView];
    
    if (animate)
    {
        [_detailView setAlpha: 0];
        [UIView animateWithDuration: 0.3
                         animations: (^
                                      {
                                          [_loginView setAlpha: 0];
                                          [_detailView setAlpha: 1];
                                      })];
    }
    
}

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setHideTabbar: YES];
        CGRect bounds = [self bounds];
        
        if (!ERSSC(GRDataServiceID, GRDataServiceCurrentAccountAction, nil))
        {
            _loginView = [[GRLoginView alloc] initWithFrame: bounds];
            [_loginView setDisposableCallback: (^
                                                {
                                                    [self _createDetailViewWithAnimation: YES];
                                                })];
            
            [self addSubview: _loginView];
            [self setTitle: @"组长登陆"];
        }else
        {
            [self _createDetailViewWithAnimation: NO];
        }
    }
    return self;
}

- (void)dealloc
{
    [_detailView release];
    [_loginView release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    CGRect rect = [self bounds];
    
    [_loginView setFrame: rect];
    [_detailView setFrame: rect];
}

@end
