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

#import "NSDate+Formatting.h"

#import <NoahsService/NoahsService.h>

#import "NSArray+NSNull.h"

static char *itoa(int value, char* result, int base)
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

static char *fill_integer_string(int value, char *buffer, int length, char filling_character)
{
    
    char string[32] = {0};
    
    itoa(value, string, 10);
    
    int string_length = strlen(string);
    int looper = 0;
    while (string_length + looper < length)
    {
        
        *buffer = filling_character;
        
        ++buffer;
        ++looper;
    }
    
    strncpy(buffer, string, length - looper);
    
    return buffer + length - looper;
}

static NSString *createLocalDateString(NSDate *self)
{
    
    char string[28] = {0};
    
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    time_t time = (time_t)timeInterval;
    struct tm timeStructure = *localtime(&time);
    
    char *looper = string;
    
    looper = fill_integer_string(timeStructure.tm_year + 1900, looper, 4, '0');
    *looper = '-';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_mon + 1, looper, 2, '0');
    *looper = '-';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_mday, looper, 2, '0');
    *looper = ' ';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_hour, looper, 2, '0');
    *looper = ':';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_min, looper, 2, '0');
    *looper = ':';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_sec, looper, 2, '0');
    *looper = '.';
    ++looper;
    
    looper = fill_integer_string(((NSUInteger)((timeInterval - floor(timeInterval)) * 1000000)) % 1000000, looper, 6, '0');
    
    *looper = '\0';
    
    return [[[NSString alloc] initWithBytes: string
                                     length: strlen(string)
                                   encoding: NSUTF8StringEncoding] autorelease];
}

static NSString *createUTCDateString(NSDate *self)
{
    
    char string[28] = {0};
    
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    time_t time = (time_t)timeInterval;
    struct tm timeStructure = *gmtime(&time);
    
    char *looper = string;
    
    looper = fill_integer_string(timeStructure.tm_year + 1900, looper, 4, '0');
    *looper = '-';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_mon + 1, looper, 2, '0');
    *looper = '-';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_mday, looper, 2, '0');
    *looper = ' ';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_hour, looper, 2, '0');
    *looper = ':';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_min, looper, 2, '0');
    *looper = ':';
    ++looper;
    
    looper = fill_integer_string(timeStructure.tm_sec, looper, 2, '0');
    *looper = '.';
    ++looper;
    
    looper = fill_integer_string(((NSUInteger)((timeInterval - floor(timeInterval)) * 1000000)) % 1000000, looper, 6, '0');

    *looper = '\0';

    return [[[NSString alloc] initWithBytes: string
                                     length: strlen(string)
                                   encoding: NSUTF8StringEncoding] autorelease];
}

@implementation NSDate(Formatting)

+ (NSDate *)dateFromString: (NSString *)string
{
    
    NSDate *date = [self dateFromString: string withFormat: @"yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSSSSS"];
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSS"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"yyyy'-'MM'-'dd' 'HH':'mm"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"yyyy'-'MM'-'dd"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"HH':'mm':'ss"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"yyyy'-'MM"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"MM'-'dd"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"HH':'mm"];
    }
    
    if (!date)
    {
        date = [self dateFromString: string withFormat: @"yyyy"];
    }
    
    return date;
}

+ (NSDate *)dateFromString: (NSString *)string withFormat: (NSString *)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale: [NSLocale currentLocale]];
    [formatter setDateFormat: format];
    
    NSDate *date = [formatter dateFromString: string];
    
    [formatter release];
    
    return date;
    
}

+ (NSDate *)dateFromString: (NSString *)string withFormatForUTC: (NSString *)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale: [NSLocale currentLocale]];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName: @"UTC"]];
    [formatter setDateFormat: format];
    
    NSDate *date = [formatter dateFromString: string];
    
    [formatter release];
    
    return date;
    
}

- (NSString *)stringWithFormat: (NSString *)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setLocale: [NSLocale currentLocale]];
    [formatter setDateFormat: format];
    
    NSString *string = [formatter stringFromDate: self];
    
    [formatter release];
    
    return string;
    
}

- (NSString *)stringDescriptionForUTC
{
    return createUTCDateString(self);
}

- (NSString *)stringDescriptionForLocal
{
    return createLocalDateString(self);
}

- (NSString *)stringWithFormatForUTC: (NSString *)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale: [NSLocale currentLocale]];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName: @"UTC"]];
    [formatter setDateFormat: format];
    
    NSString *string = [formatter stringFromDate: self];
    
    [formatter release];
    
    return string;
    
}

- (NSString *)stringWithFormatTemplate: (NSString *)formatTemplate
{
    return [self stringWithFormat: [NSDateFormatter dateFormatFromTemplate: formatTemplate
                                                                   options: 0
                                                                    locale: [NSLocale currentLocale]]];
}

- (NSString *)autolocalizedStringWithFormatTemplate: (NSString *)formatTemplate
{
    return [self stringWithFormat: [NSDateFormatter dateFormatFromTemplate: formatTemplate
                                                                   options: 0
                                                                    locale: ERSSC(ERLocaleServiceIdentifier,
                                                                                  ERLocaleServiceCurrentNSLocaleAction,
                                                                                  nil)]];
}

- (NSString *)humanReadableDescriptionUsingAbbreviation: (BOOL)usingAbbreviation
{
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceHumanReadableDescriptionForDate_UsingAbbreviation_Action,
                 [NSArray arrayWithCount: 2
                           objectsOrNils:
                  self,
                  [NSNumber numberWithBool: usingAbbreviation]]);
}


@end
