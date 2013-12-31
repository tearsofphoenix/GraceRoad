//
//  UIApplication+ApplicationInfo.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/20/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication(ApplicationInfo)

- (NSString *)applicationIdentifier;

- (NSString *)applicationVersion;

- (NSString *)applicationShortVersion;

- (NSString *)applicationPath;

- (id)profile;

@end
