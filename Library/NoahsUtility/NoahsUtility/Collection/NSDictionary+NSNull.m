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

#import "NSDictionary+NSNull.h"

@implementation NSDictionary(NSNull)

+ (id)dictionaryWithKey: (id)key objectOrNil: (id)object
{
    
    if (!object)
    {
        object = [NSNull null];
    }
    
    return [self dictionaryWithObject: object forKey: key];
}

+ (id)dictionaryWithKeysAndObjectsOrNils: (id)firstKey, ...
{

    va_list argumentList;
    va_start(argumentList, firstKey);

    id currentKey = firstKey;
    NSUInteger count = 0;
    while (currentKey)
    {
        
        va_arg(argumentList, id);
        
        currentKey = va_arg(argumentList, id);
    
        ++count;
    }

    va_end(argumentList);

    if (count)
    {
        
        id *keys = calloc(count, sizeof(id));
        id *objects = calloc(count, sizeof(id));
        
        va_start(argumentList, firstKey);
        
        currentKey = firstKey;
        NSUInteger looper = 0;
        while (currentKey)
        {
            
            keys[looper] = currentKey;
            
            objects[looper] = va_arg(argumentList, id);
            if (!objects[looper])
            {
                objects[looper] = [NSNull null];
            }
            
            currentKey = va_arg(argumentList, id);
            
            ++looper;
        }
        
        va_end(argumentList);
        
        NSDictionary *result = [self dictionaryWithObjects: objects
                                                   forKeys: keys
                                                     count: count];
        
        free(keys);
        free(objects);
        
        return result;
        
    }
    else
    {
        return [self dictionary];
    }

}

- (id)objectOrNilForKey: (id)key
{
    
    if (!key)
    {
        key = [NSNull null];
    }
    
    id object = [self objectForKey: key];
    if ([object isKindOfClass: [NSNull class]])
    {
        return nil;
    }
    else 
    {
        return object;
    }
    
}

@end
