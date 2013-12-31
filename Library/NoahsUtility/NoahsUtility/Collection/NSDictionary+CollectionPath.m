//
//  NSDictionary+CollectionPath.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 2/27/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+CollectionPath.h"

#import "NSDictionary+NSNull.h"

@implementation NSDictionary (CollectionPath)

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
        
        id subobject = [self objectOrNilForKey: key];
        
        if (subobject)
        {
            
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
            
            if ([key isEqualToString: @"?count"])
            {
                return [NSNumber numberWithInteger: [self count]];
            }
            else if ([key isEqualToString: @"?keys"])
            {
                return [self allKeys];
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

- (NSMutableDictionary *)deepMutableCopy NS_RETURNS_RETAINED
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (id key in self)
    {

        id object = [self objectForKey: key];
        
        if ([object isKindOfClass: [NSArray class]])
        {
            [dictionary setObject: [[object deepMutableCopy] autorelease]
                           forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]])
        {
            [dictionary setObject: [[object deepMutableCopy] autorelease]
                           forKey: key];
        }
        else if ([object isKindOfClass: [NSSet class]])
        {
            [dictionary setObject: [[object deepMutableCopy] autorelease]
                           forKey: key];
        }
        else
        {
            [dictionary setObject: object
                           forKey: key];
        }
        
    }

    return [dictionary retain];
}

- (void)   setObjectOrNil: (id)object
         atCollectionPath: (NSString *)path
{
    
    NSArray *components = [path componentsSeparatedByString: @"/"];
    if ([components count] > 0)
    {
        
        NSString *key = [components objectAtIndex: 0];
        
        if ([components count] == 1)
        {
            // Do nothing
        }
        else
        {
            
            id subobject = [self objectOrNilForKey: key];
            if (subobject)
            {
                [subobject setObjectOrNil: object
                         atCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
            }
            
        }
        
    }
    
}

@end
