//
//  NSThread+BackgroundTask.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/16/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ERThreadBackgroundTask)(id argument);

@interface NSThread(BackgroundTask)

+ (void)arrangeBackgroundTask: (ERThreadBackgroundTask)block
       inThreadWithIdentifier: (NSString *)identifier;

@end
