//
//  NSDictionary+CollectionPath.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 2/27/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CollectionPath)

- (id)objectOrNilAtCollectionPath: (NSString *)path;

- (NSMutableDictionary *)deepMutableCopy NS_RETURNS_RETAINED; 

@end
