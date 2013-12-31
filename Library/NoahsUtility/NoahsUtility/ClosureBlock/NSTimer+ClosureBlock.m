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

#import "NSTimer+ClosureBlock.h"

#import <objc/runtime.h>

static char ERTimerClosureBlockKey;

@implementation NSTimer(ClosureBlock)

+ (NSTimer *)scheduledTimerWithTimeInterval: (NSTimeInterval)timeInterval 
                               closureBlock: (ERTimerClosureBlock)closureBlock
{
    return [self scheduledTimerWithTimeInterval: timeInterval 
                                   closureBlock: closureBlock 
                                        repeats: NO];
}

+ (NSTimer *)scheduledTimerWithTimeInterval: (NSTimeInterval)timeInterval 
                               closureBlock: (ERTimerClosureBlock)closureBlock
                                    repeats: (BOOL)repeats
{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: timeInterval
                                                      target: self
                                                    selector: @selector(runClosureBlock:) 
                                                    userInfo: nil
                                                     repeats: repeats];
    
    closureBlock = Block_copy(closureBlock);
    
    objc_setAssociatedObject(timer, &ERTimerClosureBlockKey, closureBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    Block_release(closureBlock);
    
    return timer;
}

+ (void)runClosureBlock: (NSTimer *)timer
{
    
    ERTimerClosureBlock closureBlock = objc_getAssociatedObject(timer, &ERTimerClosureBlockKey);
    
    closureBlock(timer);
    
}


@end
