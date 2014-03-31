//
//  GRConfiguration.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-20.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRConfiguration.h"
#import <NoahsUtility/NoahsUtility.h>

#define GRSecondsPerDay (60 * 60 * 24)
#define GRSecondsPerWeek (GRSecondsPerDay * 7)


#if 1
#define GRServerDomain      @"http://www.xn--6oq90d37vryemman3g2vm.com"
#else
#define GRServerDomain      @"http://www.tearsofphoenix.com"
#endif

#define GRServerMessageURLString        GRServerDomain "/system/dispatch.php"
#define GRFileURLString                 GRServerDomain "/system/files/"

static void __CreateDateFormatterIfNeeded(void);

@implementation GRConfiguration

+ (void)initialize
{
    __CreateDateFormatterIfNeeded();
}

static NSURL *gsServerURL = nil;
+ (NSURL *)serverURL
{
    if (!gsServerURL)
    {
        gsServerURL = [NSURL URLWithString: GRServerMessageURLString];
    }
    
    return gsServerURL;
}

static NSDateFormatter *gsDateFormatter = nil;
static NSDateFormatter *gsYMDFormatter = nil;
static NSDateFormatter *gsCurrentDateFormatter = nil;
static NSArray *gsWeekStrings = nil;

static void __CreateDateFormatterIfNeeded(void)
{
    if (!gsDateFormatter)
    {
        gsDateFormatter = [[NSDateFormatter alloc] init];
        [gsDateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    }
    
    if (!gsYMDFormatter)
    {
        gsYMDFormatter = [[NSDateFormatter alloc] init];
        [gsYMDFormatter setDateFormat: @"yyyy年MM月dd日 %@hh:mm"];
    }
    if (!gsCurrentDateFormatter)
    {
        gsCurrentDateFormatter = [[NSDateFormatter alloc] init];
        [gsCurrentDateFormatter setDateFormat: @"%@%@ hh:mm"];
    }
    
    if (!gsWeekStrings)
    {
        gsWeekStrings = @[@"礼拜天 ",
                         @"礼拜一 ",
                         @"礼拜二 ",
                         @"礼拜三 ",
                         @"礼拜四 ",
                         @"礼拜五 ",
                         @"礼拜六 ",
                         ];
    }
}

+ (NSString *)stringFromDate: (NSDate *)date
{
    return [gsDateFormatter stringFromDate: date];
}

+ (NSDate *)dateFromString: (NSString *)str
{
    return [gsDateFormatter dateFromString: str];
}

+ (NSString *)fileURLString
{
    return GRFileURLString;
}

static NSString *noonStringForDate(NSDate *date)
{
    NSInteger hour = [date hour];
    
    if (hour <= 6)
    {
        return @"凌晨";
        
    }else if (hour < 12)
    {
        return @"上午";
        
    }else if (hour < 18)
    {
        return @"下午";
    }
    
    return @"晚上";
}

+ (NSString *)timeStampStringForDate: (NSDate *)date
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate: date];
    NSString *noonString = noonStringForDate(date);

    if (interval > GRSecondsPerWeek)
    {
        return [NSString stringWithFormat: [gsYMDFormatter stringFromDate: date], noonString];
        
    }else if (interval > GRSecondsPerDay)
    {
        //more than one day
        ERWeekDay weekDay = [date weekDay];
        
        NSString *weekString = gsWeekStrings[weekDay - ERSunday];
        
        return [NSString stringWithFormat: [gsCurrentDateFormatter stringFromDate: date], weekString, noonString];
        
    }else if ([currentDate isTheSameDayAs: date])
    {
        return [NSString stringWithFormat: [gsCurrentDateFormatter stringFromDate: date], @"", noonString];
    }else
    {
        return [NSString stringWithFormat: [gsCurrentDateFormatter stringFromDate: date], @"昨天 ", noonString];
    }
    
    return nil;
}

@end

NSTimeInterval GRChatMessageTimeStampInterval = 5 * 60; //5 minutes
