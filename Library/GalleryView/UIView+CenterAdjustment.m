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

#import "UIView+CenterAdjustment.h"

@implementation UIView(CenterAdjustment)

- (void)setAdjustedCenter: (CGPoint)center
{

    UIScreen *screen = [[self window] screen];
    if (!screen)
    {
        screen = [UIScreen mainScreen];
    }

    CGFloat scale = [screen scale];

    CGRect frame = [self frame];
    
    if (((long long)round(frame.size.width * scale)) % 2)
    {
        center.x = round(center.x * scale) / scale + 0.5;
    }
    else 
    {
        center.x = round(center.x * scale) / scale;
    }
    
    if (((long long)round(frame.size.height * scale)) % 2)
    {
        center.y = round(center.y * scale) / scale + 0.5;
    }
    else 
    {
        center.y = round(center.y * scale) / scale;
    }
    
    [self setCenter: center];

}

@end
