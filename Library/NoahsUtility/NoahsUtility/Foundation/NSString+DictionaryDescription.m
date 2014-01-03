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
    return [NSString stringWithFormat: @"%p", pointer];
}

@end
