//
//  GRResourceManager.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceManager.h"
#import "MFNetworkClient.h"
#import "GRConfiguration.h"

@implementation GRResourceManager

static NSString *gsResourcePath = nil;

static NSMutableDictionary *gsFileTypeImagesCache = nil;

+ (void)initialize
{
    if (!gsFileTypeImagesCache)
    {
        gsFileTypeImagesCache = [[NSMutableDictionary alloc] init];
    }
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
    return [[GRConfiguration fileURLString] stringByAppendingPathComponent: subPath];
}

+ (void)downloadFileWithSubPath: (NSString *)subPath
                       callback: (GRResourceCallback)callback
{
#if 1
    [MFNetworkClient  downloadFileAtPath: [self _packResourcePathWithSubPath: subPath]
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
    NSString *targetPath = [[self resourcePath] stringByAppendingPathComponent: subPath];
    
    NSData *data = nil;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath: path
                         isDirectory: &isDirectory])
    {
        if (isDirectory)
        {
            NSError *error = nil;
            
            [fileManager copyItemAtPath: path
                                 toPath: targetPath
                                  error: &error];
            if (error)
            {
                NSLog(@"in func: %s error: %@", __func__, error);
            }
        }else
        {
            data = [NSData dataWithContentsOfFile: path];
        }
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),
                   (^(void)
                    {
                        if (data)
                        {
                            [data writeToFile: targetPath
                                   atomically: YES];
                        }
                        
                        if (callback)
                        {
                            callback(data, nil);
                        }
                    }));
#endif
}

+ (UIImage *)imageForFileType: (NSString *)fileTypeName
{
    UIImage *image = gsFileTypeImagesCache[fileTypeName];
    if (!image)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource: fileTypeName
                                                         ofType: @"png"
                                                    inDirectory: @"FileType"];
        
        image = [UIImage imageWithContentsOfFile: path];
        [gsFileTypeImagesCache setObject: image
                                  forKey: fileTypeName];
    }
    
    return image;
}

@end
