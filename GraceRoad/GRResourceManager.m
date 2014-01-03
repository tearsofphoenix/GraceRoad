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

static NSString *serverFileRootPath = @"http://";

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
    NSString *path = [[self resourcePath] stringByAppendingPathComponent: subPath];
    
    return [[NSFileManager defaultManager] fileExistsAtPath: path];    
}

+ (NSData *)dataWithSubPath: (NSString *)subPath
{
    NSString *path = [[self resourcePath] stringByAppendingPathComponent: subPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: path])
    {
        return [NSData dataWithContentsOfFile: path];
    }
    
    return nil;
}

+ (NSString *)_packResourcePathWithSubPath: (NSString *)subPath
{
    return @"https://www.lds.org/bc/content/shared/content/english/pdf/36035_000_25_livingchrist.pdf";
    return [serverFileRootPath stringByAppendingPathComponent: subPath];
}

+ (void)downloadFileWithSubPath: (NSString *)subPath
                       callback: (GRResourceCallback)callback
{
    [MFNetworkClient downloadFileAtPath: [self _packResourcePathWithSubPath: subPath]
                            enableCache: NO
                               callback: (^(NSData *data, id error)
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
                                          })];
}

@end
