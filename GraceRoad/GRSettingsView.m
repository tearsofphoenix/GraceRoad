//
//  GRSettingsView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-14.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRSettingsView.h"
#import "UISwitch+BlockSupport.h"

@interface GRSettingsView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation GRSettingsView

- (id)initWithFrame: (CGRect)frame
{
    if ((self = [super initWithFrame: frame]))
    {
        [self setTitle: @"设置"];
        [self setHideTabbar: YES];
        
        _tableView = [[UITableView alloc] initWithFrame: [self bounds]
                                                  style: UITableViewStyleGrouped];
        [_tableView setDataSource: self];
        [_tableView setDelegate: self];
        
        [self addSubview: _tableView];
    }
    
    return self;
}

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    [_tableView setFrame: [self bounds]];
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (row)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            [[cell textLabel] setText: @"记住密码"];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame: CGRectMake(320 - 60, 7, 40, 30)];
            [[cell contentView] addSubview: switchView];
            [switchView setCallback: (^
                                      {
                                          if ([switchView isOn])
                                          {
                                              
                                          }else
                                          {
                                              
                                          }
                                      })];
            [switchView release];
            break;
        }
        default:
            break;
    }
    
    return [cell autorelease];
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
}

@end
