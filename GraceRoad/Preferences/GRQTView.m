//
//  GRQTView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-24.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRQTView.h"
#import "GRDataService.h"

@interface GRQTView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *qtListView;
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
        
        _qtListView = [[UITableView alloc] initWithFrame: [self bounds]];
        [_qtListView setDataSource: self];
        [_qtListView setDelegate: self];
        
        [_contents setArray: ERSSC(GRDataServiceID,
                                   GRDataServiceFetchQTDataAction,
                                   nil)];
        [_qtListView reloadData];
    }
    return self;
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
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setText: info[@"title"]];
    
    return [cell autorelease];
}



@end
