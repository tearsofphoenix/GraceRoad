//
//  ERGeneralBackgroundOperationQueue.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/25/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERGeneralBackgroundOperationQueue.h"

static NSOperationQueue *ERGlobalGeneralBackgroundOperationQueue;

@implementation ERGeneralBackgroundOperationQueue

+ (void)load
{
    ERGlobalGeneralBackgroundOperationQueue = [[NSOperationQueue alloc] init];
}

+ (NSOperationQueue *)generalBackgroundQueue
{
    return ERGlobalGeneralBackgroundOperationQueue;
}

@end
