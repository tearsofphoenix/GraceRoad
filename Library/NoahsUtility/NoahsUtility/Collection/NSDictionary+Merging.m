//
//  NSDictionary+Merging.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/20/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+Merging.h"

#import "NSDictionary+NSNull.h"
#import "NSArray+NSNull.h"

#import "NSArray+Merging.h"

@implementation NSDictionary (Merging)

- (NSDictionary *)dictionaryMergedWithDictionary: (NSDictionary *)dictionary
{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary: self];
    
    for (id key in dictionary)
    {
        
        id value = [dictionary objectForKey: key];
        if ([value isKindOfClass: [NSDictionary class]])
        {
            
            id resultValue = [result objectForKey: key];
            if ([resultValue isKindOfClass: [NSDictionary class]])
            {
                [result setObject: [resultValue dictionaryMergedWithDictionary: value]
                           forKey: key];
            }
            else
            {
                [result setObject: value forKey: key];
            }
            
        }
        else if ([value isKindOfClass: [NSArray class]])
        {

            id resultValue = [result objectForKey: key];
            if ([resultValue isKindOfClass: [NSArray class]])
            {
                [result setObject: [resultValue arrayMergedWithArray: value]
                           forKey: key];
            }
            else
            {
                [result setObject: value forKey: key];
            }

        }
        else
        {
            [result setObject: value forKey: key];
        }
        
    }
    
    return [NSDictionary dictionaryWithDictionary: result];
}

@end
