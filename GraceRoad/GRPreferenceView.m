//
//  GRPreferenceView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRPreferenceView.h"
#import "GRLoginView.h"
#import "GRViewService.h"

@interface GRPreferenceView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titles;
}
@end

@implementation GRPreferenceView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"设置"];
        
        _titles = [@[ @"我的信息"] retain];

        _tableView = [[UITableView alloc] initWithFrame: [self bounds]];
        [_tableView setDataSource: self];
        [_tableView setDelegate: self];
        
        [self addSubview: _tableView];
    }
    return self;
}

- (void)dealloc
{
    [_titles release];
    [_tableView release];
    
    [super dealloc];
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return [_titles count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
    [[cell textLabel] setText: _titles[[indexPath row]]];
    
    return [cell autorelease];
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    GRLoginView *loginView = [[GRLoginView alloc] initWithFrame: [self frame]];
    
    ERSC(GRViewServiceID,
         GRViewServicePushContentViewAction,
         @[ loginView ], nil);
    
    [loginView release];
}

@end
