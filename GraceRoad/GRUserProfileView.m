//
//  GRUserProfileView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-6.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRUserProfileView.h"
#import "GRAccountKeys.h"
#import "GRDataService.h"

#import <QuartzCore/QuartzCore.h>

@interface GRUserProfileView ()
{
    UIScrollView *_scrollView;
    
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    
    UILabel *_noteLabel;    
}
@end


@implementation GRUserProfileView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"我的信息"];
        [self setBackgroundColor: [UIColor whiteColor]];
        
        _scrollView = [[UIScrollView alloc] initWithFrame: [self bounds]];
        [self addSubview: _scrollView];
        
        UIImageView *avatarBackgroundView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 320, 211)];
        [avatarBackgroundView setImage: [UIImage imageNamed: @"GRAvatarBackground"]];
        [_scrollView addSubview: avatarBackgroundView];
        [avatarBackgroundView release];
        
        _avatarView = [[UIImageView alloc] initWithFrame: CGRectMake(110, 43, 100, 100)];
        [[_avatarView layer] setCornerRadius: 50];
        [_avatarView setBackgroundColor: [UIColor redColor]];
        [_scrollView addSubview: _avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(30, 158, 260, 40)];
        [_nameLabel setTextColor: [UIColor whiteColor]];
        [_nameLabel setTextAlignment: NSTextAlignmentCenter];
        [_nameLabel setBackgroundColor: [UIColor clearColor]];
        [_scrollView addSubview: _nameLabel];
        
        _noteLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 220, 320, 60)];
        [_noteLabel setBackgroundColor: [UIColor clearColor]];
        [_scrollView addSubview: _noteLabel];

        NSDictionary *accountInfo = ERSSC(GRDataServiceID, GRDataServiceCurrentAccountAction, nil);
        if (accountInfo)
        {
            [_nameLabel setText: accountInfo[GRAccountEmailKey]];
        }
    }
    return self;
}

- (void)dealloc
{
    [_scrollView release];
    [_avatarView release];
    [_nameLabel release];
    [_noteLabel release];
    
    [super dealloc];
}

@end
