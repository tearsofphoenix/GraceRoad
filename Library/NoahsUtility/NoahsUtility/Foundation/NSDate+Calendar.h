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

#import <Foundation/Foundation.h>

typedef enum
{
    ERSunday = 1,
    ERMonday,
    ERTuesday,
    ERWednesday,
    ERThursday,
    ERFriday,
    ERSaturday
} ERWeekDay;

@interface NSDate(Calendar)

+ (NSDate *)dateWithYear: (NSInteger)year 
                   month: (NSInteger)month 
                     day: (NSInteger)day;

+ (NSDate *)dateWithYear: (NSInteger)year 
                   month: (NSInteger)month 
                     day: (NSInteger)day
                    hour: (NSInteger)hour
                  minute: (NSInteger)minute
                  second: (NSInteger)second
             millisecond: (NSInteger)millisecond;

+ (NSDate *)dateForUTCWithYear: (NSInteger)year 
                         month: (NSInteger)month 
                           day: (NSInteger)day;

+ (NSDate *)dateForUTCWithYear: (NSInteger)year 
                         month: (NSInteger)month 
                           day: (NSInteger)day
                          hour: (NSInteger)hour
                        minute: (NSInteger)minute
                        second: (NSInteger)second
                   millisecond: (NSInteger)millisecond;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)millisecond;
- (NSInteger)microsecond;

- (ERWeekDay)weekDay;

- (NSInteger)UTCYear;
- (NSInteger)UTCMonth;
- (NSInteger)UTCDay;
- (NSInteger)UTCHour;
- (NSInteger)UTCMinute;
- (NSInteger)UTCSecond;
- (NSInteger)UTCMillisecond;
- (NSInteger)UTCMicrosecond;

- (ERWeekDay)UTCWeekDay;

- (NSDate *)previousDate;

- (NSDate *)nextDate;

- (BOOL)isTheSameDayAs: (NSDate *)day;

- (BOOL)isInScopeOfDate: (NSDate *)date
         withInDayRange: (NSRange)dayRange;

- (NSDate *)nextAnniversaryAtMonth: (NSInteger)month
                               day: (NSInteger)day;

- (NSDate *)nextAnniversaryForDate: (NSDate *)date;

- (NSDate *)previousAnniversaryAtMonth: (NSInteger)month
                                   day: (NSInteger)day;

- (NSDate *)previousAnniversaryForDate: (NSDate *)date;

- (NSDate *)mostCloseAnniversaryAtMonth: (NSInteger)month
                                    day: (NSInteger)day;

- (NSDate *)mostCloseAnniversaryForDate: (NSDate *)date;

@end
