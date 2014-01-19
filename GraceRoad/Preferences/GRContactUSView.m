//
//  GRContactUSView.m
//  GraceRoad
//
//  Created by Lei on 14-1-20.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRContactUSView.h"

@interface GRContactUSView ()
{
    UIImageView *_QRCodeView;
}
@end

@implementation GRContactUSView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"联系我们"];
        [self setHideTabbar: YES];
        
        UIImage *image = [UIImage imageNamed: @"GRQRCode"];
        CGSize size = [image size];
        CGRect rect = CGRectMake((frame.size.width - size.width) / 2, 30, size.width, size.height);
        
        _QRCodeView = [[UIImageView alloc] initWithFrame: rect];
        [_QRCodeView setImage: image];
        
        [self addSubview: _QRCodeView];
    }
    return self;
}

- (void)dealloc
{
    [_QRCodeView release];
    
    [super dealloc];
}
@end
