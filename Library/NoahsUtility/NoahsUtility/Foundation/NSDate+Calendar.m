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

#import "NSDate+Calendar.h"

#import <objc/runtime.h>

#define ERSecondsInOneDay 24 * 60 * 60

static char ERUtilityDateYearKey;
static char ERUtilityDateMonthKey;
static char ERUtilityDateDayKey;
static char ERUtilityDateWeekdayKey;
static char ERUtilityDateHourKey;
static char ERUtilityDateMinuteKey;
static char ERUtilityDateSecondKey;

static char ERUtilityDateUTCYearKey;
static char ERUtilityDateUTCMonthKey;
static char ERUtilityDateUTCDayKey;
static char ERUtilityDateUTCWeekdayKey;
static char ERUtilityDateUTCHourKey;
static char ERUtilityDateUTCMinuteKey;
static char ERUtilityDateUTCSecondKey;

static void ERUtilityDateInitializeComponent(NSDate *date)
{
    
    NSNumber *year = objc_getAssociatedObject(date, &ERUtilityDateYearKey);
    if (!year)
    {

        time_t currentTime = [date timeIntervalSince1970];
        struct tm timeStructure = *localtime(&currentTime);

        objc_setAssociatedObject(date, &ERUtilityDateYearKey, [NSNumber numberWithInteger: timeStructure.tm_year + 1900], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateMonthKey, [NSNumber numberWithInteger: timeStructure.tm_mon + 1], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateDayKey, [NSNumber numberWithInteger: timeStructure.tm_mday], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateHourKey, [NSNumber numberWithInteger: timeStructure.tm_hour], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateMinuteKey, [NSNumber numberWithInteger: timeStructure.tm_min], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateSecondKey, [NSNumber numberWithInteger: timeStructure.tm_sec], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }
    
}

static void ERUtilityDateInitializeUTCComponent(NSDate *date)
{
    
    NSNumber *UTCYear = objc_getAssociatedObject(date, &ERUtilityDateYearKey);
    if (!UTCYear)
    {

        time_t currentTime = [date timeIntervalSince1970];
        struct tm timeStructure = *gmtime(&currentTime);

        objc_setAssociatedObject(date, &ERUtilityDateYearKey, [NSNumber numberWithInteger: timeStructure.tm_year + 1900], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateMonthKey, [NSNumber numberWithInteger: timeStructure.tm_mon + 1], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateDayKey, [NSNumber numberWithInteger: timeStructure.tm_mday], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateHourKey, [NSNumber numberWithInteger: timeStructure.tm_hour], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateMinuteKey, [NSNumber numberWithInteger: timeStructure.tm_min], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(date, &ERUtilityDateSecondKey, [NSNumber numberWithInteger: timeStructure.tm_sec], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        
    }
    
}

@implementation NSDate(Calendar)

+ (NSDate *)dateWithYear: (NSInteger)year 
                   month: (NSInteger)month 
                     day: (NSInteger)day
{
    return [self dateWithYear: year
                        month: month 
                          day: day 
                         hour: 0 
                       minute: 0
                       second: 0 
                  millisecond: 0];    
}

+ (NSDate *)dateWithYear: (NSInteger)year 
                   month: (NSInteger)month 
                     day: (NSInteger)day
                    hour: (NSInteger)hour
                  minute: (NSInteger)minute
                  second: (NSInteger)second
             millisecond: (NSInteger)millisecond
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear: year];
    [components setMonth: month];
    [components setDay: day];
    [components setHour: hour];
    [components setMinute: minute];
    [components setSecond: second];
    
    NSDate *date = [calendar dateFromComponents: components];
    
    [components release];
    
    return [NSDate dateWithTimeIntervalSince1970: [date timeIntervalSince1970] + (millisecond / 1000.0)];
}

+ (NSDate *)dateForUTCWithYear: (NSInteger)year 
                         month: (NSInteger)month 
                           day: (NSInteger)day
{
    return [self dateForUTCWithYear: year
                              month: month 
                                day: day 
                               hour: 0 
                             minute: 0
                             second: 0 
                        millisecond: 0]; 
}

+ (NSDate *)dateForUTCWithYear: (NSInteger)year 
                         month: (NSInteger)month 
                           day: (NSInteger)day
                          hour: (NSInteger)hour
                        minute: (NSInteger)minute
                        second: (NSInteger)second
                   millisecond: (NSInteger)millisecond
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear: year];
    [components setMonth: month];
    [components setDay: day];
    [components setHour: hour];
    [components setMinute: minute];
    [components setSecond: second];
    
    NSDate *date = [calendar dateFromComponents: components];
    
    [calendar release];
    
    [components release];
    
    return [NSDate dateWithTimeIntervalSince1970: [date timeIntervalSince1970] + (millisecond / 1000.0)];
    
}

- (NSInteger)year
{

    ERUtilityDateInitializeComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateYearKey) integerValue];
    
}

- (NSInteger)month
{
    
    ERUtilityDateInitializeComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateMonthKey) integerValue];

}

- (NSInteger)day
{
    
    ERUtilityDateInitializeComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateDayKey) integerValue];

}

- (ERWeekDay)weekDay
{

    NSNumber *weekDay = objc_getAssociatedObject(self, &ERUtilityDateWeekdayKey);
    if (!weekDay)
    {

        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];

        [calendar setTimeZone: [[NSLocale currentLocale] timeZone]];

        NSDateComponents *dateComponents = [calendar components: NSWeekdayCalendarUnit
                                                       fromDate: self];

        weekDay = [NSNumber numberWithInteger: [dateComponents weekday]];

        objc_setAssociatedObject(self, &ERUtilityDateWeekdayKey, weekDay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [calendar release];

    }

    return [weekDay integerValue];

    ERUtilityDateInitializeComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateWeekdayKey) integerValue];
    
}

