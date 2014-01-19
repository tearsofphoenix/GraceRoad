//
//  GRResourceView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceView.h"
#import "GRResourceKey.h"
#import "GRDataService.h"
#import "GRResourceManager.h"
#import "GRResourceInfoView.h"
#import "GRViewService.h"
#import "GRUIExtensions.h"
#import "GRTheme.h"

@interface GRResourceView ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *_resourceCategories;
    NSMutableDictionary *_resources;
    
    NSMutableArray *_originCategories;
    NSMutableDictionary *_originResources;

    UITableViewController *_contentViewController;
}

@property(nonatomic, retain) NSString *filterString;

@end

@implementation GRResourceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _resourceCategories = [[NSMutableArray alloc] init];
        _resources = [[NSMutableDictionary alloc] init];
        
        _originCategories = [[NSMutableArray alloc] init];
        _originResources = [[NSMutableDictionary alloc] init];
        
        [_originCategories setArray: ERSSC(GRDataServiceID,
                                           GRDataServiceAllResourceCategoriesAction,
                                           nil)];
        [_originResources setDictionary: ERSSC(GRDataServiceID,
                                               GRDataServiceAllResourcesAction,
                                               nil)];
        
        [self setTitle: @"资料"];
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, 44);
        
        [self setBackgroundColor: [UIColor greenColor]];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: rect];
        [searchBar setDelegate: self];
        [self addSubview: searchBar];
        [searchBar release];
        
        rect.origin.y += rect.size.height;
        rect.size.height = frame.size.height - rect.size.height;
        
        _contentViewController = [[UITableViewController alloc] init];
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 20)];
        
        [refreshControl setTitle: @"下拉刷新"];
        
        [refreshControl addTarget: self
                           action: @selector(_handleRefreshEvent:)
                 forControlEvents: UIControlEventValueChanged];
        [_contentViewController setRefreshControl: refreshControl];
        [refreshControl release];

        UITableView *contentView = [_contentViewController tableView];
        [contentView setFrame: rect];
        [contentView setDataSource: self];
        [contentView setDelegate: self];
        
        [self addSubview: contentView];
                
        [self _updateContent];
    }
    return self;
}

- (void)dealloc
{
    [_resourceCategories release];
    [_resources release];
    [_contentViewController release];
    
    [super dealloc];
}

#pragma mark - search bar delegate

- (void)searchBar: (UISearchBar *)searchBar
    textDidChange: (NSString *)searchText
{
    [self setFilterString: searchText];
}

- (void)searchBarSearchButtonClicked: (UISearchBar *)searchBar
{
    [[self firstResponder] resignFirstResponder];
    [self setFilterString: [searchBar text]];
}

- (void)setFilterString: (NSString *)filterString
{
    if (![_filterString isEqualToString: filterString])
    {
        id oldValue = _filterString;
        [self willChangeValueForKey: @"filterString"];
        
        _filterString = [filterString retain];
        [oldValue release];
        [self _updateContent];
        
        [self didChangeValueForKey: @"filterString"];
    }
}

- (NSDictionary *)_resourceCategoryByID: (NSString *)categoryID
{
    for (NSDictionary *cLooper in _originCategories)
    {
        if ([cLooper[GRResourceCategoryID] isEqualToString: categoryID])
        {
            return cLooper;
        }
    }
    
    return nil;
}

- (void)_updateContent
{
    [_resourceCategories removeAllObjects];
    [_resources removeAllObjects];
    
    if ([_filterString length] == 0)
    {
        [_resourceCategories setArray: _originCategories];
        [_resources setDictionary: _originResources];
    }else
    {
        [_originResources enumerateKeysAndObjectsUsingBlock:
         (^(NSString *resourceID, NSArray *obj, BOOL *stop)
          {
              for (NSDictionary *rLooper in obj)
              {
                  if ([rLooper[GRResourceName] rangeOfString: _filterString
                                                     options: NSCaseInsensitiveSearch].location != NSNotFound)
                  {
                      NSMutableArray *resources = _resources[resourceID];
                      if (!resources)
                      {
                          //add category
                          //
                          [_resourceCategories addObject: [self _resourceCategoryByID: resourceID]];
                          
                          //prepare array
                          //
                          resources = [NSMutableArray array];
                          [_resources setObject: resources
                                         forKey: resourceID];
                      }
                      
                      [resources addObject: rLooper];
                  }
              }
          })];
    }
    
    [[_contentViewController tableView] reloadData];
}

#pragma mark - tableview datasource & delegate

- (NSDictionary *)_resourceAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *resourceType = _resourceCategories[section];
    NSArray *resources = _resources[resourceType[GRResourceCategoryID]];
    
    return resources[row];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return [_resourceCategories count];
}

- (UIView *) tableView: (UITableView *)tableView
viewForHeaderInSection: (NSInteger)section
{
    UILabel *headerLabel = [GRTheme newheaderLabel];
    
    NSDictionary *resourceTypeInfo = _resourceCategories[section];
    
    [headerLabel setText: [@"    " stringByAppendingString: resourceTypeInfo[GRResourceCategoryName]]];
    
    return headerLabel;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    NSDictionary *resourceTypeInfo = _resourceCategories[section];
    NSArray *resources = _resources[resourceTypeInfo[GRResourceCategoryID]];
    return [resources count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSDictionary *resourceInfo = [self _resourceAtIndexPath: indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setText: resourceInfo[GRResourceName]];
    
    [[cell imageView] setImage: [GRResourceManager imageForFileType: resourceInfo[GRResourceTypeName]]];
    
    return [cell autorelease];
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

- (void)_navigateToResourceContentWithInfo: (NSDictionary *)info
{
    GRResourceInfoView *infoView = [[GRResourceInfoView alloc] initWithFrame: [self bounds]];
    [infoView setResourceInfo: info];
    
    ERSC(GRViewServiceID,
         GRViewServicePushContentViewAction,
         @[ infoView ], nil);
    
    [infoView release];
}

- (void)tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [[self firstResponder] resignFirstResponder];
    
    NSDictionary *resourceInfo = [self _resourceAtIndexPath: indexPath];
    NSString *subPath = resourceInfo[GRResourcePath];
    
    if ([GRResourceManager fileExistsWithSubPath: subPath])
    {
        [self _navigateToResourceContentWithInfo: resourceInfo];
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
                         
                         [self _navigateToResourceContentWithInfo: resourceInfo];
                     })];
               }
           })] show];
    }
}

- (void)searchBarTextDidBeginEditing: (UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton: YES
                           animated: YES];
}

- (void)searchBarCancelButtonClicked: (UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton: NO
                           animated: YES];
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

@end
