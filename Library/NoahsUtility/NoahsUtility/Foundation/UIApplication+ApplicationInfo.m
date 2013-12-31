//
//  UIApplication+ApplicationInfo.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/20/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "UIApplication+ApplicationInfo.h"

#import "NSDictionary+NSNull.h"

@implementation UIApplication (ApplicationInfo)

- (NSString *)applicationIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

- (NSString *)applicationVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)applicationShortVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)applicationPath
{
    return [[NSBundle mainBundle] bundlePath];
}

- (id)profile
{
    return [NSDictionary dictionaryWithKeysAndObjectsOrNils:
            @"com.eintsoft.gopher-wood.noahs-utility.application.identifier", [self applicationIdentifier],
            @"com.eintsoft.gopher-wood.noahs-utility.application.version", [self applicationVersion],
            @"com.eintsoft.gopher-wood.noahs-utility.application.version.short", [self applicationShortVersion],
            @"com.eintsoft.gopher-wood.noahs-utility.application.path", [self applicationPath],
            nil];
}

@end
