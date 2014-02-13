//
//  GRConfiguration.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-20.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRConfiguration : NSObject

+ (NSURL *)serverURL;

+ (NSString *)fileURLString;

+ (NSString *)stringFromDate: (NSDate *)date;

+ (NSDate *)dateFromString: (NSString *)str;

@end
