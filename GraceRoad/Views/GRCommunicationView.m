//
//  GRCommunicationView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRCommunicationView.h"

@interface GRCommunicationView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation GRCommunicationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitle: @"交通"];
        [self setBackgroundColor: [UIColor blueColor]];
    }
    return self;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return nil;
}

@end
