//
//  NSObject+CollectionPath.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/9/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CollectionPath)

- (id)objectOrNilAtCollectionPath: (NSString *)path;

- (void)   setObjectOrNil: (id)object
         atCollectionPath: (NSString *)path;

@end
