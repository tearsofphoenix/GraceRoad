//
//  NSMutableDictionary+Merging.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/7/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSMutableDictionary+Merging.h"

@implementation NSMutableDictionary (Merging)

- (void)mergeWithDictionary: (NSDictionary *)dictionary
{
    
    for (id key in dictionary)
    {
        
        id value = [dictionary objectForKey: key];
        if ([value isKindOfClass: [NSDictionary class]])
        {
            
            id resultValue = [self objectForKey: key];
            if ([resultValue isMemberOfClass: [NSDictionary class]])
            {
                
                resultValue = [[resultValue mutableCopy] autorelease];
                
                [self setObject: resultValue
                         forKey: key];
                
            }
            
            if ([resultValue isKindOfClass: [NSMutableDictionary class]])
            {
                [resultValue mergeWithDictionary: value];
            }
            else
            {
                [self setObject: value forKey: key];
            }
            
        }
        else
        {
            [self setObject: value forKey: key];
        }
        
    }
    
}

@end
