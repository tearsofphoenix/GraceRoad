//
//  GRCalendarView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-26.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRCalendarView.h"
#import "GRTheme.h"

#define GRSectionTitleKey       @"section.title"
#define GREventListKey          @"event-list"
#define GRDateKey               @"date"
#define GRContentKey            @"content"

@interface GRCalendarView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation GRCalendarView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"行事历"];
        [self setHideTabbar: YES];
        
        _data = [(@[
                   (@{
                      GRSectionTitleKey : @"4月",
                      GREventListKey :
                          @[
                              (@{
                                 GRDateKey : @"4月11日-14日",
                                 GRContentKey : @"赴釜山教会参观学习"
                                 })
                              ]
                      }),
                   (@{
                      GRSectionTitleKey : @"5月",
                      GREventListKey :
                          @[
                              (@{
                                 GRDateKey : @"5月1日-3日",
                                 GRContentKey : @"培灵会"
                                 })
                              ]
                      }),
                   (@{
                      GRSectionTitleKey : @"6月",
                      GREventListKey :
                          @[
                              (@{
                                 GRDateKey : @"6月1日",
                                 GRContentKey : @"春季运动会"
                                 })
                              ]
                      }),
                   (@{
                      GRSectionTitleKey : @"8月",
                      GREventListKey :
                          @[
                              (@{
                                 GRDateKey : @"8月",
                                 GRContentKey : @"贵州短宣"
                                 })
                              ]
                      }),
                   (@{
                      GRSectionTitleKey : @"9月",
                      GREventListKey :
                          @[
                              (@{
                                 GRDateKey : @"9月",
                                 GRContentKey : @"退修会"
                                 })
                              ]
                      }),
                   (@{
                      GRSectionTitleKey : @"11月",
                      GREventListKey :
                          @[
                              (@{
                                 GRDateKey : @"11月27",
                                 GRContentKey : @"感恩节"
                                 })
                              ]
                      }),
                   (@{
                      GRSectionTitleKey : @"12月",
                      GREventListKey :
                          @[
                              (@{
                                 GRDateKey : @"12月20",
                                 GRContentKey : @"圣诞节晚会"
                                 }),
                              (@{
                                 GRDateKey : @"12月24",
                                 GRContentKey : @"平安夜"
                                 })
                              ]
                      }),
                   ]) retain];
        
        _contentView = [[UITableView alloc] initWithFrame: [self bounds]];
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
        
        [self addSubview: _contentView];
        
    }
    return self;
}

- (void)dealloc
{
    [_contentView release];
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return [_data count];
}

- (UIView *)tableView: (UITableView *)tableView
viewForHeaderInSection: (NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor: [GRTheme headerBlueColor]];
    
    NSDictionary *sectionInfo = _data[section];
    [label setText: [@"   " stringByAppendingString: sectionInfo[GRSectionTitleKey]]];
    
    return [label autorelease];
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    NSArray *events = _data[section][GREventListKey];
    return [events count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSArray *events = _data[section][GREventListKey];
    NSDictionary *info = events[row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSString *date = info[GRDateKey];
    NSString *content = info[GRContentKey];
    
    [[cell textLabel] setText: [date stringByAppendingFormat: @"  %@", content]];
    
    return [cell autorelease];
}

@end
