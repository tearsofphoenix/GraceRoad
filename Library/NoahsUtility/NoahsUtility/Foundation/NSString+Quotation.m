//
//  NSString+Quotation.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/20/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+Quotation.h"

@implementation NSString (Quotation)

- (NSString *)stringByEscapingQuotations
{
    
    const char *UTF8Input = [self UTF8String];
    
    char *UTF8Output = (char *)calloc((strlen(UTF8Input) << 1) + 1, sizeof(char));
    
    char charactor, *outputCharacter = UTF8Output;
    
    while ((charactor = *UTF8Input++))
    {
        
        if ((charactor == '\'') || (charactor == '\'') || (charactor == '\\') || (charactor == '"'))
        {
            *outputCharacter++ = '\\';
            *outputCharacter++ = charactor;
        }
        else
        {
            *outputCharacter++ = charactor;
        }
        
    }
    
    NSString *output = [NSString stringWithUTF8String: UTF8Output];
    
    free(UTF8Output);
    
    return output;
}

@end
