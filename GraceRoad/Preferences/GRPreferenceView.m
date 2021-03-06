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
        
        _titles = [@[ @"服事登录", @"每日灵修", @"代祷", @"联系我们", @"反馈"] retain];
        
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
    
    //[[cell textLabel] setTextAlignment: NSTextAlignmentCenter];
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
    NSInteger row = [indexPath row];
    switch (row)
    {
        case 0:
        {
            GRUserProfileView *view = [[GRUserProfileView alloc] initWithFrame: [self frame]];
            ERSC(GRViewServiceID, GRViewServicePushContentViewAction, @[ view ], nil);
            [view release];            
            break;
        }
        case 1:
        {
            GRQTView *view = [[GRQTView alloc] initWithFrame: [self frame]];
            ERSC(GRViewServiceID, GRViewServicePushContentViewAction, @[ view ], nil);
            [view release];
            break;
        }
        case 2:
        {
            GRPrayView *prayView = [[GRPrayView alloc] initWithFrame: [self frame]];
            ERSC(GRViewServiceID, GRViewServicePushContentViewAction, @[ prayView ], nil);            
            [prayView release];
            
            break;
        }
        case 3:
        {
            GRContactUSView *view = [[GRContactUSView alloc] initWithFrame: [self frame]];
            ERSC(GRViewServiceID, GRViewServicePushContentViewAction, @[ view ], nil);
            [view release];
            break;
        }
        case 4:
        {
            GRFeedbackView *feedbackView = [[GRFeedbackView alloc] initWithFrame: [self frame]];
            ERSC(GRViewServiceID, GRViewServicePushContentViewAction, @[ feedbackView ], nil);
            [feedbackView release];
            break;
        }
        default:
            break;
    }
}

@end
