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

#import <MediaPlayer/MediaPlayer.h>

@interface GRSermonContentView ()
{
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
        //[self setBackgroundColor: [UIColor colorWithRed:0.49f green:0.74f blue:0.99f alpha:1.00f]];
        //[self setBackgroundColor: [UIColor colorWithRed:0.70f green:0.64f blue:0.64f alpha:1.00f]];
        [self setBackgroundColor: [UIColor colorWithRed:0.95f green:0.95f blue:0.96f alpha:1.00f]];
        
        //[self setBackgroundColor: [UIColor whiteColor]];
        
        CGRect rect = CGRectMake(4, 4, 100, 100);
        _imageView = [[UIImageView alloc] initWithFrame: rect];
        [_imageView setImage: [UIImage imageNamed: @"GRHeart.jpg"]];
        
        [self addSubview: _imageView];
        
        _contentTextView = [[UITextView alloc] initWithFrame: CGRectMake(rect.origin.x + rect.size.width,
                                                                         rect.origin.y,
                                                                         frame.size.width - rect.size.width,
                                                                         100)];
        [_contentTextView setBackgroundColor: [UIColor clearColor]];
        [_contentTextView setEditable: NO];
        
        [self addSubview: _contentTextView];
        
        _player = [[MPMoviePlayerController alloc] init];
        [self addSubview: [_player view]];
        
        [[_player view] setFrame: CGRectMake(0, rect.origin.y + rect.size.height + 4, frame.size.width, 40)];
    }
    return self;
}

- (void)dealloc
{
    [_imageView release];
    [_contentTextView release];
    [_player release];
    [_sermonInfo release];
    
    [super dealloc];
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
