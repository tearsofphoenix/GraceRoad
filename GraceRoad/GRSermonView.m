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

- (NSString *)title
{
    return @"每周讲道";
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
    
    return [cell autorelease];
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    
}

@end
