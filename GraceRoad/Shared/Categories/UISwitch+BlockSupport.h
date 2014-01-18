//
//  UISwitch+BlockSupport.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-14.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (BlockSupport)

@property (nonatomic, copy) dispatch_block_t callback;


@end
