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
#import <MediaPlayer/MediaPlayer.h>

@interface GRSermonContentView ()
{
    DKLiveBlurView *_backgroundView;
    UIView *_contentView;
    UIImageView *_imageView;
    UITextView *_contentTextView;
    MPMoviePlayerController *_player;
}
@end

@implementation GRSermonContentView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setHideTabbar: YES];
        
        _backgroundView = [[DKLiveBlurView alloc] initWithFrame: [self bounds]];
        [_backgroundView setOriginalImage: [UIImage imageNamed: @"GRSermonBackground.jpeg"]];
        [_backgroundView setIsGlassEffectOn: YES];
        [self addSubview: _backgroundView];
        
        _contentView = [[UIView alloc] initWithFrame: [self bounds]];
        [self addSubview: _contentView];
        //[self setBackgroundColor: [UIColor colorWithRed:0.95f green:0.95f blue:0.96f alpha:1.00f]];
        
        //[self setBackgroundColor: [UIColor whiteColor]];
        
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
    [_contentView release];
    [_imageView release];
    [_contentTextView release];
    [_player release];
    [_sermonInfo release];
    [_backgroundView release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    CGRect bounds = [self bounds];
    
    [_backgroundView setFrame: bounds];
    [_contentView setFrame: bounds];
    [[_player view] setFrame: CGRectMake(0, bounds.size.height - 40, bounds.size.width, 40)];
}

- (void)didSwitchIn
{
    [UIView animateWithDuration: 0.1
                     animations: (^
                                  {
                                      [_backgroundView setBlurLevel: 1.2];
                                  })];
}

- (void)setSermonInfo: (NSDictionary *)sermonInfo
{
    if (_sermonInfo != sermonInfo)
    {
        [_sermonInfo release];
        _sermonInfo = [sermonInfo retain];
        
        [self setTitle: _sermonInfo[GRSermonTitle]];
        
        [_contentTextView setText: _sermonInfo[GRSermonAbstract]];
        
        NSString *path = [GRResourceManager pathWithSubPath: _sermonInfo[GRSermonPath]];
        [_player setContentURL: [NSURL fileURLWithPath: path]];
        [_player prepareToPlay];
        [_player play];
    }
}

- (void)didSwitchOut
{
    [_player pause];
}

@end
