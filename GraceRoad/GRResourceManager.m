//
//  GRResourceManager.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceManager.h"


@implementation GRResourceManager

static NSString *gsResourcePath = nil;

+ (NSString *)resourcePath
{
    if (!gsResourcePath)
    {
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                    NSUserDomainMask,
                                                                    YES)[0];
        gsResourcePath = [libraryPath stringByAppendingPathComponent: @"/.grace-road-resources"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: gsResourcePath])
        {
            NSError *error = nil;
            [fileManager createDirectoryAtPath: gsResourcePath
                   withIntermediateDirectories: YES
                                    attributes: nil
                                         error: &error];
            if (error)
            {
                NSLog(@"in function: %s error: %@", __func__, error);
            }
        }
    }
    
    return gsResourcePath;
}

@end
