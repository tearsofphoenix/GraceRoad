//
//  NSMutableArray+NSNull.m
//  NoahsUtility
//
// EREACH CONFIDENTIAL
// 
// [2011] eReach Mobile Software Technology Co., Ltd.
// All Rights Reserved.
//
// NOTICE:  All information contained herein is, and remains the
// property of eReach Mobile Software Technology and its suppliers,
// if any.  The intellectual and technical concepts contained herein
// are proprietary to eReach Mobile Software Technology and its
// suppliers and may be covered by U.S. and Foreign Patents, patents
// in process, and are protected by trade secret or copyright law.
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained
// from eReach Mobile Software Technology Co., Ltd.
//

#import "NSMutableArray+NSNull.h"

@implementation NSMutableArray(NSNull)

- (void)replaceObjectAtIndex: (NSUInteger)index withObjectOrNil: (id)object
{
    
    if (!object)
    {
        object = [NSNull null];
    }
    
    [self replaceObjectAtIndex: index withObject: object];
    
}

- (void)addObjectOrNil: (id)object
{
    
    if (!object)
    {
        object = [NSNull null];
    }
    
    [self addObject: object];
    
}

- (void)insertObjectOrNil: (id)object atIndex:(NSUInteger)index
{
    
    if (!object)
    {
        object = [NSNull null];
    }
    
    [self insertObject: object atIndex: index];
    
}

- (void)setObjectOrNil: (id)object atIndex: (NSUInteger)index
{
    
    while ([self count] <= index)
    {
        [self addObjectOrNil: nil];
    }
    
    [self replaceObjectAtIndex: index withObject: object];
    
}

- (void)setObject: (id)object
          atIndex: (NSUInteger)index
{
    
    while ([self count] <= index)
    {
        [self addObjectOrNil: nil];
    }

    [self replaceObjectAtIndex: index withObject: object];

}

@end
