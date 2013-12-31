//
//  NSMutableDictionary+CollectionPath.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/19/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(CollectionPath)

- (void)   setObjectOrNil: (id)object
         atCollectionPath: (NSString *)path;

@end
