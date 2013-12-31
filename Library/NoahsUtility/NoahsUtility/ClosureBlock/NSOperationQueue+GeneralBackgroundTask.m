//
//  NSOperationQueue+GeneralBackgroundTask.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/24/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSOperationQueue+GeneralBackgroundTask.h"

#import "ERGeneralBackgroundOperationQueue.h"

@implementation NSOperationQueue(GeneralBackgroundTask)

+ (NSOperationQueue *)generalBackgroundQueue
{
    return [ERGeneralBackgroundOperationQueue generalBackgroundQueue];
}

@end
