//
//  NSArray+ObjectSharing.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/14/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSArray+ObjectSharing.h"

@implementation NSArray (ObjectSharing)

- (BOOL)containsObjectHasValue: (id)value
                    atCollectionPath: (NSString *)collectionPath
{

    for (id object in self)
    {

        id sourceValue = [object objectOrNilAtCollectionPath: collectionPath];
        if ([sourceValue isEqual: value] || ((!sourceValue) && (!value)))
        {
            return YES;
        }

    }

    return NO;
}

@end
