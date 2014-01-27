//
//  GRContactUSView.m
//  GraceRoad
//
//  Created by Lei on 14-1-20.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRContactUSView.h"
#import "GRTheme.h"

@interface GRContactUSView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation GRContactUSView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"联系我们"];
        [self setHideTabbar: YES];
        
        UIImage *image = [UIImage imageNamed: @"GRQRCode"];
        CGSize size = CGSizeMake(256, 256);//[image size];
        CGRect rect = CGRectMake((frame.size.width - size.width) / 2, 30, size.width, size.height);
        
        UIImageView *QRCodeView = [[UIImageView alloc] initWithFrame: rect];
        [QRCodeView setImage: image];
        
        _tableView = [[UITableView alloc] initWithFrame: [self bounds]];
        
        UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
        [view addSubview: QRCodeView];
        [QRCodeView release];
        
        [_tableView setTableHeaderView: view];
        [view release];
        
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

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch ([indexPath row])
    {
        case 0:
        {
            [[cell textLabel] setNumberOfLines: 2];
            [[cell textLabel] setText: @"1路，3路，松闵线 到 谷阳北路新松江路站"];
            break;
        }
        case 1:
        {
            [[cell textLabel] setText: @"11路，14路 到 新松江路谷阳北路站"];
            break;
        }
        case 2:
        {
            [[cell textLabel] setText: @"20路 到 通跃路新松江路站"];
            break;
        }
        case 3:
        {
            [[cell textLabel] setNumberOfLines: 2];
            [[cell textLabel] setText: @"18路，松朱线 到 嘉松南路新松江路站"];
            break;
        }
        case 4:
        {
            [[cell textLabel] setNumberOfLines: 2];
            [[cell textLabel] setText: @"22路，23路，25路 到 松江新城地铁站"];
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
    switch ([indexPath row])
    {
        case 0:
        {
            return 60;
        }
        case 1:
        case 2:
        {
            return 40;
        }
        case 3:
        {
            return 60;
        }
        case 4:
        {
            return 60;
        }
        default:
        {
            return 40;
        }
    }
}

- (UIView *) tableView: (UITableView *)tableView
viewForHeaderInSection: (NSInteger)section
{
    UILabel *headerLabel = [GRTheme newheaderLabel];
    
    [headerLabel setText: @"    公交指南"];
    
    return headerLabel;
}


@end
