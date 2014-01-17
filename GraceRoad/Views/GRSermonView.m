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
#import "UIAlertView+BlockSupport.h"

@interface GRSermonView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_sermonCategories;
    NSMutableDictionary *_sermons;
    UITableView *_contentView;
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
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _contentView = [[UITableView alloc] initWithFrame: rect];
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
        
        [self addSubview: _contentView];
        
        [_sermonCategories setArray: ERSSC(GRDataServiceID,
                                           GRDataServiceAllSermonCategoriesAction, nil)];
        [_sermons setDictionary: ERSSC(GRDataServiceID,
                                       GRDataServiceAllSermonsAction,
                                       nil)];
        [_contentView reloadData];
    }
    return self;
}

- (void)dealloc
{
    [_contentView release];
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
    [[cell imageView] setImage: [UIImage imageNamed: @"GRAudio"]];
    
    return [cell autorelease];
}

- (UIView *) tableView: (UITableView *)tableView
viewForHeaderInSection: (NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
    
    NSDictionary *sermonCategory = _sermonCategories[section];
    
    //[headerLabel setBackgroundColor: [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha: 1.0f]];
    [headerLabel setBackgroundColor: [UIColor colorWithRed: 83 / 255.0
                                                     green: 152 / 255.0
                                                      blue: 253 / 255.0
                                                     alpha: 0.8]];
    
    //[headerLabel setTextColor: [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f]];
    [headerLabel setTextColor: [UIColor whiteColor]];
    [headerLabel setText: [@"    " stringByAppendingString: sermonCategory[GRSermonCategoryTitle]]];
    
    return [headerLabel autorelease];
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
                                    
    NSString *subPath = sermonInfo[GRSermonPath];
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

@end
