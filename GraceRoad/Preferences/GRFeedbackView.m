//
//  GRFeedbackView.m
//  GraceRoad
//
//  Created by Lei on 14-1-19.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRFeedbackView.h"
#import "GRTheme.h"
#import "GRViewService.h"
#import "GRDataService.h"
#import "GRUIExtensions.h"

@interface GRFeedbackView ()
{
    UITextView *_textView;
    UIButton *_sendButton;
}
@end

@implementation GRFeedbackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTitle: @"反馈"];
        [self setHideTabbar: YES];
        
        CGRect rect = CGRectMake(10, 40, frame.size.width - 10 * 2, 120);
        _textView = [[UITextView alloc] initWithFrame: rect];
        [self addSubview: _textView];
        
        rect.origin.y += rect.size.height + 100;
        rect.origin.x = 30;
        rect.size.width = frame.size.width - rect.origin.x * 2;
        rect.size.height = 40;
        
        _sendButton = [[UIButton alloc] initWithFrame: rect];
        [_sendButton setTitle: @"确定"
                     forState: UIControlStateNormal];
        [[_sendButton titleLabel] setFont: [UIFont boldSystemFontOfSize: 24]];
        [_sendButton setTitleColor: [UIColor whiteColor]
                          forState: UIControlStateNormal];
        [_sendButton addTarget: self
                        action: @selector(_handleSendButtonTappedEvent:)
              forControlEvents: UIControlEventTouchUpInside];
        [_sendButton setBackgroundColor: [GRTheme blueColor]];
        
        [self addSubview: _sendButton];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                               action: @selector(_handleBackgroundTappedEvent:)];
        [self addGestureRecognizer: tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    return self;
}

- (void)dealloc
{
    [_textView release];
    
    [super dealloc];
}

- (void)_handleSendButtonTappedEvent: (id)sender
{
    [_textView resignFirstResponder];
    NSString *feedback = [_textView text];
    
    if ([feedback length] > 0)
    {
        ERSC(GRViewServiceID, GRViewServiceShowLoadingIndicatorAction, nil, nil);
        
        ERSC(GRDataServiceID, GRDataServiceSendFeedbackAction, @[ feedback ],
             (^(id result, id exception)
              {
                  ERSC(GRViewServiceID, GRViewServiceHideLoadingIndicatorAction, nil, nil);
              }));
    }else
    {
        [UIAlertView alertWithMessage: @"请检查您的输入！"
                    cancelButtonTitle: @"确定"];
    }
}

- (void)_handleBackgroundTappedEvent: (id)sender
{
    [_textView resignFirstResponder];
}

@end
