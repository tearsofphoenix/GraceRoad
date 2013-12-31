//
//  NSDictionary+Filtering.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+Filtering.h"

@implementation NSDictionary(Filtering)

- (NSDictionary *)filteredDictionaryUsingBlock: (ERUtilityDictionaryFilterBlock)block
{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:
     (^(id key, id object, BOOL *stop)
      {
          
          if (block(key, object))
          {
              [dictionary setObject: object
                             forKey: key];
          }
          
      })];
    
    return [NSDictionary dictionaryWithDictionary: dictionary];
}

@end
