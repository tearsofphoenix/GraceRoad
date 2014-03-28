//
//  GRCalendarView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-26.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRCalendarView.h"
#import "GRTheme.h"
#import "NSObject+GRExtensions.h"
#import "GRShared.h"
#import "GRNetworkService.h"

#define GRSectionTitleKey       @"section.title"
#define GREventListKey          @"event-list"
#define GRDateKey               @"date"
#define GRContentKey            @"content"

#define GRCalendarStoreKey  GRPrefix ".calendar"

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
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *calendarInfo = [defaults objectForKey: GRCalendarStoreKey];
        if (calendarInfo)
        {
            [self setData: calendarInfo];
        }else
        {
            [GRNetworkService postMessage: (@{
                                              GRNetworkActionKey : @"get_calendar",
                                              })
                                 callback: (^(NSDictionary *result, id exception)
                                            {
                                                if ([result[GRNetworkStatusKey] isEqualToString: GRNetworkStatusOKValue])
                                                {
                                                    NSArray *info = result[GRNetworkDataKey];
                                                    
                                                    [defaults setObject: info
                                                                 forKey: GRCalendarStoreKey];
                                                    [defaults synchronize];
                                                    
                                                    [self setData: info];
                                                    
                                                }
                                            })];

        }
        
        _contentView = [[UITableView alloc] initWithFrame: [self bounds]];
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
        
        [self addSubview: _contentView];
        
    }
    return self;
}

- (void)setData: (NSArray *)data
{
    if (_data != data)
    {
        _data = data;
        
        [_contentView reloadData];
    }
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
    
    return label;
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
    
    return cell;
}

@end
