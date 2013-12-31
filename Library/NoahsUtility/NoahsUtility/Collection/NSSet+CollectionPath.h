//
//  NSSet+CollectionPath.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (CollectionPath)

- (id)objectOrNilAtCollectionPath: (NSString *)path;

- (NSArray *)arrayForObjectsAtCollectionPathOfElements: (NSString *)path;

- (NSMutableSet *)deepMutableCopy NS_RETURNS_RETAINED;

@end
