//
//  GRPrayView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-6.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRPrayView.h"
#import "GRDataService.h"
#import "GRPrayKeys.h"

@interface GRPrayView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_praySources;
    UITableView *_prayListView;
    UIButton *_rightNavigationButton;
}
@end

@implementation GRPrayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitle: @"代祷"];
        [self setHideTabbar: YES];
        
        _praySources = [[NSMutableArray alloc] init];
        [_praySources setArray: ERSSC(GRDataServiceID,
                                      GRDataServiceAllPrayListAction,
                                      nil)];
        
        _prayListView = [[UITableView alloc] initWithFrame: [self bounds]];
        [_prayListView setDataSource: self];
        [_prayListView setDelegate: self];
        
        [self addSubview: _prayListView];
        
        _rightNavigationButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60, 44)];
        [_rightNavigationButton setBackgroundImage: [UIImage imageNamed: @"GRAddButton"]
                                          forState: UIControlStateNormal];
        [_rightNavigationButton addTarget: self
                                   action: @selector(_handleAddPrayButtonTappedEvent:)
                         forControlEvents: UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)dealloc
{
    [_praySources release];
    [_prayListView release];
    
    [_rightNavigationButton release];
    
    [super dealloc];
}

- (UIButton *)rightNavigationButton
{
    return _rightNavigationButton;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return [_praySources count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSDictionary *prayInfo = _praySources[[indexPath row]];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[cell textLabel] setText: prayInfo[GRPrayTitleKey]];
    
    return [cell autorelease];
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 60;
}

- (void)_handleAddPrayButtonTappedEvent: (id)sender
{
    
}

@end

