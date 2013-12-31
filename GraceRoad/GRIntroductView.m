//
//  GRIntroductView.m
//  GraceRoad
//
//  Created by Lei on 13-12-29.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRIntroductView.h"

@implementation GRIntroductView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setBackgroundColor: [UIColor whiteColor]];
        
        CGRect rect = CGRectMake(0, 20, frame.size.width, 44);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: rect];
        [titleLabel setTextAlignment: NSTextAlignmentCenter];
        [titleLabel setText: @"新松江恩典教会"];
        [titleLabel setFont: [UIFont boldSystemFontOfSize: 30]];
        
        [self addSubview: titleLabel];
        [titleLabel release];
        
        rect.origin.x = 10;
        rect.size.width -= rect.origin.x * 2;
        rect.origin.y += rect.size.height;
        rect.size.height = frame.size.height - rect.origin.y;
        
        UITextView *contentView = [[UITextView alloc] initWithFrame: rect];
        [contentView setFont: [UIFont systemFontOfSize: 16]];
        [contentView setTextAlignment: NSTextAlignmentLeft];
        
        [contentView setText: (@"以马内利！新松江恩典教会欢迎您！\n"
                                "进入会堂请把手机关机或者静音。\n"
                                "感谢神把您带到我们当中，在基督里我们是一家人，\n"
                                "愿在以后的生活里我们共同学习神的话语。耶稣爱你！\n"
                                "以下是我们教会的常规事项，请仔细阅读。\n"
                                "周日礼拜时间：第一场 07:30-08:30 第二场 09:00-0:30\n"
                                "            第三场 13:30-15:00\n"
                                "成人主日学： 11:00-12:00\n"
                                "")];
        [self addSubview: contentView];
        [contentView release];

    }
    return self;
}

- (NSString *)title
{
    return @"简介";
}

@end
