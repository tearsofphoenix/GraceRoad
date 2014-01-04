//
//  UIView+FirstResponder.m
//  GraceRoad
//
//  Created by Lei on 14-1-4.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)

- (id)firstResponder
{
    if ([self isFirstResponder])
    {
        return self;
    }
    
    for (UIView *view in [self subviews])
    {
        id result = [view firstResponder];
        
        if (result)
        {
            return result;
        }
    }
    
    return nil;
}

@end
