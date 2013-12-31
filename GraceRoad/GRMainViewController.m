//
//  GRMainViewController.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRMainViewController.h"
#import "GRServeView.h"
#import "GRResourceView.h"
#import "GRCommunicationView.h"
#import "GRPreferenceView.h"
#import "GRNavigationBarView.h"
#import "GRIntroductView.h"

#define GRTabCount 4

@interface GRMainViewController ()<UITabBarDelegate>
{
    NSMutableArray *_viewStacks;
}

@property (retain, nonatomic) IBOutlet UITabBar *tabbar;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet GRNavigationBarView *navigationBarView;

@end

@implementation GRMainViewController

- (id)initWithNibName: (NSString *)nibNameOrNil
               bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self)
    {
        _viewStacks = [[NSMutableArray alloc] initWithCapacity: GRTabCount];
        _currentIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect contentBounds = [_contentView bounds];
    
    GRIntroductView *introductView = [[GRIntroductView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: introductView]];
    [_contentView addSubview: introductView];
    [introductView release];
    
    GRResourceView *resourceView = [[GRResourceView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: resourceView]];
    [_contentView addSubview: resourceView];
    [resourceView release];
    
    GRServeView *serveView = [[GRServeView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: serveView]];
    [_contentView addSubview: serveView];
    [serveView release];
    
    GRPreferenceView *preferenceView = [[GRPreferenceView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: preferenceView]];
    [_contentView addSubview: preferenceView];
    [preferenceView release];
    
    [self setCurrentIndex: 0];
    [_tabbar setSelectedItem: [_tabbar items][0]];
}


- (void)dealloc
{
    [_viewStacks release];
    [_contentView release];

    [_navigationBarView release];
    [_tabbar release];
    [super dealloc];
}

#pragma mark - UITabBarDelegate

- (void)tabBar: (UITabBar *)tabBar
 didSelectItem: (UITabBarItem *)item
{
    NSUInteger index = [[tabBar items] indexOfObject: item];
    
    if (index < [_viewStacks count])
    {
        [self setCurrentIndex: index];
    }
}

- (void)setCurrentIndex: (NSInteger)currentIndex
{
    if (_currentIndex != currentIndex)
    {
        [self willChangeValueForKey: @"currentIndex"];
        
        _currentIndex = currentIndex;
        
        UIView<GRContentView> *view = [_viewStacks[_currentIndex] lastObject];
        
        [_contentView bringSubviewToFront: view];
        [_navigationBarView setTitle: [view title]];
        
        [self didChangeValueForKey: @"currentIndex"];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)pushContentView: (UIView<GRContentView> *)contentView
{
    
}

- (void)popLastContentView
{
    
}

@end
