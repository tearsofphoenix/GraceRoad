//
//  GRPrayView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-6.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRPrayView.h"
#import "GRDataService.h"
#import "GRPrayKeys.h"
#import "UIAlertView+BlockSupport.h"
#import "UIRefreshControl+GRExtensions.h"
#import "GRViewService.h"

@interface GRPrayView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_praySources;
    UITableViewController *_prayListViewController;
    UIButton *_rightNavigationButton;
}
@end

@implementation GRPrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitle: @"代祷"];
        [self setHideTabbar: YES];
        
        _praySources = [[NSMutableArray alloc] init];
        
        _prayListViewController = [[UITableViewController alloc] init];
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 20)];
        
        [refreshControl setTitle: @"下拉刷新"];
        
        [refreshControl addTarget: self
                           action: @selector(_handleRefreshEvent:)
                 forControlEvents: UIControlEventValueChanged];
        [_prayListViewController setRefreshControl: refreshControl];
        [refreshControl release];

        UITableView *prayListView = [_prayListViewController tableView];
        
        [prayListView setFrame: [self bounds]];
        [prayListView setDataSource: self];
        [prayListView setDelegate: self];
        [prayListView setBackgroundColor: [UIColor clearColor]];
        
        [self addSubview: prayListView];
        
        _rightNavigationButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
        [_rightNavigationButton setImage: [UIImage imageNamed: @"GRAddButton"]
                                forState: UIControlStateNormal];
        [_rightNavigationButton setImageEdgeInsets: UIEdgeInsetsMake(8, 8, 8, 8)];

        [_rightNavigationButton addTarget: self
                                   action: @selector(_handleAddPrayButtonTappedEvent:)
                         forControlEvents: UIControlEventTouchUpInside];
        
        [self _reloadData];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForPraySynchronized:)
                                                     name: GRNotificationPraySynchronizeFinished
                                                   object: nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_praySources release];
    [_prayListViewController release];
    
    [_rightNavigationButton release];
    
    [super dealloc];
}

- (UIButton *)rightNavigationButton
{
    return _rightNavigationButton;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return [_praySources count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSDictionary *prayInfo = _praySources[[indexPath row]];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setText: prayInfo[GRPrayTitleKey]];
    
    return [cell autorelease];
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 60;
}

- (void)_handleAddPrayButtonTappedEvent: (id)sender
{
    UIAlertView *alertView = [UIAlertView alertWithTitle: @"请输入代祷内容："
                                                 message: nil
                                       cancelButtonTitle: @"取消"
                                       otherButtonTitles: @[@"确定"]
                                                callback: nil];
    
    [alertView setAlertViewStyle: UIAlertViewStylePlainTextInput];
    
    [alertView setCallback: (^(NSInteger buttonIndex)
                             {
                                 NSString *text = [[alertView textFieldAtIndex: 0] text];
                                 if ([text length] > 0)
                                 {
                                     NSDictionary *prayInfo = (@{
                                                                 @"uuid" : [[NSUUID UUID] UUIDString],
                                                                 @"device_id" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                                                 GRPrayTitleKey : text,
                                                                 GRPrayUploadDateKey : [NSDate date],
                                                                 });

                                     [_praySources insertObject: prayInfo
                                                        atIndex: 0];
                                     
                                     [[_prayListViewController tableView] reloadData];
                                     
                                     ERSC(GRDataServiceID, GRDataServiceAddPrayAction, @[ prayInfo ], nil);
                                 }
                             })];
    [alertView show];
}

- (void)_reloadData
{
    [_praySources setArray: ERSSC(GRDataServiceID,
                                  GRDataServiceAllPrayListAction,
                                  nil)];
    
    [[_prayListViewController tableView] reloadData];
}

- (void)_handleRefreshEvent: (id)sender
{
    UIRefreshControl *refreshControl = [_prayListViewController refreshControl];
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
    
    ERSC(GRDataServiceID, GRDataServiceRefreshPrayWithCallbackAction, @[ callback ], nil);
    
    Block_release(callback);
}

- (void)_notificationForPraySynchronized: (NSNotification *)notification
{
    [self _reloadData];
}

@end

