//
//  NSString+LatinTransliteration.m
//  NoahsDiplomat
//
//  Created by Minun Dragonation on 3/1/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+LatinTransliteration.h"

#import <NoahsService/NoahsService.h>

#import "NSArray+NSNull.h"

#import "NSString+Transform.h"

@implementation NSString(LatinTransliteration)

- (NSString *)latinTransliteration
{
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceLatinTransliteration_Action,
                 [NSArray arrayWithObjectOrNil: self]);
}

- (NSString *)latinTransliterationForUsage: (NSString *)usage
{
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceLatinTransliteration_Usage_Action,
                 [NSArray arrayWithCount: 2
                           objectsOrNils:
                  self,
                  usage]);
}

- (NSString *)latinTransliterationForUsages: (NSSet *)usages
{
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceLatinTransliteration_Usages_Action,
                 [NSArray arrayWithCount: 2
                           objectsOrNils:
                  self,
                  usages]);
}

- (NSString *)latinTransliterationTitle
{
    return [self latinTransliterationTitleForUsages: nil];
}

- (NSString *)latinTransliterationTitleForUsage: (NSString *)usage
{
    
    if (usage)
    {
        return [self latinTransliterationTitleForUsages: [NSSet setWithObject: usage]];
    }
    else
    {
        return [self latinTransliterationTitleForUsages: nil];
    }
    
}

- (NSString *)latinTransliterationTitleForUsages: (NSSet *)usages
{
    
    NSString *latinTransliteration = [[self latinTransliterationForUsages: usages] autolocalizedUppercaseString];
    
    return [latinTransliteration substringToIndex: 1];
    
}

@end
