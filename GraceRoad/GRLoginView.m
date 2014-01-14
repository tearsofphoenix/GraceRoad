//
//  GRLoginView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-6.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRLoginView.h"
#import "UIView+FirstResponder.h"
#import "UIAlertView+BlockSupport.h"
#import "GRUserProfileView.h"
#import "GRViewService.h"
#import "GRDataService.h"

@interface GRLoginView ()
{
    UIView *_loginContentView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    
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
        [self setHideTabbar: YES];
        [self setTitle: @"登陆"];
        
        [self setBackgroundColor: [UIColor colorWithRed:47.0/255
                                                  green:168.0/255
                                                   blue:228.0/255
                                                  alpha:1.0f]];
        
        _loginContentView = [[UIView alloc] initWithFrame: [self bounds]];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                               action: @selector(_handleBackgroundTappedEvent:)];
        [_loginContentView addGestureRecognizer: tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        [self addSubview: _loginContentView];
        
        CGFloat offsetY = 30;
        
        NSString* fontName = @"Optima-Italic";
        NSString* boldFontName = @"Optima-ExtraBlack";
        
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(35, 46 + offsetY, 257, 90)];
        [_titleLabel setBackgroundColor: [UIColor clearColor]];
        [_titleLabel setTextColor: [UIColor whiteColor]];
        [_titleLabel setFont: [UIFont fontWithName: boldFontName
                                              size: 24]];
        [_titleLabel setText: @"    敬畏耶和華心存謙卑, 就得富有, 尊榮, 生命, 為賞賜."];
        [_titleLabel setNumberOfLines: 0];
        [_loginContentView addSubview: _titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(35, 120 + offsetY, 257, 25)];
        [_subtitleLabel setBackgroundColor: [UIColor clearColor]];
        [_subtitleLabel setTextColor: [UIColor whiteColor]];
        [_subtitleLabel setFont: [UIFont fontWithName: boldFontName
                                                 size: 16]];
        [_subtitleLabel setTextAlignment: NSTextAlignmentRight];
        [_subtitleLabel setText: @"-－箴言 22:4"];
        
        [_loginContentView addSubview: _subtitleLabel];
        
        _userNameField = [[UITextField alloc] initWithFrame: CGRectMake(29, 205 + offsetY, 263, 41)];
        [_userNameField setBackgroundColor: [UIColor whiteColor]];
        [[_userNameField layer] setCornerRadius: 3];
        [_userNameField setPlaceholder: @"username"];
        [_userNameField setText: @"tearsofphoenix@icloud.com"];
        
        [_userNameField setLeftView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 10, 10)] autorelease]];
        [_userNameField setLeftViewMode: UITextFieldViewModeAlways];
        [_userNameField setFont: [UIFont fontWithName: fontName
                                                 size: 16]];
        
        [_loginContentView addSubview: _userNameField];
        
        _passwordField = [[UITextField alloc] initWithFrame: CGRectMake(29, 254 + offsetY, 263, 41)];
        [_passwordField setBackgroundColor: [UIColor whiteColor]];
        [[_passwordField layer] setCornerRadius: 3];
        [_passwordField setPlaceholder: @"password"];
        [_passwordField setText: @"hello"];
        
        [_passwordField setLeftView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 10, 10)] autorelease]];
        [_passwordField setLeftViewMode: UITextFieldViewModeAlways];
        [_passwordField setSecureTextEntry: YES];
        
        [_loginContentView addSubview: _passwordField];
        
        UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame: CGRectMake(29, 343 + offsetY, 263, 50)];
        
        [loginButton setBackgroundColor: darkColor];
        [[loginButton layer] setCornerRadius: 3.0f];
        [[loginButton titleLabel] setFont: [UIFont fontWithName: boldFontName
                                                           size: 20.0f]];
        [loginButton setTitle: @"登陆"
                     forState: UIControlStateNormal];
        [loginButton setTitleColor: [UIColor whiteColor]
                          forState: UIControlStateNormal];
        [loginButton setTitleColor: [UIColor colorWithWhite: 1.0f
                                                      alpha: 0.5f]
                          forState: UIControlStateHighlighted];
        
        [loginButton addTarget: self
                        action: @selector(_handleLoginButtonTappedEvent:)
              forControlEvents: UIControlEventTouchUpInside];
        [_loginContentView addSubview: loginButton];
        [loginButton release];
        
        CGRect rect = CGRectMake(29, 415 + offsetY, 263, 19);
        UIButton *forgotPassworButton = [[UIButton alloc] initWithFrame: rect];
        
        [[forgotPassworButton layer] setCornerRadius: 3.0f];
        [[forgotPassworButton titleLabel] setFont: [UIFont fontWithName: boldFontName
                                                                   size: 12.0f]];
        [forgotPassworButton setTitle: @"忘记密码？"
                             forState: UIControlStateNormal];
        [forgotPassworButton setTitleColor: darkColor
                                  forState: UIControlStateNormal];
        [forgotPassworButton setTitleColor: [UIColor colorWithWhite: 1.0f
                                                              alpha: 0.5f]
                                  forState: UIControlStateHighlighted];
        
        [forgotPassworButton addTarget: self
                                action: @selector(_handleForgotPasswordButtonTappedEvent:)
                      forControlEvents: UIControlEventTouchUpInside];
        [_loginContentView addSubview: forgotPassworButton];
        [forgotPassworButton release];
        
        rect.origin.y += rect.size.height + 10;

        UIButton *jumpOverButton = [[UIButton alloc] initWithFrame: rect];
        [[jumpOverButton layer] setCornerRadius: 3.0f];
        [[jumpOverButton titleLabel] setFont: [UIFont fontWithName: boldFontName
                                                              size: 12.0f]];
        [jumpOverButton setTitle: @"跳过"
                        forState: UIControlStateNormal];
        [jumpOverButton setTitleColor: darkColor
                             forState: UIControlStateNormal];
        [jumpOverButton setTitleColor: [UIColor colorWithWhite: 1.0f
                                                         alpha: 0.5f]
                             forState: UIControlStateHighlighted];
        [jumpOverButton addTarget: self
                           action: @selector(_handleJumpOverButtonTappedEvent:)
                 forControlEvents: UIControlEventTouchUpInside];
        [_loginContentView addSubview: jumpOverButton];
        [jumpOverButton release];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"in func: %s", __func__);
    
    [_loginContentView release];
    [_titleLabel release];
    [_subtitleLabel release];
    
    [_userNameField release];
    [_passwordField release];
    
    [super dealloc];
}


