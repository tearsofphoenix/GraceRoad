//
//  GRResourceManager.h
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ GRResourceCallback)(NSData *data, NSError *error);

@interface GRResourceManager : NSObject

+ (NSString *)resourcePath;

+ (BOOL)fileExistsWithSubPath: (NSString *)subPath;

+ (NSString *)pathWithSubPath: (NSString *)subPath;

+ (NSData *)dataWithSubPath: (NSString *)subPath;

+ (void)downloadFileWithSubPath: (NSString *)subPath
                       callback: (GRResourceCallback)callback;

+ (UIImage *)imageForFileType: (NSString *)fileTypeName;

+ (id)manager;

- (NSString *)databasePath;

+ (NSString *)serverResourcePathWithSubPath: (NSString *)subPath;

@end
