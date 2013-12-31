//
//  NSString+DictionaryDescription.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/18/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+DictionaryDescription.h"

#import "NSMutableDictionary+NSNull.h"

#import "NSDictionary+NSNull.h"

#import "NSString+Quotation.h"

static char *ERStringConvertIntoText(int value, char* result, int base)
{

    // Check that the base if valid

    if ((base < 2) || (base > 36))
    {

        *result = '\0';

        return result;
    }

    char *pointer = result;
    char *pointer2 = result;
    char character;
    int temporary_value;

    do
    {

        temporary_value = value;

        value /= base;

        *pointer++ = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz"[35 + (temporary_value - value * base)];

    }
    while (value);

    // Apply negative sign

    if (temporary_value < 0)
    {
        *pointer++ = '-';
    }

    *pointer-- = '\0';

    while(pointer2 < pointer)
    {

        character = *pointer;

        *pointer-- = *pointer2;
        
        *pointer2++ = character;
        
    }
    
    return result;
}

@implementation NSString (DictionaryDescription)

+ (NSString *)descriptionForKeysAndObjectsOrNils: (id)firstKey, ... NS_REQUIRES_NIL_TERMINATION
{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    va_list argumentList;
    va_start(argumentList, firstKey);
    
    id currentKey = firstKey;
    while (currentKey)
    {
        
        id finalKey = currentKey;
        
        id finalValue = va_arg(argumentList, id);
        
        [dictionary setObjectOrNil: finalValue
                            forKey: finalKey];
        
        currentKey = va_arg(argumentList, id);
        
    }
    
    va_end(argumentList);
    
    return [dictionary description];
    
}

+ (NSString *)descriptionForOrderedObjects: (id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{

    NSMutableArray *array = [NSMutableArray array];

    va_list argumentList;
    va_start(argumentList, firstObject);

    id currentObject = firstObject;
    while (currentObject)
    {

        [array addObject: currentObject];

        currentObject = va_arg(argumentList, id);

    }

    va_end(argumentList);
    
    NSString *description = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject: array
                                                                                            options: 0
                                                                                              error: NULL]
                                                  encoding: NSUTF8StringEncoding];
    
    return [description autorelease];

}

+ (NSString *)descriptionForPointer: (void *)pointer
{

    long long value = (long long)pointer;

    char bytes[32];

    ERStringConvertIntoText(value, bytes, 10);
    
    return [NSString stringWithUTF8String: bytes];

}

@end
