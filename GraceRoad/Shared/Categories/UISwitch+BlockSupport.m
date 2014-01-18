//
//  UISwitch+BlockSupport.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-14.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "UISwitch+BlockSupport.h"
#import <objc/runtime.h>

static char *UISwitchCallbackKey;

@implementation UISwitch (BlockSupport)

- (void)setCallback: (dispatch_block_t)callback
{
    objc_setAssociatedObject(self, &UISwitchCallbackKey, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget: [self class]
             action: @selector(_handleValueChangedEvent:)
   forControlEvents: UIControlEventValueChanged];
}

- (dispatch_block_t)callback
{
    return objc_getAssociatedObject(self, &UISwitchCallbackKey);
}

+ (void)_handleValueChangedEvent: (UISwitch *)sender
{
    dispatch_block_t callback = [sender callback];
    if (callback)
    {
        callback();
    }
}

@end
