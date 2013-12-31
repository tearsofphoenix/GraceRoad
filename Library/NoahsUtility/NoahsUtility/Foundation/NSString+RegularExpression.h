//
//  NSString+RegularExpression.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/8/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(RegularExpression)

- (BOOL)matchesRegularExpression: (NSString *)regularExpression;

@end
