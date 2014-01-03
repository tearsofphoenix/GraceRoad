//
//  NSObject+CollectionPath.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/9/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSObject+CollectionPath.h"

#import "ERPM.h"

@implementation NSObject(CollectionPath)

- (id)objectOrNilAtCollectionPath: (NSString *)collectionPath
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
//    if (!collectionPath)
//    {
//        return self;
//    }
//
//    NSArray *components = [collectionPath componentsSeparatedByString: @"/"];
//    if ([components count] > 0)
//    {
//
//        NSString *identifier = [components objectAtIndex: 0];
//
//        id subobject = [self performSelector: @selector(serialiseableSubobjectWithRelativeIdentifier:) withObject: identifier];
//
//        if (subobject)
//        {
//
//            if ([components count] == 1)
//            {
//                return subobject;
//            }
//            else
//            {
//                return [subobject objectOrNilAtCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
//            }
//
//        }
//        else
//        {
//
//            if ([identifier hasPrefix: @"!"])
//            {
//                subobject = [self performSelector: NSSelectorFromString([identifier substringFromIndex: 1])];
//            }
//            else if ([identifier hasPrefix: @"?"])
//            {
//
//                __block id result = nil;
//                ERPM(^(void)
//                     {
//                         result = [[self performSelector: NSSelectorFromString([identifier substringFromIndex: 1])] retain];
//                     });
//
//                subobject = [result autorelease];
//
//            }
//
//            if (subobject)
//            {
//
//                if ([components count] == 1)
//                {
//                    return subobject;
//                }
//                else
//                {
//                    return [subobject objectOrNilAtCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
//                }
//                
//            }
//            else
//            {
//                return nil;
//            }
//
//        }
//
//    }
//    else
//    {
//        return nil;
//    }

}

- (void)setObjectOrNil: (id)objectOrNil
      atCollectionPath: (NSString *)collectionPath
{
    [self doesNotRecognizeSelector: _cmd];
    
//    NSArray *components = [collectionPath componentsSeparatedByString: @"/"];
//    if ([components count] > 0)
//    {
//
//        NSString *identifier = [components objectAtIndex: 0];
//
//        if ([components count] == 1)
//        {
//
//            if ([identifier hasPrefix: @"!"])
//            {
//                [self performSelector: NSSelectorFromString([identifier substringFromIndex: 1])
//                           withObject: objectOrNil];
//            }
//            else if ([identifier hasPrefix: @"?"])
//            {
//                [self performSelectorOnMainThread: NSSelectorFromString([identifier substringFromIndex: 1])
//                                       withObject: objectOrNil
//                                    waitUntilDone: YES];
//            }
//
//        }
//        else
//        {
//
//            id subobject = [self performSelector: @selector(serialiseableSubobjectWithRelativeIdentifier:) withObject: identifier];
//            if (!subobject)
//            {
//
//                if ([identifier hasPrefix: @"!"])
//                {
//                    subobject = [self performSelector: NSSelectorFromString([identifier substringFromIndex: 1])];
//                }
//                else if ([identifier hasPrefix: @"?"])
//                {
//
//                    __block id result = nil;
//                    ERPM(^(void)
//                         {
//                             result = [[self performSelector: NSSelectorFromString([identifier substringFromIndex: 1])] retain];
//                         });
//                    
//                    subobject = [result autorelease];
//                    
//                }
//
//            }
//
//            if (subobject)
//            {
//                [subobject setObjectOrNil: objectOrNil
//                         atCollectionPath: [[components subarrayWithRange: NSMakeRange(1, [components count] - 1)] componentsJoinedByString: @"/"]];
//            }
//            
//        }
//        
//    }
    
}

@end
