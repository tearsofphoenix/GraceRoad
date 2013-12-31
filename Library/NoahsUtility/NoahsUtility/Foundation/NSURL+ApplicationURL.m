//
//  NSURL+ApplicationURL.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/23/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSURL+ApplicationURL.h"

static NSString *ERURLDocumentPath;
static NSString *ERURLLibraryPath;
static NSString *ERURLApplicationPath;

@implementation NSURL (ApplicationURL)

+ (void)initialize
{
    
    @autoreleasepool
    {
        ERURLDocumentPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] retain];
        ERURLLibraryPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex: 0] retain];
        ERURLApplicationPath = [[NSBundle mainBundle] bundlePath];
    }
    
}

+ (NSURL *)applicationURLFor: (NSURL *)URL
{
    
    if ([URL isFileURL])
    {
        
        NSString *imageRootPath = [[URL absoluteURL] path];
        if ([imageRootPath hasPrefix: ERURLDocumentPath])
        {
            return [[NSURL URLWithString: @"noahs-ark://documents.local"] URLByAppendingPathComponent:
                    [imageRootPath substringFromIndex: [ERURLDocumentPath length]]];
        }
        else if ([imageRootPath hasPrefix: ERURLLibraryPath])
        {
            return [[NSURL URLWithString: @"noahs-ark://library.local"] URLByAppendingPathComponent:
                    [imageRootPath substringFromIndex: [ERURLLibraryPath length]]];
        }
        else if ([imageRootPath hasPrefix: ERURLApplicationPath])
        {
            return [[NSURL URLWithString: @"noahs-ark://application.local"] URLByAppendingPathComponent:
                    [imageRootPath substringFromIndex: [ERURLApplicationPath length]]];
        }
        else
        {
            return URL;
        }
        
    }
    else
    {
        return URL;
    }
    
}

+ (NSURL *)URLForApplicationURL: (NSURL *)URL
{
    
    if ([[URL scheme] isEqualToString: @"noahs-ark"])
    {
        
        if ([[URL host] isEqualToString: @"documents.local"])
        {
            return [NSURL fileURLWithPath: [ERURLDocumentPath stringByAppendingPathComponent: [URL path]]];
        }
        else if ([[URL host] isEqualToString: @"library.local"])
        {
            return [NSURL fileURLWithPath: [ERURLLibraryPath stringByAppendingPathComponent: [URL path]]];
        }
        else if ([[URL host] isEqualToString: @"application.local"])
        {
            return [NSURL fileURLWithPath: [ERURLApplicationPath stringByAppendingPathComponent: [URL path]]];
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        return URL;
    }
    
}

@end
