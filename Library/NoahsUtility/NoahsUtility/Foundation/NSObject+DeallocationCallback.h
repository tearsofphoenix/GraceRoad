//
//  NSObject+DeallocationCallback.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/27/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ERUUID;

typedef void (^ERObjectDeallocationCallback)(id object, ERUUID *deallocationHandle);

@interface NSObject (DeallocationCallback)

- (ERUUID *)attachDeallocationCallback: (ERObjectDeallocationCallback)callback;

- (void)detachDeallocationCallbackWithHandle: (ERUUID *)handle;

@end
