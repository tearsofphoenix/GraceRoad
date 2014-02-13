//
//  GRConfiguration.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-20.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRConfiguration.h"

#if 1
#define GRServerDomain      @"http://www.xn--6oq90d37vryemman3g2vm.com"
#else
#define GRServerDomain      @"http://www.tearsofphoenix.com"
#endif

#define GRServerMessageURLString        GRServerDomain "/system/dispatch.php"
#define GRFileURLString                 GRServerDomain "/system/files/"

@implementation GRConfiguration

static NSURL *gsServerURL = nil;
+ (NSURL *)serverURL
{
    if (!gsServerURL)
    {
        gsServerURL = [[NSURL URLWithString: GRServerMessageURLString] retain];
    }
    
    return gsServerURL;
}

static NSDateFormatter *gsDateFormatter = nil;

static void __CreateDateFormatterIfNeeded(void)
{
    if (!gsDateFormatter)
    {
        gsDateFormatter = [[NSDateFormatter alloc] init];
        [gsDateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    }
}

+ (NSString *)stringFromDate: (NSDate *)date
{
    __CreateDateFormatterIfNeeded();
    return [gsDateFormatter stringFromDate: date];
}

+ (NSDate *)dateFromString: (NSString *)str
{
    __CreateDateFormatterIfNeeded();
    return [gsDateFormatter dateFromString: str];
}

+ (NSString *)fileURLString
{
    return GRFileURLString;
}

@end
