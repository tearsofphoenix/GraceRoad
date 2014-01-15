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
    NSMutableArray *_sermons;
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
        
        _sermons = [[NSMutableArray alloc] init];
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _contentView = [[UITableView alloc] initWithFrame: rect];
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
        
        [self addSubview: _contentView];
        
        [_sermons setArray: ERSSC(GRDataServiceID,
                                  GRDataServiceAllSermonsAction,
                                  nil)];
        [_contentView reloadData];
    }
    return self;
}

- (void)dealloc
{
    [_contentView release];
    [_sermons release];
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return [_sermons count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSDictionary *sermonInfo = _sermons[[indexPath row]];
    
    [[cell textLabel] setText: sermonInfo[GRSermonTitle]];
    [[cell imageView] setImage: [UIImage imageNamed: @"GRAudio"]];
    
    return [cell autorelease];
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
    NSDictionary *sermonInfo = _sermons[[indexPath row]];
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

@end
