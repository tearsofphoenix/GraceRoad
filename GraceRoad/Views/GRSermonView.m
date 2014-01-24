//
//  GRSermonView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-2.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRSermonView.h"
#import "GRSermonKeys.h"
#import "GRDataService.h"
#import "GRViewService.h"
#import "GRResourceManager.h"
#import "GRSermonContentView.h"
#import "GRUIExtensions.h"
#import "GRTheme.h"
#import "GRResourceKey.h"
#import "GRResourceCell.h"

@interface GRSermonView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_sermonCategories;
    NSMutableDictionary *_sermons;
    UITableViewController *_contentViewController;
}
@end

@implementation GRSermonView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"每周讲道"];
        
        _sermonCategories = [[NSMutableArray alloc] init];
        _sermons = [[NSMutableDictionary alloc] init];
        
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
        
        [_sermonCategories setArray: ERSSC(GRDataServiceID,
                                           GRDataServiceAllSermonCategoriesAction, nil)];
        
        [_sermons setDictionary: ERSSC(GRDataServiceID,
                                       GRDataServiceAllSermonsAction,
                                       nil)];
        [contentView reloadData];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForSermonSynchronize:)
                                                     name: GRNotificationSermonSynchronizeFinished
                                                   object: nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_contentViewController release];
    [_sermonCategories release];
    [_sermons release];
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return [_sermonCategories count];
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    NSDictionary *sermonCategory = _sermonCategories[section];
    NSArray *sermons = _sermons[sermonCategory[GRSermonCategoryID]];
    
    return [sermons count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *sermonCategory = _sermonCategories[section];
    NSArray *sermons = _sermons[sermonCategory[GRSermonCategoryID]];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSDictionary *sermonInfo = sermons[row];
    
    [[cell textLabel] setText: sermonInfo[GRSermonTitle]];
    [[cell imageView] setImage: [GRResourceManager imageForFileType: GRResourceTypeWAVE]];
    
    return [cell autorelease];
}

- (UIView *) tableView: (UITableView *)tableView
viewForHeaderInSection: (NSInteger)section
{
    UILabel *headerLabel = [GRTheme newheaderLabel];
    
    NSDictionary *sermonCategory = _sermonCategories[section];
    
    [headerLabel setText: [@"    " stringByAppendingString: sermonCategory[GRSermonCategoryNameKey]]];
    
    return headerLabel;
}


- (void)_showSermonContentWithInfo: (NSDictionary *)info
{
    GRSermonContentView *contentView = [[GRSermonContentView alloc] initWithFrame: [self frame]];
    
    [contentView setSermonInfo: info];
    
    ERSC(GRViewServiceID,
         GRViewServicePushContentViewAction,
         @[ contentView ], nil);
    
    [contentView release];
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *sermonCategory = _sermonCategories[section];
    NSArray *sermons = _sermons[sermonCategory[GRSermonCategoryID]];
    
    NSDictionary *sermonInfo = sermons[row];
    
    NSString *subPath = sermonInfo[GRSermonAudioPath];
    if ([GRResourceManager fileExistsWithSubPath: subPath])
    {
        [self _showSermonContentWithInfo: sermonInfo];
    }else
    {
        [[UIAlertView alertWithTitle: @"提示"
                             message: @"您确定要下载该文档吗？"
                   cancelButtonTitle: @"取消"
                   otherButtonTitles: @[ @"确定" ]
                            callback:
          (^(NSInteger buttonIndex)
           {
               if (1 == buttonIndex)
               {
                   ERSC(GRViewServiceID,
                        GRViewServiceShowLoadingIndicatorAction,
                        nil, nil);
                   
                   [GRResourceManager downloadFileWithSubPath: subPath
                                                     callback:
                    (^(NSData *data, NSError *error)
                     {
                         ERSC(GRViewServiceID,
                              GRViewServiceHideLoadingIndicatorAction,
                              nil, nil);
                         
                         [self _showSermonContentWithInfo: sermonInfo];
                     })];
               }
           })] show];
        
    }
}

- (CGFloat)    tableView: (UITableView *)tableView
heightForHeaderInSection: (NSInteger)section
{
    return 30;
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
}

- (void)_handleRefreshEvent: (id)sender
{
    UIRefreshControl *refreshControl = [_contentViewController refreshControl];
    [refreshControl setTitle: @"刷新中..."];
    
    ERSC(GRViewServiceID, GRViewServiceShowLoadingIndicatorAction, nil, nil);

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),
                   (^(void)
                    {
                        [refreshControl endRefreshing];
                        [refreshControl setTitle: @"下拉刷新"];
                        
                        ERSC(GRViewServiceID, GRViewServiceHideLoadingIndicatorAction, nil, nil);
                    }));
}

- (void)_notificationForSermonSynchronize: (NSNotification *)notification
{
    [_sermonCategories setArray: ERSSC(GRDataServiceID,
                                       GRDataServiceAllSermonCategoriesAction, nil)];
    
    [_sermons setDictionary: ERSSC(GRDataServiceID,
                                   GRDataServiceAllSermonsAction,
                                   nil)];
    
    [[_contentViewController tableView] reloadData];
}

@end
