//
//  NSArray+Groupping.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/5/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^ERArrayCategoryGetter)(id element);

@interface NSArray (Groupping)

- (NSArray *)grouppedArrayBySortingCollectionPath: (NSString *)collectionPath
                                           usages: (NSSet *)usages
                                   categoryGetter: (ERArrayCategoryGetter)categoryGetter;

@end
