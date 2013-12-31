//
//  NSBundle+ConditionalFileResourceLoading.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/7/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class ERLocale;

extern NSString *ERBundleResourcePath(NSBundle *bundle);

@interface NSBundle(ConditionalFileResourceLoading)

- (NSString *)filePathForConditionalResourceName: (NSString *)name;

- (NSURL *)URLForConditionalResourceName: (NSString *)name;

- (UIImage *)imageWithConditionalResourceName: (NSString *)name;

- (NSString *)filePathForConditionalResourceName: (NSString *)name
                                          locale: (ERLocale *)locale;

- (NSString *)filePathForConditionalNoThemeResourceName: (NSString *)name
                                                 locale: (ERLocale *)locale;

- (NSURL *)URLForConditionalResourceName: (NSString *)name
                                  locale: (ERLocale *)locale;

- (NSURL *)URLForConditionalNoThemeResourceName: (NSString *)name
                                         locale: (ERLocale *)locale;

- (UIImage *)imageWithConditionalNoThemeResourceName: (NSString *)name
                                              locale: (ERLocale *)locale;

- (BOOL)resourceFileExists: (NSString *)filePath;

@end
