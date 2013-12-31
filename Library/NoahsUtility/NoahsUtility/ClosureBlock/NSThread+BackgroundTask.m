//
//  NSThread+BackgroundTask.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/16/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSThread+BackgroundTask.h"

#import <objc/runtime.h>

#import "NSDictionary+NSNull.h"
#import "NSMutableDictionary+NSNull.h"

static NSLock *ERThreadBackgroundTasksLock;

static NSMutableDictionary *ERThreadBackgroundTasksDictionary;

static char ERThreadBackgroundTasksKey;

@implementation NSThread (BackgroundTask)

- (id)initWithIdentifier: (NSString *)identifier
     firstBackgroundTask: (ERThreadBackgroundTask)firstBackgroundTask
{
    
    self = [self initWithTarget: self
                       selector: @selector(runBackgroundTaskWithArgument:)
                         object: identifier];
    if (self)
    {
        
        NSMutableArray *tasks = [[NSMutableArray alloc] init];
        
        objc_setAssociatedObject(self, &ERThreadBackgroundTasksKey, tasks, OBJC_ASSOCIATION_RETAIN);
        
        firstBackgroundTask = Block_copy(firstBackgroundTask);
        
        [tasks addObject: firstBackgroundTask];
        
        Block_release(firstBackgroundTask);
        
        [tasks release];
        
    }
    
    return self;
}

+ (void)arrangeBackgroundTask: (ERThreadBackgroundTask)task
       inThreadWithIdentifier: (NSString *)identifier
{
    
    if (!ERThreadBackgroundTasksDictionary)
    {
        ERThreadBackgroundTasksDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if (!ERThreadBackgroundTasksLock)
    {
        ERThreadBackgroundTasksLock = [[NSLock alloc] init];
    }
    
    [ERThreadBackgroundTasksLock lock];
    
    NSThread *thread = [ERThreadBackgroundTasksDictionary objectOrNilForKey: identifier];
    if (!thread)
    {
        
        thread = [[NSThread alloc] initWithIdentifier: identifier
                                  firstBackgroundTask: task];
        
        [ERThreadBackgroundTasksDictionary setObjectOrNil: thread
                                                   forKey: identifier];
        
        [thread start];
        
        [thread release];
                
    }
    else
    {
        [thread addBackgroundTask: task];
    }
    
    [ERThreadBackgroundTasksLock unlock];
    
}

- (void)addBackgroundTask: (ERThreadBackgroundTask)block
{
    
    NSMutableArray *backgroundTasks = objc_getAssociatedObject(self, &ERThreadBackgroundTasksKey);
    
    block = Block_copy(block);
    
    [backgroundTasks addObject: block];
    
    Block_release(block);
    
}

- (void)runBackgroundTaskWithArgument: (NSString *)identifier
{
    
    __block NSException *outerException = nil;
    
    @autoreleasepool
    {
        
        NSMutableArray *backgroundTasks = objc_getAssociatedObject(self, &ERThreadBackgroundTasksKey);

        [ERThreadBackgroundTasksLock lock];
        
        while ([backgroundTasks count] && (!outerException))
        {
            
            @autoreleasepool
            {
                
                ERThreadBackgroundTask task = [backgroundTasks objectAtIndex: 0];
                
                [task retain];
                
                [backgroundTasks removeObjectAtIndex: 0];
                
                [ERThreadBackgroundTasksLock unlock];
                
                @try
                {
                    task(nil);
                }
                @catch (NSException *exception)
                {
                    outerException = [exception retain];
                }
                
                [ERThreadBackgroundTasksLock lock];
                
                [task release];
                
            }
            
        }
        
        [ERThreadBackgroundTasksDictionary removeObjectOrNilForKey: identifier];
        
        [ERThreadBackgroundTasksLock unlock];
        
    }
    
    if (outerException)
    {
        @throw [outerException autorelease];
    }
    
}

@end
