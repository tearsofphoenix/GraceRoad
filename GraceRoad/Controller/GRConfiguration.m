//
//  GRConfiguration.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-20.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRConfiguration.h"

//#define GRServerURLPrefix @"http://www.xn--6oq90d37vryemman3g2vm.com/system/message.php"
#define GRServerURLPrefix @"http://www.xn--6oq90d37vryemman3g2vm.com/system/test_php.php"

@implementation GRConfiguration

static NSURL *gsServerURL = nil;
+ (NSURL *)serverURL
{
    if (!gsServerURL)
    {
        gsServerURL = [[NSURL URLWithString: GRServerURLPrefix] retain];
    }
    
    return gsServerURL;
}

@end
