//
//  UIAlertView+BlockSupport.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-3.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "UIAlertView+BlockSupport.h"
#import <objc/runtime.h>

static char UIAlertViewCallbackKey;

@interface UIAlertView ()<UIAlertViewDelegate>

@end

@implementation UIAlertView (BlockSupport)

+ (void)showAlertWithTitle: (NSString *)title
                   message: (NSString *)message
         cancelButtonTitle: (NSString *)cancelButtonTitle
         otherButtonTitles: (NSArray *)otherButtonTitles
                  callback: (GRAlertViewCallback)callback
{
    UIAlertView *alertView = [[self alloc] initWithTitle: title
                                                 message: message
                                                delegate: nil
                                       cancelButtonTitle: cancelButtonTitle
                                       otherButtonTitles: nil];
    
    [alertView setDelegate: alertView];
    
    if (callback)
    {
        objc_setAssociatedObject(alertView, &UIAlertViewCallbackKey, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    for (NSString *tLooper in otherButtonTitles)
    {
        [alertView addButtonWithTitle: tLooper];
    }
    
    [alertView show];
    
    [alertView autorelease];
}

+ (void)alertWithMessage: (NSString *)message
       cancelButtonTitle: (NSString *)cancelButtonTitle
{
    [self showAlertWithTitle: nil
                     message: message
           cancelButtonTitle: cancelButtonTitle
           otherButtonTitles: nil
                    callback: nil];
}

- (void)   alertView: (UIAlertView *)alertView
clickedButtonAtIndex: (NSInteger)buttonIndex
{
    GRAlertViewCallback callback = objc_getAssociatedObject(self, &UIAlertViewCallbackKey);
    
    if (callback)
    {
        callback(buttonIndex);
        objc_setAssociatedObject(self, &UIAlertViewCallbackKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

@end
