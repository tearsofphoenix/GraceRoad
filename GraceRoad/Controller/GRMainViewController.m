//
//  GRMainViewController.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRMainViewController.h"
#import "GRResourceView.h"
#import "GRCommunicationView.h"
#import "GRPreferenceView.h"
#import "GRNavigationBarView.h"
#import "GRIntroductView.h"
#import "GRSermonView.h"
#import "UIView+FirstResponder.h"
#import "GRLoginView.h"
#import "GRDataService.h"

#define GRTabCount 4

@interface GRMainViewController ()<UITabBarDelegate>
{
    NSMutableArray *_viewStacks;
    
    UIView *_modalPresentView;
    UIActivityIndicatorView *_loadingIndicatorView;
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
    
    CGRect bounds = [[self view] bounds];
    
    _navigationBarView = [[GRNavigationBarView alloc] initWithFrame: CGRectMake(0, 0, bounds.size.width, 44)];
    [[self view] addSubview: _navigationBarView];
    
    _tabbar = [[UITabBar alloc] initWithFrame: CGRectMake(0, bounds.size.height - 49, bounds.size.width, 49)];
    
    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle: @"教会简介"
                                                        image: [UIImage imageNamed: @"GRLocationTab"]
                                                          tag: 0];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle: @"资料"
                                                        image: [UIImage imageNamed: @"GRResourceTab"]
                                                          tag: 1];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle: @"讲道"
                                                           image: [UIImage imageNamed: @"GRSermonTab"]
                                                             tag: 2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle: @"设置"
                                                        image: [UIImage imageNamed: @"GRPreferenceTab"]
                                                          tag: 3];
    [_tabbar setItems: @[ item0, item1, item2, item3]];
    [_tabbar setDelegate: self];
    [[self view] addSubview: _tabbar];
    
    [item0 release];
    [item1 release];
    [item2 release];
    [item3 release];
    
    _contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 44, bounds.size.width, bounds.size.height - 44 - 49)];
    [[self view] addSubview: _contentView];
    
    [_tabbar setBackgroundColor: [UIColor colorWithRed:0.31f green:0.32f blue:0.33f alpha:1.00f]];
  
    CGRect contentBounds = [_contentView bounds];
    
    GRIntroductView *introductView = [[GRIntroductView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: introductView]];
    [_contentView addSubview: introductView];
    [introductView release];
    
    GRResourceView *resourceView = [[GRResourceView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: resourceView]];
    [_contentView addSubview: resourceView];
    [resourceView release];
    
    GRSermonView *sermonView = [[GRSermonView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: sermonView]];
    [_contentView addSubview: sermonView];
    [sermonView release];
    
    GRPreferenceView *preferenceView = [[GRPreferenceView alloc] initWithFrame: contentBounds];
    [_viewStacks addObject: [NSMutableArray arrayWithObject: preferenceView]];
    [_contentView addSubview: preferenceView];
    [preferenceView release];
    
    [self setCurrentIndex: 0];
    [_tabbar setSelectedItem: [_tabbar items][0]];
    
    _modalPresentView = [[UIView alloc] initWithFrame: [[self view] bounds]];
    [_modalPresentView setBackgroundColor: [UIColor colorWithRed: 0
                                                           green: 0
                                                            blue: 0
                                                           alpha: 0.7]];
    [_modalPresentView setAlpha: 0];
    
    [[self view] addSubview: _modalPresentView];
    [[self view] bringSubviewToFront: _modalPresentView];
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

- (void)_resetTabbarFrame
{
    CGRect frame = [[self view] bounds];
    CGRect rect = frame;
    rect.size.height = 49;
    rect.origin.y = frame.size.height - rect.size.height;
    
    [_tabbar setFrame: rect];
}

- (void)_toggleHideTabView: (BOOL)flag
{
    if (flag)
    {
        CGRect frame = [[self view] bounds];
        CGRect rect = frame;
        rect.size.height = 49;
        rect.origin.y = frame.size.height + rect.size.height;

        [_tabbar setFrame: rect];

        frame = [_contentView frame];
        frame.size.height = [[self view] bounds].size.height - [_navigationBarView bounds].size.height;
        [_contentView setFrame: frame];
        
    }else
    {
        CGRect frame = [_contentView frame];
        frame.size.height = [[self view] bounds].size.height - [_navigationBarView bounds].size.height - [_tabbar frame].size.height;
        [_contentView setFrame: frame];
        
        [self _resetTabbarFrame];
        //[_tabbar setTransform: CGAffineTransformIdentity];
    }
}

