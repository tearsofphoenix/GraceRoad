//
//  NSSet+CollectionPath.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSSet+CollectionPath.h"

#import "NSMutableArray+NSNull.h"

@implementation NSSet (CollectionPath)

- (id)objectOrNilAtCollectionPath: (NSString *)path
{
    
    if (!path)
    {
        return self;
    }
    
    NSArray *components = [path componentsSeparatedByString: @"/"];
    if ([components count] > 0)
    {
        
        NSString *key = [components objectAtIndex: 0];
        if ([key characterAtIndex: 0] == '?')
        {
            
            if ([key isEqualToString: @"?count"])
            {
                return [NSNumber numberWithInteger: [self count]];
            }
            else if ([key isEqualToString: @"?any.object"])
            {
                if ([self count] > 0)
                {
                    return [self anyObject];
                }
                else
                {
                    return nil;
                }
            }
            else if ([key isEqualToString: @"?as.array"])
            {
                return [self allObjects];
            }
            else if ([key isEqualToString: @"?as.set"])
            {
                return self;
            }
            else
            {
                return nil;
            }
            
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        return nil;
    }
    
}

- (NSArray *)arrayForObjectsAtCollectionPathOfElements: (NSString *)path
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (id object in self)
    {
        [array addObjectOrNil: [object objectOrNilAtCollectionPath: path]];
    }
    
    return [NSArray arrayWithArray: array];
}

- (NSMutableSet *)deepMutableCopy NS_RETURNS_RETAINED
{

    NSMutableSet *set = [NSMutableSet set];
    for (id object in self)
    {
        if ([object isKindOfClass: [NSArray class]])
        {
            [set addObject: [[object deepMutableCopy] autorelease]];
        }
        else if ([object isKindOfClass: [NSDictionary class]])
        {
            [set addObject: [[object deepMutableCopy] autorelease]];
        }
        else if ([object isKindOfClass: [NSSet class]])
        {
            [set addObject: [[object deepMutableCopy] autorelease]];
        }
        else
        {
            [set addObject: object];
        }
    }

    return [set retain];

}

@end
