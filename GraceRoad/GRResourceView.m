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

@interface GRResourceView ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *_resourceCategories;
    NSMutableDictionary *_resources;
    
    NSMutableArray *_originCategories;
    NSMutableDictionary *_originResources;
    
    UITableView *_contentView;
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
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, 44);
        
        [self setBackgroundColor: [UIColor greenColor]];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: rect];
        [searchBar setDelegate: self];
        [self addSubview: searchBar];
        [searchBar release];
        
        rect.origin.y += rect.size.height;
        rect.size.height = frame.size.height - rect.size.height;
        
        _contentView = [[UITableView alloc] initWithFrame: rect];
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
        
        [self addSubview: _contentView];
        [self _updateContent];
    }
    return self;
}

- (void)dealloc
{
    [_resourceCategories release];
    [_resources release];
    [_contentView release];
    
    [super dealloc];
}

- (NSString *)title
{
    return @"资料";
}

#pragma mark - search bar delegate

- (void)searchBar: (UISearchBar *)searchBar
    textDidChange: (NSString *)searchText
{
    [self setFilterString: searchText];
}

- (void)searchBarSearchButtonClicked: (UISearchBar *)searchBar
{
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

- (void)_updateContent
{
    [_resourceCategories removeAllObjects];
    [_resources removeAllObjects];
    
//    if ([_filterString length] == 0)
//    {
        [_resourceCategories setArray: _originCategories];
        [_resources setDictionary: _originResources];
//    }else
//    {
//        
//    }
    [_contentView reloadData];
}

#pragma mark - tableview datasource & delegate

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return [_resourceCategories count];
}

- (NSString *)tableView: (UITableView *)tableView
titleForHeaderInSection: (NSInteger)section
{
    NSDictionary *resourceTypeInfo = _resourceCategories[section];
    
    return resourceTypeInfo[GRResourceCategoryName];
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
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSDictionary *resourceType = _resourceCategories[section];
    NSArray *resources = _resources[resourceType[GRResourceCategoryID]];
    
    NSDictionary *resourceInfo = resources[row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setText: resourceInfo[GRResourceName]];
    
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

- (void)tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    
}

@end
