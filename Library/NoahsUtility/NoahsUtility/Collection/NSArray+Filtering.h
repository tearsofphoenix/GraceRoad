//
//  NSArray+Filtering.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ERUtilityCollectionFilterBlock)(id element);

@interface NSArray (Filtering)

- (NSArray *)filteredArrayUsingBlock: (ERUtilityCollectionFilterBlock)block;

@end
