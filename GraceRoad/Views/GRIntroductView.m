//
//  GRIntroductView.m
//  GraceRoad
//
//  Created by Lei on 13-12-29.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRIntroductView.h"
#import "GRMapAnnotation.h"
#import "Reachability.h"
#import <MapKit/MapKit.h>

@interface GRIntroductView ()
{
    UIScrollView *_scrollView;
    
    UIImageView *_placeHolderImageView;
    MKMapView *_mapView;
    GRMapAnnotation *_annotation;
}
@end

@implementation GRIntroductView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"简介"];
        
        CGRect bounds = [self bounds];
        
        _scrollView = [[UIScrollView alloc] initWithFrame: bounds];
        [self addSubview: _scrollView];
        
        [_scrollView setBackgroundColor: [UIColor colorWithRed: 0.93f
                                                         green: 0.95f
                                                          blue: 0.96f
                                                         alpha: 1.00f]];
        
        CGRect rect = CGRectMake(0, 20, frame.size.width, 44);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: rect];
        [titleLabel setTextAlignment: NSTextAlignmentCenter];
        [titleLabel setText: @"新松江恩典教会"];
        [titleLabel setFont: [UIFont boldSystemFontOfSize: 30]];
        
        [_scrollView addSubview: titleLabel];
        [titleLabel release];
        
        rect.origin.x = 10;
        rect.size.width -= rect.origin.x * 2;
        rect.origin.y += rect.size.height;
        rect.size.height = 270;
        
        UITextView *contentView = [[UITextView alloc] initWithFrame: rect];
        
        //[contentView setScrollEnabled: NO];
        [contentView setBackgroundColor: [UIColor clearColor]];
        [contentView setFont: [UIFont systemFontOfSize: 16]];
        [contentView setTextAlignment: NSTextAlignmentLeft];
        [contentView setEditable: NO];
        
        [contentView setText: (@"      以马内利！新松江恩典教会欢迎您！\n"
                               "进入会堂请把手机关机或者静音。\n"
                               "      感谢神把您带到我们当中，在基督里我们是一家人，"
                               "愿在以后的生活里我们共同学习神的话语。耶稣爱你！\n"
                               "      以下是我们教会的常规事项，请仔细阅读。\n"
                               "周日礼拜时间：\n"
                               "            第一场 07:30-08:30\n"
                               "            第二场 09:00-0:30\n"
                               "            第三场 13:30-15:00\n"
                               "成人主日学： 11:00-12:00\n"
                               "")];
        [_scrollView addSubview: contentView];
        [contentView release];
        
        rect.origin.y += rect.size.height;
        rect.size.height = 130;
        
        _placeHolderImageView = [[UIImageView alloc] initWithFrame: rect];
        [_placeHolderImageView setAlpha: 0];
        
        [_scrollView addSubview: _placeHolderImageView];
        
        _mapView = [[MKMapView alloc] initWithFrame: rect];
        [self _updateMapViewIfNeeded];
        [_scrollView addSubview: _mapView];
        
        [_scrollView setContentSize: CGSizeMake(bounds.size.width, rect.origin.y + rect.size.height)];
        
        [[Reachability reachabilityForInternetConnection] startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForNetworkUpdated:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
    }
    return self;
}

- (void)dealloc
{
    [[Reachability reachabilityForInternetConnection] stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_scrollView release];
    [_mapView release];
    [_annotation release];
    [_placeHolderImageView release];
    
    [super dealloc];
}

- (void)_updateMapForChurchLocation
{
    [_placeHolderImageView setAlpha: 0];
    [_mapView setAlpha: 1];
    
    [_mapView removeAnnotation: _annotation];
    
    if (!_annotation)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(31.039477, 121.234174);
        MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(coordinate, 1500.0, 1500.0);
        [_mapView setRegion: userLocation
                   animated: YES];
        
        _annotation = [[GRMapAnnotation alloc] init];
        
        [_annotation setCoordinate: coordinate];
        [_annotation setTitle: @"新松江恩典教会"];
    }
    
    [_mapView addAnnotation: _annotation];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    [_scrollView setFrame: [self bounds]];
}

- (void)_updateMapViewIfNeeded
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
    {
        [self _updateMapForChurchLocation];
    }else
    {
        [_placeHolderImageView setAlpha: 1];
        [_mapView setAlpha: 0];
    }
}

- (void)_notificationForNetworkUpdated: (NSNotification *)notification
{
    [self _updateMapViewIfNeeded];
}

@end
