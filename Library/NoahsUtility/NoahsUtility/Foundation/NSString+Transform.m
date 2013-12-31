//
//  NSString+Transform.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/1/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+Transform.h"

#import <NoahsService/NoahsService.h>

#import "NSArray+NSNull.h"

@implementation NSString (Transform)

- (NSString *)autolocalizedLowercaseString
{
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceTransformString_Usage_Action,
                 [NSArray arrayWithCount: 2
                           objectsOrNils:
                  self,
                  ERLocaleServiceStringTransformForLowercases]);
}

- (NSString *)autolocalizedUppercaseString
{
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceTransformString_Usage_Action,
                 [NSArray arrayWithCount: 2
                           objectsOrNils:
                  self,
                  ERLocaleServiceStringTransformForUppercases]);
}

@end
