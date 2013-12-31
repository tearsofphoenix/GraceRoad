//
//  NSSet+Filtering.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <NoahsUtility/NSArray+Filtering.h>

@interface NSSet (Filtering)

- (NSSet *)filteredSetUsingBlock: (ERUtilityCollectionFilterBlock)block;

@end
