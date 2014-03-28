//
//  UIActionSheet+BlockSupport.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-16.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "UIActionSheet+BlockSupport.h"
#import <objc/runtime.h>

@interface UIActionSheet ()<UIActionSheetDelegate>

@end

static char *UIActionSheetCallbackKey;

@implementation UIActionSheet (BlockSupport)

+ (void)showWithTitle: (NSString *)title
              choices: (NSArray *)choices
               inView: (UIView *)view
             callback: (GRActionSheetCallback)callback
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle: title
                                                       delegate: nil
                                              cancelButtonTitle: @"取消"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    [sheet setDelegate: sheet];
    [sheet setCallback: callback];
    
    for (NSString *iLooper in choices)
    {
        [sheet addButtonWithTitle: iLooper];
    }
    
    [sheet showInView: view];
}

- (void)setCallback: (GRActionSheetCallback)callback
{
    objc_setAssociatedObject(self, &UIActionSheetCallbackKey, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (GRActionSheetCallback)callback
{
    return objc_getAssociatedObject(self, &UIActionSheetCallbackKey);
}

- (void) actionSheet: (UIActionSheet *)actionSheet
clickedButtonAtIndex: (NSInteger)buttonIndex
{
    GRActionSheetCallback callback = [self callback];
    if (callback)
    {
        callback(buttonIndex);
    }
}

@end
