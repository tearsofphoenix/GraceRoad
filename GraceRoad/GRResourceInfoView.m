//
//  GRResourceInfoView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceInfoView.h"
#import "GRResourceKey.h"
#import "GRResourceManager.h"

@interface GRResourceInfoView ()
{
    UIWebView *_webView;
}
@end

@implementation GRResourceInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHideTabbar: YES];
        [self setBackgroundColor: [UIColor whiteColor]];
        
        _webView = [[UIWebView alloc] initWithFrame: [self bounds]];
        [self addSubview: _webView];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"in func: %s", __func__);
    
    [_resourceInfo release];
    [_webView release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    [_webView setFrame: [self bounds]];
}

- (void)setResourceInfo: (NSDictionary *)resourceInfo
{
    if (_resourceInfo != resourceInfo)
    {
        [_resourceInfo release];
        _resourceInfo = [resourceInfo retain];

        [self setTitle: _resourceInfo[GRResourceName]];
        
        NSString *path = [GRResourceManager pathWithSubPath: _resourceInfo[GRResourcePath]];
        
        [_webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: path]]];
    }
}

@end
