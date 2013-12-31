//
//  NSObject+DeallocationCallback.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/27/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

//#import "NSObject+DeallocationCallback.h"
#import <NoahsUtility/ERUUID.h>
#import <objc/runtime.h>
#import "ERObjectDeallocationCallbackController.h"

//#import <NoahsUtility/NoahsUtility.h>

static char ERObjectDeallocationCallbacksKey;

@implementation NSObject(DeallocationCallback)

- (ERUUID *)attachDeallocationCallback: (ERObjectDeallocationCallback)callback
{
    
    ERUUID *handle = [ERUUID UUID];
    
    NSMutableDictionary *callbacks = objc_getAssociatedObject(self, &ERObjectDeallocationCallbacksKey);
    if (!callbacks)
    {
        
        callbacks = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, &ERObjectDeallocationCallbacksKey, callbacks, OBJC_ASSOCIATION_RETAIN);
        
    }
    
    [callbacks setObject: [[[ERObjectDeallocationCallbackController alloc] initWithSubject: self
                                                                      deallocationCallback: callback
                                                                                    handle: handle] autorelease]
                  forKey: [handle stringDescription]];
    
    return handle;
}

- (void)detachDeallocationCallbackWithHandle: (ERUUID *)handle
{
    
    NSMutableDictionary *callbacks = objc_getAssociatedObject(self, &ERObjectDeallocationCallbacksKey);
    if (callbacks)
    {
        
        ERObjectDeallocationCallback callback = [callbacks objectForKey: [handle stringDescription]];
        
        [callback clearCallback];
            
        [callbacks removeObjectForKey: [handle stringDescription]];
        
    }
    
}

@end
