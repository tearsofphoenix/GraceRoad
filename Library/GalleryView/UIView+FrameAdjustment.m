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

#import "UIView+FrameAdjustment.h"

@implementation UIView(FrameAdjustment)

- (void)setAdjustedFrame: (CGRect)frame
{
    [self setFrame: [self rectAdjustedFrom: frame]];
}

- (CGRect)rectAdjustedFrom: (CGRect)rect
{

    CGRect newRect = CGRectZero;

    UIScreen *screen = [[self window] screen];
    if (!screen)
    {
        screen = [UIScreen mainScreen];
    }
    
    CGFloat scale = [screen scale];

    newRect.origin.x = round(rect.origin.x * scale) / scale;
    newRect.origin.y = round(rect.origin.y * scale) / scale;
    newRect.size.width = round((rect.origin.x + rect.size.width) * scale) / scale - newRect.origin.x;
    newRect.size.height = round((rect.origin.y + rect.size.height) * scale) / scale - newRect.origin.y;

    return newRect;
}

@end
