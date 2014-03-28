//
//  GRPreferenceView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRPreferenceView.h"
#import "GRUserProfileView.h"
#import "GRViewService.h"
#import "GRPrayView.h"
#import "GRSettingsView.h"
#import "GRDataService.h"
#import "GRLoginView.h"
#import "UIAlertView+BlockSupport.h"
#import "GRFeedbackView.h"
#import "GRContactUSView.h"
#import "GRQTView.h"
#import "GRFellowshipView.h"

@interface GRPreferenceView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *viewClasses;

@end

@implementation GRPreferenceView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"设置"];
        
        [self setTitles: @[ @"服事登录", @"每日灵修", @"代祷", @"团契", @"联系我们", @"反馈"]];
        [self setViewClasses: @[ [GRUserProfileView class], [GRQTView class], [GRPrayView class], [GRFellowshipView class], [GRContactUSView class], [GRFeedbackView class] ]];
        
        _tableView = [[UITableView alloc] initWithFrame: [self bounds]];
        [_tableView setDataSource: self];
        [_tableView setDelegate: self];
        
        [self addSubview: _tableView];
    }
    return self;
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
    
    //[[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
    [[cell textLabel] setText: _titles[[indexPath row]]];
    
    return cell;
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    Class viewClass = _viewClasses[row];
    
    GRContentView *view = [[viewClass alloc] initWithFrame: [self frame]];
    ERSC(GRViewServiceID, GRViewServicePushContentViewAction, @[ view ], nil);
}

@end
