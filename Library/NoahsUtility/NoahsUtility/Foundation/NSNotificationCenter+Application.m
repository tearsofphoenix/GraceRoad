//
//  NSNotificationCenter+Application.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 9/14/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSNotificationCenter+Application.h"

static NSNotificationCenter *NSApplicationNotificationCenter;

static NSNotificationCenter *NSApplicationServiceCenter;

@implementation NSNotificationCenter(Application)

+ (NSNotificationCenter *)applicationCenter
{
    
    if (!NSApplicationNotificationCenter)
    {
        NSApplicationNotificationCenter = [[NSNotificationCenter alloc] init];
    }
    
    return NSApplicationNotificationCenter;
    
}

+ (NSNotificationCenter *)serviceCenter
{
    
    if (!NSApplicationServiceCenter)
    {
        NSApplicationServiceCenter = [[NSNotificationCenter alloc] init];
    }
    
    return NSApplicationServiceCenter;
    
}

@end
