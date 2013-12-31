//
//  NSArray+CollectionPath.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 2/27/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CollectionPath)

- (id)objectOrNilAtCollectionPath: (NSString *)path;

- (NSArray *)arrayForObjectsAtCollectionPathOfElements: (NSString *)path;

- (NSMutableArray *)deepMutableCopy NS_RETURNS_RETAINED;

@end
