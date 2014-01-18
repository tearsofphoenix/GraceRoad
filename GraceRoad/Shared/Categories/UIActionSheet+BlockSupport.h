//
//  UIActionSheet+BlockSupport.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-16.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ GRActionSheetCallback)(NSInteger buttonIndex);

@interface UIActionSheet (BlockSupport)

+ (void)showWithTitle: (NSString *)title
              choices: (NSArray *)choices
               inView: (UIView *)view
             callback: (GRActionSheetCallback)callback;

@property (nonatomic, copy) GRActionSheetCallback callback;

@end
