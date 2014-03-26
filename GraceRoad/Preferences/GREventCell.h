//
//  GREventCell.h
//  GraceRoad
//
//  Created by Mac003 on 14-3-26.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GREventCellID   @"gr.cell"

#define GRSectionTitleKey       @"section.title"
#define GREventListKey          @"event-list"
#define GRDateKey               @"date"
#define GRContentKey            @"content"

@interface GREventCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *eventInfo;

@end
