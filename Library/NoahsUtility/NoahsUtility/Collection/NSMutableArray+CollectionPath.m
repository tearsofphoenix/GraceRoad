//
//  NSMutableArray+CollectionPath.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSMutableArray+CollectionPath.h"

#import "NSArray+NSNull.h"
#import "NSMutableArray+NSNull.h"

@implementation NSMutableArray (CollectionPath)

- (void)   setObjectOrNil: (id)object
         atCollectionPath: (NSString *)path
{
    
    NSArray *components = [path componentsSeparatedByString: @"/"];
    if ([components count] > 0)
    {
        
        NSString *key = [components objectAtIndex: 0];
        if ([key characterAtIndex: 0] != '?')
        {
            
            NSInteger index = [[components objectAtIndex: 0] integerValue];
            
            if ([components count] == 1)
            {
                
                [self setObjectOrNil: object atIndex: index];
                
            }
            else
            {
                
                id subobject = [self objectOrNilAtIndex: index];
                
                if (!subobject)
                {
                    
                    subobject = [NSMutableDictionary dictionary];
                    
                    [self setObjectOrNil: subobject atIndex: index];
                    
                }
                
                [subobject setObjectOrNil: object
                         atCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
                
            }
            
        }
        else
        {
            
            if ([key isEqualToString: @"?push.object"])
            {
                
                if ([components count] == 1)
                {
                    
                    if (object)
                    {
                        [self addObject: object];
                    }
                    else
                    {
                        [self addObject: [NSNull null]];
                    }
                    
                }
                else
                {
                    
                    id subobject = [NSMutableDictionary dictionary];
                    
                    [self addObject: subobject];
                    
                    [subobject setObjectOrNil: object
                             atCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
                    
                }
                
            }
            else if ([key isEqualToString: @"?unshift.object"])
            {
                
                if ([components count] == 1)
                {
                    
                    if (object)
                    {
                        [self insertObject: object atIndex: 0];
                    }
                    else
                    {
                        [self insertObject: [NSNull null] atIndex: 0];
                    }
                    
                }
                else
                {
                    
                    id subobject = [NSMutableDictionary dictionary];
                    
                    [self insertObject: subobject atIndex: 0];
                    
                    [subobject setObjectOrNil: object
                             atCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
                    
                }
                
            }
            
        }
        
    }
    
}

@end
