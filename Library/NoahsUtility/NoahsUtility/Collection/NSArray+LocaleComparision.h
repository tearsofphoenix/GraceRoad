//
//  NSArray+LocaleComparision.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 2/28/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LocaleComparision)

- (NSArray *)sortedArrayForUsage: (NSString *)usage;

- (NSArray *)sortedArrayForUsages: (NSSet *)usages;

- (NSArray *)sortedArrayForCollectionPath: (NSString *)collectionPath
                                    usage: (NSString *)usage;

- (NSArray *)sortedArrayForCollectionPath: (NSString *)collectionPath
                                   usages: (NSSet *)usages;

@end