- (void)_handleLoginButtonTappedEvent: (id)sender
{
    NSString *userName = [_userNameField text];
    NSString *password = [_passwordField text];
    NSString *errorMessage = nil;
    
    if ([userName length] == 0)
    {
        errorMessage = @"请检查您的用户名！";
        
    }else if (0 == [password length])
    {
        errorMessage = @"请输入您的密码！";
    }
    
    if (errorMessage)
    {
        [UIAlertView alertWithMessage: errorMessage
                    cancelButtonTitle: @"确定"];
    }else
    {
        ERServiceCallback callback = (^(id result, id exception)
                                      {
                                          if (_disposableCallback)
                                          {
                                              _disposableCallback();
                                              [self setDisposableCallback: nil];
                                          }
                                      });
        callback = Block_copy(callback);
        
        ERSC(GRDataServiceID,
             GRDataServiceLoginAction,
             @[userName, password, callback ], nil);
        
        Block_release(callback);
    }
}

- (void)_handleForgotPasswordButtonTappedEvent: (id)sender
{
    [UIAlertView alertWithMessage: @"一封邮件已发送到您的邮箱，请检查！"
                cancelButtonTitle: @"确定"];
}

- (void)_handleBackgroundTappedEvent: (id)sender
{
    [[self firstResponder] resignFirstResponder];
}

- (void)_handleJumpOverButtonTappedEvent: (id)sender
{
    if (_disposableCallback)
    {
        _disposableCallback();
        
        [self setDisposableCallback: nil];
    }
}

@end