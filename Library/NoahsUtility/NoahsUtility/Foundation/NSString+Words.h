//
//  NSString+Words.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 1/7/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Words)

- (NSArray *)words;

- (NSRange)closestSelectableExpressionRangeArroundIndex: (NSInteger)index;

@end
