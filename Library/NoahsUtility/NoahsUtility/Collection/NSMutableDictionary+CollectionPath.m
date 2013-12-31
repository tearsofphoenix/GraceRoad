//
//  NSMutableDictionary+CollectionPath.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/19/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSMutableDictionary+CollectionPath.h"

#import "NSDictionary+NSNull.h"

#import "NSMutableDictionary+NSNull.h"

@implementation NSMutableDictionary (CollectionPath)

- (void)   setObjectOrNil: (id)object
         atCollectionPath: (NSString *)path
{
    
    NSArray *components = [path componentsSeparatedByString: @"/"];
    if ([components count] > 0)
    {
        
        NSString *key = [components objectAtIndex: 0];
         
        if ([components count] == 1)
        {
            [self setObjectOrNil: object forKey: key];
        }
        else
        {
            
            id subobject = [self objectOrNilForKey: key];
            
            if (!subobject)
            {
                
                subobject = [NSMutableDictionary dictionary];
                
                [self setObjectOrNil: subobject forKey: key];
                
            }
            
            [subobject setObjectOrNil: object
                     atCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];

        }
              
    }
    
}

@end
