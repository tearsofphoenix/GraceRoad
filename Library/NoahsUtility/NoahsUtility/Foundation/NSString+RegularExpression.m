//
//  NSString+RegularExpression.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/8/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString(RegularExpression)

- (BOOL)matchesRegularExpression: (NSString *)regularExpression
{
    return ([self rangeOfString: regularExpression
                        options: NSRegularExpressionSearch].location != NSNotFound);
}

@end
