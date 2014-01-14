//
//  GRUserDetailView.m
//  GraceRoad
//
//  Created by Lei on 14-1-14.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRUserDetailView.h"
#import "GRDataService.h"
#import "GRAccountKeys.h"
#import "GRViewService.h"

@interface GRUserDetailView ()
{
    UIScrollView *_scrollView;
    
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    
    UILabel *_titleLabel;
}
@end

@implementation GRUserDetailView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        CGRect bounds = [self bounds];
        _scrollView = [[UIScrollView alloc] initWithFrame: bounds];
        [self addSubview: _scrollView];
        
        UIImageView *avatarBackgroundView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 320, 211)];
        [avatarBackgroundView setImage: [UIImage imageNamed: @"GRAvatarBackground"]];
        [_scrollView addSubview: avatarBackgroundView];
        [avatarBackgroundView release];
        
        _avatarView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 60, 60)];
        [[_avatarView layer] setCornerRadius: 30];
        [_avatarView setImage: [UIImage imageNamed: @"GRExampleAvatar"]];
        [_avatarView setClipsToBounds: YES];
        
        [_scrollView addSubview: _avatarView];
        
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(94, 15, 50, 30)];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextColor: [UIColor whiteColor]];
        [label setFont: [UIFont systemFontOfSize: 14]];
        [label setText: @"姓名："];
        [_scrollView addSubview: label];
        [label release];
        
        _nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(144, 10, 260, 40)];
        [_nameLabel setTextColor: [UIColor whiteColor]];
        //[_nameLabel setTextAlignment: NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor: [UIColor clearColor]];
        [_scrollView addSubview: _nameLabel];
        
        label = [[UILabel alloc] initWithFrame: CGRectMake(80, 50, 60, 30)];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextColor: [UIColor whiteColor]];
        [label setFont: [UIFont systemFontOfSize: 14]];
        [label setText: @"所在组："];
        [_scrollView addSubview: label];
        [label release];
        
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(144, 35, 260, 60)];
        [_titleLabel setTextColor: [UIColor whiteColor]];
        [_titleLabel setBackgroundColor: [UIColor clearColor]];
        [_scrollView addSubview: _titleLabel];
        
        NSDictionary *accountInfo = ERSSC(GRDataServiceID, GRDataServiceCurrentAccountAction, nil);
        if (accountInfo)
        {
            [_nameLabel setText: @"耶小七"];//accountInfo[GRAccountEmailKey]];
        }
        [_titleLabel setText: @"测试组"];
        
        UIButton *logoutButton = [[UIButton alloc] initWithFrame: CGRectMake(30, bounds.size.height - 60,
                                                                             bounds.size.width - 30 * 2,
                                                                             40)];
        [logoutButton setBackgroundColor: [UIColor redColor]];
        [logoutButton setTitle: @"登出"
                      forState: UIControlStateNormal];
        [logoutButton addTarget: self
                         action: @selector(_handleLogoutButtonTappedEvent:)
               forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: logoutButton];
        [logoutButton release];
    }
    return self;
}

- (void)dealloc
{
    [_scrollView release];
    [_avatarView release];
    [_nameLabel release];
    [_titleLabel release];

    [super dealloc];
}

- (void)_handleLogoutButtonTappedEvent: (id)sender
{
    ERSC(GRDataServiceID, GRDataServiceLogoutAction, nil,
         (^(id result, id exception)
          {
              ERSC(GRViewServiceID, GRViewServicePopContentViewAction, nil, nil);
          }));
}

@end
