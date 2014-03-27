//
//  GRFellowshipView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRFellowshipView.h"
#import "ERGalleryView.h"
#import "ERGalleryViewThumbnail.h"
#import "GRFellowshipCell.h"

@interface GRFellowshipView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) NSArray *data;

@end


@implementation GRFellowshipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setData: @[
                         (@{
                            GRFellowshipNameKey : @"香柏树团契",
                            GRFellowshipAddressKey : @"三湘2期46号1401",
                            GRFellowshipPhoneKey : @"135-0162-5880",
                            }),
                         (@{
                            GRFellowshipNameKey : @"无花果树团契",
                            GRFellowshipAddressKey : @"月亮河桂园别墅53号",
                            GRFellowshipPhoneKey : @"130-0310-0418",
                            }),
                         (@{
                            GRFellowshipNameKey : @"皂荚树团契",
                            GRFellowshipAddressKey : @"建设花园79号301",
                            GRFellowshipPhoneKey : @"189-3064-8530",
                            }),
                         (@{
                            GRFellowshipNameKey : @"仁爱团契",
                            GRFellowshipAddressKey : @"御上海30号702",
                            GRFellowshipPhoneKey : @"139-1768-3163",
                            }),
                         (@{
                            GRFellowshipNameKey : @"以琳团契",
                            GRFellowshipAddressKey : @"泗泾金港花园二期66号202",
                            GRFellowshipPhoneKey : @"135-6556-9288",
                            }),
                         ]];
        
        [self setTitle: @"团契"];
        [self setHideTabbar: YES];
        
        _contentView = [[UITableView alloc] initWithFrame: [self bounds]];
        [self addSubview: _contentView];
        
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
    }
    return self;
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    [_contentView setFrame: [self bounds]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    GRFellowshipCell *view = [[GRFellowshipCell alloc] initWithFrame: CGRectMake(0, 0, 100, 60)];
    
    NSInteger idx = [indexPath row];
    
    NSDictionary *info = _data[idx];
    [view setInfo: info];
    
    return [view autorelease];
}

- (CGFloat)      tableView: (UITableView *)tableView
   heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 100;
}

@end
