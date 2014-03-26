//
//  GRCalendarView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-26.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRCalendarView.h"
#import "GRTheme.h"
#import "GREventCell.h"

@interface GRCalendarView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *contentView;
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
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection: UICollectionViewScrollDirectionVertical];
        [layout setItemSize: CGSizeMake(60, 60)];
        
        _contentView = [[UICollectionView alloc] initWithFrame: [self bounds]
                                          collectionViewLayout: layout];
        [_contentView registerClass: [GREventCell class]
         forCellWithReuseIdentifier: GREventCellID];
        
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView: (UICollectionView *)collectionView
     numberOfItemsInSection: (NSInteger)section
{
    NSInteger count = [_data count];
    if (section * 4 <= count)
    {
        return 4;
    }
    
    return count % [self numberOfSectionsInCollectionView: collectionView];
}

- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView
                  cellForItemAtIndexPath: (NSIndexPath *)indexPath
{
    GREventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: GREventCellID
                                                                  forIndexPath: indexPath];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSInteger idx = section * [self numberOfSectionsInCollectionView: collectionView] + row;
    
    NSArray *events = _data[idx][GREventListKey];
    NSDictionary *info = events[0];
    [cell setEventInfo: info];
    
    return cell;
}
 
@end
