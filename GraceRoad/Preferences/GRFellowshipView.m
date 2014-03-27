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
#import "NSObject+GRExtensions.h"
#import "GRShared.h"
#import "GRNetworkService.h"

#define GRFellowshipKey     GRPrefix ".fellowship"

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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *fellowShipInfo = [defaults objectForKey: GRFellowshipKey];
        if (fellowShipInfo)
        {
            [self setData: fellowShipInfo];
        }else
        {
            //
            [GRNetworkService postMessage: (@{
                                              GRNetworkActionKey : @"get_fellowship",
                                              })
                                 callback: (^(NSDictionary *result, id exception)
                                            {
                                                if ([result[GRNetworkStatusKey] isEqualToString: GRNetworkStatusOKValue])
                                                {
                                                    NSArray *info = result[GRNetworkDataKey];
                                                    
                                                    [defaults setObject: info
                                                                 forKey: GRFellowshipKey];
                                                    [defaults synchronize];
                                                    
                                                    [self setData: info];
                                                    
                                                }
                                            })];
            
        }
        
        [self setTitle: @"团契"];
        [self setHideTabbar: YES];
        
        _contentView = [[UITableView alloc] initWithFrame: [self bounds]];
        [self addSubview: _contentView];
        
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
    }
    return self;
}

- (void)dealloc
{
    [_data release];
    [_contentView release];
    
    [super dealloc];
}

- (void)setData: (NSArray *)data
{
    if (_data != data)
    {
        [_data release];
        _data = [data retain];
        
        [_contentView reloadData];
    }
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
