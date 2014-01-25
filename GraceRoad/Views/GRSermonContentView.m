//
//  GRSermonContentView.m
//  GraceRoad
//
//  Created by Lei on 14-1-4.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRSermonContentView.h"
#import "GRSermonKeys.h"
#import "GRResourceManager.h"
#import "DKLiveBlurView.h"
#import "ILTranslucentView.h"
#import "GRViewService.h"

#import <MediaPlayer/MediaPlayer.h>

@interface GRSermonContentView ()
{
    UIImageView *_backgroundView;
    ILTranslucentView *_blurView;
    UIView *_contentView;
    UIImageView *_imageView;
    UITextView *_contentTextView;
    MPMoviePlayerController *_player;
}

@property (nonatomic, retain) UIButton *rightNavigationButton;

@end

@implementation GRSermonContentView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setHideTabbar: YES];
        
        _rightNavigationButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
        [_rightNavigationButton setBackgroundImage: [UIImage imageNamed: @"GRShareButton"]
                                          forState: UIControlStateNormal];
        [_rightNavigationButton addTarget: self
                                   action: @selector(_handleShareButtonTappedEvent:)
                         forControlEvents: UIControlEventTouchUpInside];
        
        CGRect bounds = [self bounds];
        
        _backgroundView = [[UIImageView alloc] initWithFrame: bounds];
        [_backgroundView setImage: [UIImage imageNamed: @"GRSermonBackground.jpeg"]];
        [self addSubview: _backgroundView];
        
        _blurView = [[ILTranslucentView alloc] initWithFrame: bounds];

        [_blurView setTranslucentAlpha: 0.96];
        
        [self addSubview: _blurView];

        _contentView = [[UIView alloc] initWithFrame: bounds];
        [self addSubview: _contentView];
        
        CGRect rect = CGRectMake((frame.size.width - 100) / 2, 20, 100, 100);
        
        _imageView = [[UIImageView alloc] initWithFrame: rect];
        [[_imageView layer] setCornerRadius: 50];
        [_imageView setClipsToBounds: YES];
        [_imageView setImage: [UIImage imageNamed: @"GRHeart.jpg"]];
        
        [_contentView addSubview: _imageView];
        
        _contentTextView = [[UITextView alloc] initWithFrame: CGRectMake(10,
                                                                         rect.origin.y + rect.size.height + 10,
                                                                         frame.size.width - 10 * 2,
                                                                         200)];
        [_contentTextView setBackgroundColor: [UIColor clearColor]];
        [_contentTextView setTextAlignment: NSTextAlignmentCenter];
        [_contentTextView setEditable: NO];
        [_contentTextView setFont: [UIFont systemFontOfSize: 16]];
        [_contentView addSubview: _contentTextView];
        
        _player = [[MPMoviePlayerController alloc] init];
        [_contentView addSubview: [_player view]];
        
        [[_player view] setFrame: CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
    }
    return self;
}

- (void)dealloc
{
    [_blurView release];
    [_contentView release];
    [_imageView release];
    [_contentTextView release];
    [_player release];
    [_sermonInfo release];
    [_backgroundView release];
    [_rightNavigationButton release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    CGRect bounds = [self bounds];
    
    [_backgroundView setFrame: bounds];
    [_blurView setFrame: bounds];
    [_contentView setFrame: bounds];
    [[_player view] setFrame: CGRectMake(0, bounds.size.height - 40, bounds.size.width, 40)];
}

- (void)setSermonInfo: (NSDictionary *)sermonInfo
{
    if (_sermonInfo != sermonInfo)
    {
        [_sermonInfo release];
        _sermonInfo = [sermonInfo retain];
        
        [self setTitle: _sermonInfo[GRSermonTitle]];
        
        [_contentTextView setText: _sermonInfo[GRSermonContent]];
        
        NSString *path = [GRResourceManager pathWithSubPath: _sermonInfo[GRSermonAudioPath]];
        [_player setContentURL: [NSURL fileURLWithPath: path]];
        [_player prepareToPlay];
        [_player play];
    }
}

- (void)didSwitchOut
{
    [_player pause];
}

- (void)_handleShareButtonTappedEvent: (id)sender
{
    NSArray *sharedData = @[ _sermonInfo[GRSermonTitle] ];
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems: sharedData
                                                                                      applicationActivities: nil];
    
    UIViewController *rootViewController = ERSSC(GRViewServiceID, GRViewServiceRootViewControllerAction, nil);
    [rootViewController presentViewController: shareViewController
                                     animated: YES
                                   completion: nil];
    [shareViewController release];
}

@end
