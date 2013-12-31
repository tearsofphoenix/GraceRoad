// EREACH CONFIDENTIAL
// 
// [2011] eReach Mobile Software Technology Co., Ltd.
// All Rights Reserved.
//
// NOTICE:  All information contained herein is, and remains the
// property of eReach Mobile Software Technology and its suppliers,
// if any.  The intellectual and technical concepts contained herein
// are proprietary to eReach Mobile Software Technology and its
// suppliers and may be covered by U.S. and Foreign Patents, patents
// in process, and are protected by trade secret or copyright law.
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained
// from eReach Mobile Software Technology Co., Ltd.
//

#import "NSThread+ClosureBlock.h"

#import <objc/runtime.h>

static char ERThreadClosureBlockKey;

@implementation NSThread(ClosureBlock)

- (id)initWithClosureBlock: (ERThreadClosureBlock)block 
                  argument: (id)argument
{
    
    self = [self initWithTarget: self 
                       selector: @selector(runClosureBlockWithArgument:) 
                         object: argument];
    if (self)
    {
        
        block = Block_copy(block);
        
        objc_setAssociatedObject(self, &ERThreadClosureBlockKey, block, OBJC_ASSOCIATION_RETAIN);
        
        Block_release(block);
        
    }
    
    return self;
}

+ (void)detachNewThreadWithClosureBlock: (ERThreadClosureBlock)block
                               argument: (id)argument
{
    
    NSThread *thread = [[NSThread alloc] initWithClosureBlock: block 
                                                     argument: argument];
    
    [thread start];
    
    [thread release];
    
}

- (void)runClosureBlockWithArgument: (id)argument
{
    
    @autoreleasepool 
    {
        
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
        
        NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
        [threadDictionary setObject: [NSNumber numberWithBool: YES] 
                             forKey: ERThreadClosureBlockCouldExitKey];
        
        ERThreadClosureBlock block = objc_getAssociatedObject(self, &ERThreadClosureBlockKey);
        if (block)
        {
            block(argument);
        }
        
        while (![[threadDictionary objectForKey: ERThreadClosureBlockCouldExitKey] boolValue])
        {
            
            @autoreleasepool
            {
                [runLoop runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.1]];
            }
            
        }
            
    }
    
}

@end
