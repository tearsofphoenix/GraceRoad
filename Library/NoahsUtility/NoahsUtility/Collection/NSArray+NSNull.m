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

#import "NSArray+NSNull.h"

@implementation NSArray(NSNull)

+ (NSArray *)arrayWithCount: (NSUInteger)count
              objectsOrNils: (id)object, ...
{
    
    id *objects = (id *)calloc(count, sizeof(id));
    
    va_list argumentList;
    va_start(argumentList, object);
    
    id currentObject = object;
    NSUInteger looper = 0;
    while (looper < count)
    {
        
        if (currentObject)
        {
            objects[looper] = currentObject;
        }
        else 
        {
            objects[looper] = [NSNull null];
        }
        
        currentObject = va_arg(argumentList, id);
        
        ++looper;
    }
    
    va_end(argumentList);    
    
    NSArray *result = [self arrayWithObjects: objects count: count];
    
    free(objects);
    
    return result;
    
}

+ (NSArray *)arrayWithObjectOrNil: (id)object
{
    
    if (!object)
    {
        object = [NSNull null];
    }
    
    return [NSArray arrayWithObject: object];
}

- (id)objectOrNilAtIndex: (NSUInteger)index
{
    
    if (index < [self count])
    {
        
        id object = [self objectAtIndex: index];
        if ([object isKindOfClass: [NSNull class]])
        {
            object = nil;
        }
        
        return object;
        
    }
    else
    {
        return nil;
    }
    
}

@end