- (void)setCurrentIndex: (NSInteger)currentIndex
{
    if (_currentIndex != currentIndex)
    {
        [self willChangeValueForKey: @"currentIndex"];
        
        if (_currentIndex >=0 && _currentIndex < [_viewStacks count])
        {
            NSArray *oldStack = _viewStacks[_currentIndex];
            [[oldStack lastObject] didSwitchOut];
        }
        
        _currentIndex = currentIndex;
        
        NSArray *viewStack = _viewStacks[_currentIndex];
        GRContentView *view = [viewStack lastObject];
        
        [view willSwitchIn];
        
        [_contentView bringSubviewToFront: view];
        [_navigationBarView setTitle: [view title]];
        
        [UIView animateWithDuration: 0.3
                         animations: (^
                                      {
                                          [self _toggleHideTabView: [view hideTabbar]];
                                          
                                          if ([viewStack count] > 1)
                                          {
                                              [[_navigationBarView leftNavigationButton] setAlpha: 1];
                                          }else
                                          {
                                              [[_navigationBarView leftNavigationButton] setAlpha: 0];
                                          }
                                      })];
        
        [self didChangeValueForKey: @"currentIndex"];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)pushContentView: (GRContentView *)contentView
{
    [[[self view] firstResponder] resignFirstResponder];
    
    if ([contentView conformsToProtocol: @protocol(GRContentView)])
    {
        NSMutableArray *viewStack = _viewStacks[_currentIndex];
        
        GRContentView *currentView = [viewStack lastObject];
        CGRect frame = [_contentView frame];
        
        if ([contentView hideTabbar])
        {
            frame.size.height = [[self view] bounds].size.height - [_navigationBarView bounds].size.height;
        }else
        {
            frame.size.height = [[self view] bounds].size.height - [_navigationBarView bounds].size.height - [_tabbar frame].size.height;
        }
        
        [_contentView setFrame: frame];
        [contentView setFrame: [_contentView bounds]];
        
        [contentView setTransform: CGAffineTransformMakeTranslation(frame.size.width, 0)];
        [contentView setDelegate: _navigationBarView];
        [contentView willSwitchIn];
        
        [viewStack addObject: contentView];
        [_contentView addSubview: contentView];
        
        [self _updateContextForContentView: contentView];
        
        [self _resetTabbarFrame];

        //update navigation button
        //
        [UIView animateWithDuration: 0.3
                         animations: (^
                                      {
                                          [[_navigationBarView leftNavigationButton] setAlpha: 1];
                                          
                                          [contentView setTransform: CGAffineTransformIdentity];
                                          [currentView setTransform: CGAffineTransformMakeTranslation(-frame.size.width, 0)];
                                          
                                          [self _toggleHideTabView: [contentView hideTabbar]];
                                      })
                         completion: (^(BOOL finished)
                                      {
                                          [currentView didSwitchOut];
                                      })];
    }else
    {
        NSLog(@"will fail when try to push invalid content view!");
    }
}

- (void)_updateContextForContentView: (GRContentView *)contentView
{
    [_navigationBarView setTitle: [contentView title]];
    [_contentView bringSubviewToFront: contentView];
    
    UIButton *rightNavigationButton = [contentView rightNavigationButton];
    [_navigationBarView setRightNavigationButton: rightNavigationButton];
}

- (void)popLastContentView
{
    [[[self view] firstResponder] resignFirstResponder];
    
    NSMutableArray *viewStack = _viewStacks[_currentIndex];
    NSUInteger count = [viewStack count];
    
    if (count > 1)
    {
        GRContentView *currentView = [viewStack lastObject];
        [currentView setDelegate: nil];
        
        CGRect frame = [currentView frame];
        
        [viewStack removeLastObject];
        
        GRContentView *newView = [viewStack lastObject];
        
        [newView willSwitchIn];

        [self _updateContextForContentView: newView];
        
        [UIView animateWithDuration: 0.3
                         animations: (^
                                      {
                                          if (count == 2)
                                          {
                                              [[_navigationBarView leftNavigationButton] setAlpha: 0];
                                          }
                                          
                                          [newView setTransform: CGAffineTransformIdentity];
                                          [currentView setTransform: CGAffineTransformMakeTranslation(frame.size.width, 0)];
                                          
                                          [self _toggleHideTabView: [newView hideTabbar]];
                                      })
                         completion: (^(BOOL finished)
                                      {
                                          [currentView didSwitchOut];
                                          [currentView removeFromSuperview];
                                      })];
    }
}

- (void)showLoadingIndicator
{
    if (!_loadingIndicatorView)
    {
        _loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [_modalPresentView addSubview: _loadingIndicatorView];
    }
    
    CGRect bounds = [_modalPresentView bounds];
    CGRect frame = [_loadingIndicatorView frame];
    
    frame.origin.x = (bounds.size.width - frame.size.width) / 2;
    frame.origin.y = (bounds.size.height - frame.size.height) / 2;
    
    [_loadingIndicatorView setFrame: frame];
    
    [_modalPresentView bringSubviewToFront: _loadingIndicatorView];
    [_loadingIndicatorView startAnimating];
    
    [UIView animateWithDuration: 0.3
                     animations: (^
                                  {
                                      [_modalPresentView setAlpha: 1];
                                  })];
}

- (void)hideLoadingIndicator
{
    [_loadingIndicatorView stopAnimating];
    
    [UIView animateWithDuration: 0.3
                     animations: (^
                                  {
                                      [_modalPresentView setAlpha: 0];
                                  })];
    
}

@end
