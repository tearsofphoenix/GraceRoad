//
//  UIRefreshControl+GRExtensions.m
//  GraceRoad
//
//  Created by Lei on 14-1-18.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "UIRefreshControl+GRExtensions.h"

@implementation UIRefreshControl (GRExtensions)

- (void)setTitle: (NSString *)str
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString: str];
    [self setAttributedTitle: title];
}
@end
