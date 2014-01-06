//
//  GRLoginView.m
//  GraceRoad
//
//  Created by Lei on 14-1-4.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRLoginView.h"

@interface GRLoginView ()
{
    UITextField *_userNameField;
    UITextField *_passwordField;
}
@end

@implementation GRLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitle: @"登录"];
        
        [self setBackgroundColor: [UIColor whiteColor]];
        
        
    }
    return self;
}

@end
