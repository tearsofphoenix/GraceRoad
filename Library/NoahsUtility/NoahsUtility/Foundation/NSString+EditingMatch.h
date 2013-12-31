//
//  NSString+EditingMatch.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/25/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EditingMatch)

- (BOOL)couldMatch: (NSString *)editingString
       replacement: (NSString *)replacement
       withinRange: (NSRange)editingRange;

@end