- (NSInteger)hour
{
    
    ERUtilityDateInitializeComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateHourKey) integerValue];
    
}

- (NSInteger)minute
{
    
    ERUtilityDateInitializeComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateMinuteKey) integerValue];
    
}

- (NSInteger)second
{
    
    ERUtilityDateInitializeComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateSecondKey) integerValue];
    
}

- (NSInteger)millisecond
{
    return ((NSUInteger)([self timeIntervalSince1970] * 1000)) % 1000;
}

- (NSInteger)microsecond
{
    return ((NSUInteger)([self timeIntervalSince1970] * 1000000)) % 1000;
}

- (NSInteger)UTCYear
{
    
    ERUtilityDateInitializeUTCComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateUTCYearKey) integerValue];
    
}

- (NSInteger)UTCMonth
{
    
    ERUtilityDateInitializeUTCComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateUTCMonthKey) integerValue];
    
}

- (NSInteger)UTCDay
{
    
    ERUtilityDateInitializeUTCComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateUTCDayKey) integerValue];
    
}

- (NSInteger)UTCHour
{
    
    ERUtilityDateInitializeUTCComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateUTCHourKey) integerValue];
    
}

- (NSInteger)UTCMinute
{
    
    ERUtilityDateInitializeUTCComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateUTCMinuteKey) integerValue];
    
}

- (NSInteger)UTCSecond
{
    
    ERUtilityDateInitializeUTCComponent(self);
    
    return [objc_getAssociatedObject(self, &ERUtilityDateUTCSecondKey) integerValue];
    
}

- (NSInteger)UTCMillisecond
{
    return [self millisecond];
}

- (NSInteger)UTCMicrosecond
{
    return [self microsecond];
}

- (ERWeekDay)UTCWeekDay
{

    NSNumber *weekDay = objc_getAssociatedObject(self, &ERUtilityDateUTCWeekdayKey);
    if (!weekDay)
    {
            
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];

        [calendar setTimeZone: [NSTimeZone timeZoneWithName: @"UTC"]];

        NSDateComponents *dateComponents = [calendar components: NSWeekdayCalendarUnit
                                                       fromDate: self];

        weekDay = [NSNumber numberWithInteger: [dateComponents weekday]];
        
        objc_setAssociatedObject(self, &ERUtilityDateUTCWeekdayKey, weekDay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [calendar release];

    }
    
    return [weekDay integerValue];

}

- (NSDate *)previousDate
{
    return [NSDate dateWithTimeIntervalSince1970: [self timeIntervalSince1970] - 24 * 3600];
}

- (NSDate *)nextDate;
{
    return [NSDate dateWithTimeIntervalSince1970: [self timeIntervalSince1970] + 24 * 3600];
}

- (BOOL)isTheSameDayAs: (NSDate *)day
{
    return ([self year] == [day year]) && 
        ([self month] == [day month]) && 
        ([self day] == [day day]);
}

- (BOOL)isInScopeOfDate: (NSDate *)date
         withInDayRange: (NSRange)dayRange
{
    
    NSTimeInterval selfInterval = [self timeIntervalSince1970];
    NSTimeInterval dateInterval = [[NSDate dateWithYear: [date year]
                                                  month: [date month]
                                                    day: [date day]] timeIntervalSince1970];
    
    return ((selfInterval >= dateInterval + dayRange.location * ERSecondsInOneDay) && 
            (selfInterval < dateInterval + (dayRange.location + dayRange.length) * ERSecondsInOneDay));
    
}

- (NSDate *)nextAnniversaryAtMonth: (NSInteger)month
                               day: (NSInteger)day
{
    
    NSDate *nextAnniversary = [NSDate dateWithYear: [self year]
                                             month: month
                                               day: day];
    if ([nextAnniversary timeIntervalSince1970] <= [self timeIntervalSince1970])
    {
        nextAnniversary = [NSDate dateWithYear: [self year] + 1
                                         month: month
                                           day: day];
    }
    
    return nextAnniversary;
    
}

- (NSDate *)nextAnniversaryForDate: (NSDate *)date
{
    return [self nextAnniversaryAtMonth: [date month]
                                    day: [date day]];
}

- (NSDate *)previousAnniversaryAtMonth: (NSInteger)month
                                   day: (NSInteger)day
{
    
    NSDate *previousAnniversary = [NSDate dateWithYear: [self year]
                                                 month: month
                                                   day: day];
    if ([previousAnniversary timeIntervalSince1970] > [self timeIntervalSince1970])
    {
        previousAnniversary = [NSDate dateWithYear: [self year] - 1
                                             month: month
                                               day: day];
    }
    
    return previousAnniversary;
    
}

- (NSDate *)previousAnniversaryForDate: (NSDate *)date
{
    return [self previousAnniversaryAtMonth: [date month]
                                        day: [date day]];
}

- (NSDate *)mostCloseAnniversaryAtMonth: (NSInteger)month
                                    day: (NSInteger)day
{
    
    NSDate *nextAnniversary = [self nextAnniversaryAtMonth: month day: day];
    NSDate *previousAnniversary = [self previousAnniversaryAtMonth: month day: day];
    
    if (([self timeIntervalSince1970] - [previousAnniversary timeIntervalSince1970]) <
        ([nextAnniversary timeIntervalSince1970] - [self timeIntervalSince1970]))
    {
        return previousAnniversary;
    }
    else 
    {
        return nextAnniversary;
    }
    
}

- (NSDate *)mostCloseAnniversaryForDate: (NSDate *)date
{
    return [self mostCloseAnniversaryAtMonth: [date month]
                                         day: [date day]];
}

@end
