//
//  GRQTView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-24.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRQTView.h"
#import "GRDataService.h"
#import "UIRefreshControl+GRExtensions.h"
#import "GRViewService.h"
#import "GRNetWorkService.h"
#import "GRQTInfoView.h"

@interface GRQTView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableViewController *contentViewController;
@property (nonatomic, strong) NSMutableArray *contents;

@end

@implementation GRQTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitle: @"每日灵修"];
        [self setHideTabbar: YES];
        
        _contents = [[NSMutableArray alloc] init];
        
        _contentViewController = [[UITableViewController alloc] init];
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 20)];
        
        [refreshControl setTitle: @"下拉刷新"];
        
        [refreshControl addTarget: self
                           action: @selector(_handleRefreshEvent:)
                 forControlEvents: UIControlEventValueChanged];
        [_contentViewController setRefreshControl: refreshControl];
        [refreshControl release];
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        //_contentView = [[UITableView alloc] initWithFrame: rect];
        UITableView *contentView = [_contentViewController tableView];
        [contentView setFrame: rect];
        [contentView setDataSource: self];
        [contentView setDelegate: self];
        
        [self addSubview: contentView];
        
        [self _reloadData];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForQTSynchronize:)
                                                     name: GRNotificationQTSynchronizeFinished
                                                   object: nil];
    }
    return self;
}

- (void)_handleRefreshEvent: (id)sender
{
    UIRefreshControl *refreshControl = [_contentViewController refreshControl];
    [refreshControl setTitle: @"刷新中..."];
    
    ERSC(GRViewServiceID, GRViewServiceShowLoadingIndicatorAction, nil, nil);
    
    ERServiceCallback callback = (^(id result, id exception)
                                  {
                                      [refreshControl endRefreshing];
                                      [refreshControl setTitle: @"下拉刷新"];
                                      
                                      ERSC(GRViewServiceID, GRViewServiceHideLoadingIndicatorAction, nil, nil);
                                      
                                      [self _reloadData];
                                  });
    
    callback = Block_copy(callback);
    
    ERSC(GRDataServiceID, GRDataServiceRefreshQTDataAction, @[ callback ], nil);
    
    Block_release(callback);
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return [_contents count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSDictionary *info = _contents[[indexPath row]];
    NSString *title = info[@"title"];
    //2014-03-24 18:58:03
    NSString *date = info[GRNetworkLastUpdateKey];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setFont: [UIFont systemFontOfSize: 16]];
    [[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
    [[cell textLabel] setText: [NSString stringWithFormat: @"%@ %@", [date substringWithRange: NSMakeRange(5, 5)], title]];
    
    return [cell autorelease];
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSDictionary *info = _contents[[indexPath row]];

    
    GRQTInfoView *contentView = [[GRQTInfoView alloc] initWithFrame: [self frame]];
    
    [contentView setQTInfo: info];
    
    ERSC(GRViewServiceID,
         GRViewServicePushContentViewAction,
         @[ contentView ], nil);
    
    [contentView release];

}


- (void)_reloadData
{
    [_contents setArray: ERSSC(GRDataServiceID,
                               GRDataServiceFetchQTDataAction,
                               nil)];
    
    [[_contentViewController tableView] reloadData];
}

- (void)_notificationForQTSynchronize: (NSNotification *)notification
{
    [self _reloadData];
}

@end
