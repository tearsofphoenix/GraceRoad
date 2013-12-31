//
//  NSString+DictionaryDescription.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/18/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DictionaryDescription)

+ (NSString *)descriptionForKeysAndObjectsOrNils: (id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSString *)descriptionForOrderedObjects: (id)object, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSString *)descriptionForPointer: (void *)pointer;

@end
