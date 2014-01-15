//
//  GRResourceManager.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceManager.h"
#import "MFNetworkClient.h"

@implementation GRResourceManager

static NSString *serverFileRootPath = @"http://localhost/~veritas/grace/";

static NSString *gsResourcePath = nil;

+ (void)initialize
{
    
}

+ (NSString *)resourcePath
{
    if (!gsResourcePath)
    {
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                    NSUserDomainMask,
                                                                    YES)[0];
        gsResourcePath = [[libraryPath stringByAppendingPathComponent: @"/.grace-road-resources"] retain];
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

+ (BOOL)fileExistsWithSubPath: (NSString *)subPath
{
    return [[NSFileManager defaultManager] fileExistsAtPath: [self pathWithSubPath: subPath]];
}

+ (NSString *)pathWithSubPath: (NSString *)subPath
{
    return [[self resourcePath] stringByAppendingPathComponent: subPath];
}

+ (NSData *)dataWithSubPath: (NSString *)subPath
{
    NSString *path = [self pathWithSubPath: subPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: path])
    {
        return [NSData dataWithContentsOfFile: path];
    }
    
    return nil;
}

+ (NSString *)_packResourcePathWithSubPath: (NSString *)subPath
{
    return [serverFileRootPath stringByAppendingPathComponent: subPath];
}

+ (void)downloadFileWithSubPath: (NSString *)subPath
                       callback: (GRResourceCallback)callback
{
#if 0
    [MFNetworkClient downloadFileAtPath: [self _packResourcePathWithSubPath: subPath]
                            enableCache: NO
                               callback: (^(NSData *data, id error)
                                          {
                                              double delayInSeconds = 1.0;
                                              dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                              dispatch_after(popTime, dispatch_get_main_queue(),
                                                             (^(void)
                                                              {
                                                                  if (data)
                                                                  {
                                                                      [data writeToFile: [[self resourcePath] stringByAppendingPathComponent: subPath]
                                                                             atomically: YES];
                                                                  }
                                                                  
                                                                  if (callback)
                                                                  {
                                                                      callback(data, error);
                                                                  }
                                                              }));
                                          })];
#else
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: subPath];
    NSData *data = [NSData dataWithContentsOfFile: path];

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),
                   (^(void)
                    {
                        if (data)
                        {
                            [data writeToFile: [[self resourcePath] stringByAppendingPathComponent: subPath]
                                   atomically: YES];
                        }
                        
                        if (callback)
                        {
                            callback(data, nil);
                        }
                    }));
#endif
}

@end
