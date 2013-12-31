//
//  NSArray+ObjectSharing.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/14/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDictionary+CollectionPath.h"

@interface NSArray (ObjectSharing)

- (BOOL)containsObjectHasValue: (id)value
              atCollectionPath: (NSString *)collectionPath;

@end
