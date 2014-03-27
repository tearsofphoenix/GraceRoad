//
//  GRFellowshipCell.h
//  GraceRoad
//
//  Created by Mac003 on 14-3-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "ERGalleryViewThumbnail.h"

#define GRFellowshipNameKey         @"name"
#define GRFellowshipAddressKey      @"address"
#define GRFellowshipPhoneKey        @"phone"

@interface GRFellowshipCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *info;

@end
