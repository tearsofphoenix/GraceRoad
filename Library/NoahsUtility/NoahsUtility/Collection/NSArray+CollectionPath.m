//
//  NSArray+CollectionPath.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 2/27/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+CollectionPath.h"

#import "NSArray+NSNull.h"

#import "NSMutableArray+NSNull.h"

@implementation NSArray(CollectionPath)

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
        if ([key characterAtIndex: 0] != '?')
        {
            
            NSInteger index = [[components objectAtIndex: 0] integerValue];

            if (index < [self count])
            {
                
                id subobject = [self objectOrNilAtIndex: index];
                
                if ([components count] == 1)
                {
                    return subobject;
                }
                else
                {
                    return [subobject objectOrNilAtCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
                }
                
            }
            else
            {
                return nil;
            }
            
        }
        else
        {
            
            if ([key isEqualToString: @"?count"])
            {
                return [NSNumber numberWithInteger: [self count]];
            }
            else if ([key isEqualToString: @"?any.object"])
            {
                if ([self count] > 0)
                {
                    return [self objectAtIndex: 0];
                }
                else
                {
                    return nil;
                }
            }
            else if ([key isEqualToString: @"?first.object"])
            {
                if ([self count] > 0)
                {
                    return [self objectAtIndex: 0];
                }
                else
                {
                    return nil;
                }
            }
            else if ([key isEqualToString: @"?last.object"])
            {
                return [self lastObject];
            }
            else if ([key isEqualToString: @"?as.array"])
            {
                return self;
            }
            else if ([key isEqualToString: @"?as.set"])
            {
                return [NSSet setWithArray: self];
            }
            else
            {
                return nil;
            }

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

- (NSMutableArray *)deepMutableCopy NS_RETURNS_RETAINED
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self)
    {
        if ([object isKindOfClass: [NSArray class]])
        {
            [array addObjectOrNil: [[object deepMutableCopy] autorelease]];
        }
        else if ([object isKindOfClass: [NSDictionary class]])
        {
            [array addObjectOrNil: [[object deepMutableCopy] autorelease]];
        }
        else if ([object isKindOfClass: [NSSet class]])
        {
            [array addObjectOrNil: [[object deepMutableCopy] autorelease]];
        }
        else
        {
            [array addObjectOrNil: object];
        }
    }

    return [array retain];
}

@end
