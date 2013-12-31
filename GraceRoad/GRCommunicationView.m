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
        
        [self setBackgroundColor: [UIColor blueColor]];
    }
    return self;
}

- (NSString *)title
{
    return @"交通";
}

@end
