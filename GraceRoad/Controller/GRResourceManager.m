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
#import <UIKit/UIKit.h>

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

static NSString *_CreateFolderUnderLibraryDirectoryIfNeeded(NSString *folderName)
{
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                NSUserDomainMask,
                                                                YES)[0];
    NSString *path = [libraryPath stringByAppendingPathComponent: folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSError *error = nil;
        [fileManager createDirectoryAtPath: path
               withIntermediateDirectories: YES
                                attributes: nil
                                     error: &error];
        if (error)
        {
            NSLog(@"in function: %s error: %@", __func__, error);
            return nil;
        }
    }
    
    return path;
}

+ (NSString *)resourcePath
{
    if (!gsResourcePath)
    {
        gsResourcePath = [_CreateFolderUnderLibraryDirectoryIfNeeded(@"/.grace-road-resources") retain];
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

+ (NSString *)serverResourcePathWithSubPath: (NSString *)subPath
{
    return [[GRConfiguration fileURLString] stringByAppendingPathComponent: subPath];
}

+ (void)downloadFileWithSubPath: (NSString *)subPath
                       callback: (GRResourceCallback)callback
{
    [MFNetworkClient  downloadFileAtPath: [self serverResourcePathWithSubPath: subPath]
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

static id gsResourceManager = nil;

+ (id)manager
{
    if (!gsResourceManager)
    {
        gsResourceManager = [[self alloc] init];
    }
    
    return gsResourceManager;
}

- (id)init
{
    if ((self = [super init]))
    {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForMemoryWarning:)
                                                     name: UIApplicationDidReceiveMemoryWarningNotification
                                                   object: nil];
    }
    
    return self;
}

- (void)_notificationForMemoryWarning: (NSNotification *)notification
{
    [gsFileTypeImagesCache removeAllObjects];
}

static NSString *gsDatabasePath = nil;

- (NSString *)databasePath
{
    if (!gsDatabasePath)
    {
        gsDatabasePath = [_CreateFolderUnderLibraryDirectoryIfNeeded(@"/.grace-road-database") retain];
    }
    
    return gsDatabasePath;
}

@end
