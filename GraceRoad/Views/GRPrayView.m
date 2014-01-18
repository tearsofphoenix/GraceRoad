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
#import "UIAlertView+BlockSupport.h"

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
        [_prayListView setBackgroundColor: [UIColor clearColor]];
        
        [self addSubview: _prayListView];
        
        _rightNavigationButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
        [_rightNavigationButton setImage: [UIImage imageNamed: @"GRAddButton"]
                                forState: UIControlStateNormal];
        [_rightNavigationButton setImageEdgeInsets: UIEdgeInsetsMake(8, 8, 8, 8)];

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
    UIAlertView *alertView = [UIAlertView alertWithTitle: @"请输入代祷内容："
                                                 message: nil
                                       cancelButtonTitle: @"取消"
                                       otherButtonTitles: @[@"确定"]
                                                callback: nil];
    
    [alertView setAlertViewStyle: UIAlertViewStylePlainTextInput];
    
    [alertView setCallback: (^(NSInteger buttonIndex)
                             {
                                 NSString *text = [[alertView textFieldAtIndex: 0] text];
                                 if ([text length] > 0)
                                 {
                                     [_praySources insertObject: (@{
                                                                    GRPrayTitleKey : text,
                                                                    GRPrayUploadDateKey : [NSDate date],
                                                                    })
                                                        atIndex: 0];
                                     
                                     [_prayListView reloadData];
                                     
                                     ERSC(GRDataServiceID, GRDataServiceSendMessageToWeixinAction, @[ text ], nil);
                                 }
                             })];
    [alertView show];
}

@end

