//
//  NSString+LatinTransliteration.h
//  NoahsDiplomat
//
//  Created by Minun Dragonation on 3/1/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LatinTransliteration)

- (NSString *)latinTransliteration;

- (NSString *)latinTransliterationForUsage: (NSString *)usage;

- (NSString *)latinTransliterationForUsages: (NSSet *)usages;

- (NSString *)latinTransliterationTitle;

- (NSString *)latinTransliterationTitleForUsage: (NSString *)usage;

- (NSString *)latinTransliterationTitleForUsages: (NSSet *)usages;

@end
