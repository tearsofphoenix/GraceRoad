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
#import "GRNibPackage.h"
#import "GRViewService.h"
#import "GRHTMLPackage.h"
#import "GRDataService.h"

@interface GRResourceInfoView ()
{
    id<GRPackage> _package;
}

@property (nonatomic, retain) UIButton *rightNavigationButton;
@property (nonatomic, retain) UIView *packageView;

@end

@implementation GRResourceInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHideTabbar: YES];
        [self setBackgroundColor: [UIColor whiteColor]];
        
        _rightNavigationButton = [[UIButton alloc] init];
        [[_rightNavigationButton titleLabel] setFont: [UIFont systemFontOfSize: 14]];
        [_rightNavigationButton setTitle: @"完成"
                                forState: UIControlStateNormal];
        [_rightNavigationButton addTarget: self
                                   action: @selector(_handleDoneButtonTappedEvent:)
                         forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"in func: %s", __func__);
    
    [_rightNavigationButton release];
    [_resourceInfo release];
    [_packageView release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    [_packageView setFrame: [self bounds]];
}

- (void)setPackageView: (UIView *)packageView
{
    if (_packageView != packageView)
    {
        [_packageView release];
        [_packageView removeFromSuperview];
        
        _packageView = [packageView retain];
        
        [self addSubview: _packageView];
        
        [_packageView setFrame: [self bounds]];
    }
}

- (void)setResourceInfo: (NSDictionary *)resourceInfo
{
    if (_resourceInfo != resourceInfo)
    {
        [_resourceInfo release];
        _resourceInfo = [resourceInfo retain];

        [self setTitle: _resourceInfo[GRResourceName]];
        
//        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: _resourceInfo[GRResourcePath]];
//        
//        GRPackage *package = [[GRPackage alloc] initWithPath: path];
//        
//        [self addSubview: [package view]];
        
        NSString *path = [GRResourceManager pathWithSubPath: _resourceInfo[GRResourcePath]];
        
        _package = [[GRHTMLPackage alloc] initWithPath: path];
        
        NSDictionary *savedContext = ERSSC(GRDataServiceID, GRDataServiceLessonRecordForIDAction, @[ _resourceInfo[GRResourceID] ]);
        if (savedContext)
        {
            [_package updateWithRecord: savedContext];
        }
        
        [self setPackageView: [_package view]];
    }
}

- (void)_handleDoneButtonTappedEvent: (id)sender
{
    NSDictionary *lessonContext = [_package savedContext];
    
    NSLog(@"result: %@", lessonContext);
    
    ERSC(GRDataServiceID,
         GRDataServiceSaveLessonForIDAction,
         @[lessonContext, _resourceInfo[GRResourceID] ], nil);
           
    ERSC(GRViewServiceID, GRViewServicePopContentViewAction, nil, nil);
}

@end
