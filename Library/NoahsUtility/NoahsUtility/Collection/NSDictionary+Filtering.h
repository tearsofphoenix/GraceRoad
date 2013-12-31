//
//  NSDictionary+Filtering.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ERUtilityDictionaryFilterBlock)(id key, id element);

@interface NSDictionary (Filtering)

- (NSDictionary *)filteredDictionaryUsingBlock: (ERUtilityDictionaryFilterBlock)block;

@end
