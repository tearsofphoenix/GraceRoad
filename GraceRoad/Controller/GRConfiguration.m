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

+ (NSString *)stringFromDate: (NSDate *)date
{
    if (!gsDateFormatter)
    {
        gsDateFormatter = [[NSDateFormatter alloc] init];
        [gsDateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    }
    
    return [gsDateFormatter stringFromDate: date];
}

+ (NSString *)fileURLString
{
    return GRFileURLString;
}

@end
