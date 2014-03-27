//
//  NSString+NCAddition.m
//  ChineseConverter Example
//
//  Created by nickcheng on 13-2-28.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import "NSString+NCAddition.h"
#import "NCChineseConverter.h"

@implementation NSString (NCAddition)

- (NSString *)chineseStringCN
{
    return [[NCChineseConverter sharedInstance] convert:self withDict:NCChineseConverterDictTypezh2CN];
}


@end
