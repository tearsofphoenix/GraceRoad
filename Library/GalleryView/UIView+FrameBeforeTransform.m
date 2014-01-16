//
//  UIView+FrameBeforeTransform.m
//  NoahsScratch
//
//  Created by Minun Dragonation on 11/14/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "UIView+FrameBeforeTransform.h"

@implementation UIView(FrameBeforeTransform)

- (CGRect)frameBeforeTransform
{
    return CGRectApplyAffineTransform([self frame], CGAffineTransformInvert([self transform]));
}

- (void)setFrameBeforeTransform: (CGRect)frame
{
    
    CGAffineTransform transform = [self transform];
    
    [self setTransform: CGAffineTransformIdentity];
    
    [self setFrame: frame];
    
    [self setTransform: transform];
    
}

@end
