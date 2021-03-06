//
//  GRLoginView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-6.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRLoginView.h"
#import "GRUIExtensions.h"
#import "GRUserProfileView.h"
#import "GRViewService.h"
#import "GRDataService.h"
#import "GRTheme.h"
#import "GRFoundation.h"

@interface GRLoginView ()
{
    UIScrollView *_loginContentView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    
    UITextField *_userNameField;
    UITextField *_passwordField;
}

@property (nonatomic) BOOL keyboardIsShown;

@end

@implementation GRLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        [self setBackgroundColor: [UIColor colorWithRed:47.0/255
                                                  green:168.0/255
                                                   blue:228.0/255
                                                  alpha:1.0f]];
        
        CGRect bounds = [self bounds];
        
        _loginContentView = [[UIScrollView alloc] initWithFrame: bounds];
        [_loginContentView setShowsVerticalScrollIndicator: NO];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                               action: @selector(_handleBackgroundTappedEvent:)];
        [_loginContentView addGestureRecognizer: tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        [self addSubview: _loginContentView];
        
        CGSize contentSize = CGSizeMake(bounds.size.width, 0);
        
        CGFloat offsetY = 30;
        
        NSString* fontName = @"Optima-Italic";
        NSString* boldFontName = @"Optima-ExtraBlack";
        
        CGRect rect = CGRectMake(35, 46 + offsetY, 257, 90);
        _titleLabel = [[UILabel alloc] initWithFrame: rect];
        [_titleLabel setBackgroundColor: [UIColor clearColor]];
        [_titleLabel setTextColor: [UIColor whiteColor]];
        [_titleLabel setFont: [UIFont fontWithName: boldFontName
                                              size: 24]];
        [_titleLabel setText: @"      敬畏耶和华心存谦卑，就得富有，尊容，生命，为赏赐。"];
        [_titleLabel setNumberOfLines: 0];
        [_loginContentView addSubview: _titleLabel];
        
        rect = CGRectMake(35, 126 + offsetY, 257, 25);
        
        _subtitleLabel = [[UILabel alloc] initWithFrame: rect];
        [_subtitleLabel setBackgroundColor: [UIColor clearColor]];
        [_subtitleLabel setTextColor: [UIColor whiteColor]];
        [_subtitleLabel setFont: [UIFont fontWithName: boldFontName
                                                 size: 16]];
        [_subtitleLabel setTextAlignment: NSTextAlignmentRight];
        [_subtitleLabel setText: @"-－箴言 22:4"];
        
        [_loginContentView addSubview: _subtitleLabel];
        
        rect = CGRectMake(29, 205 + offsetY, 263, 41);
        _userNameField = [[UITextField alloc] initWithFrame: rect];
        [_userNameField setBackgroundColor: [UIColor whiteColor]];
        [[_userNameField layer] setCornerRadius: 3];
        
        [_userNameField setPlaceholder: @"手机号/邮箱/微信号/QQ"];
        [_userNameField setLeftView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 10, 10)] autorelease]];
        [_userNameField setLeftViewMode: UITextFieldViewModeAlways];
        [_userNameField setFont: [UIFont fontWithName: fontName
                                                 size: 16]];
        
        [_loginContentView addSubview: _userNameField];
        
        rect = CGRectMake(29, 254 + offsetY, 263, 41);
        _passwordField = [[UITextField alloc] initWithFrame: rect];
        [_passwordField setBackgroundColor: [UIColor whiteColor]];
        [[_passwordField layer] setCornerRadius: 3];
        [_passwordField setPlaceholder: @"password"];
        
#if DEBUG
//        [_userNameField setText: @"tearsofphoenix@icloud.com"];
        [_userNameField setText: @"13671765129"];
        [_passwordField setText: @"hello"];
#endif
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey: GRSavedUserNameKey];
        if (userName)
        {
            [_userNameField setText: userName];
        }
        
        [_passwordField setLeftView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 10, 10)] autorelease]];
        [_passwordField setLeftViewMode: UITextFieldViewModeAlways];
        [_passwordField setSecureTextEntry: YES];
        
        [_loginContentView addSubview: _passwordField];
        
        
        UIColor* darkColor = [GRTheme darkColor];
        
        rect = CGRectMake(29, 343 + offsetY, 263, 50);
        UIButton *loginButton = [[UIButton alloc] initWithFrame: rect];
        
        [loginButton setBackgroundColor: darkColor];
        [[loginButton layer] setCornerRadius: 3.0f];
        [[loginButton titleLabel] setFont: [UIFont fontWithName: boldFontName
                                                           size: 20.0f]];
        [loginButton setTitle: @"登录"
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
        

        rect = CGRectMake(29, 415 + offsetY, 263, 19);
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
        
        contentSize.height = rect.origin.y + rect.size.height + 20;
        
        [_loginContentView setContentSize: contentSize];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForKeyboardShow:)
                                                     name: UIKeyboardWillShowNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForKeyboardHide:)
                                                     name: UIKeyboardWillHideNotification
                                                   object: nil];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"in func: %s", __func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_loginContentView release];
    [_titleLabel release];
    [_subtitleLabel release];
    
    [_userNameField release];
    [_passwordField release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    CGRect rect = [_loginContentView frame];
    CGRect bounds = [self bounds];
    CGSize size = [_loginContentView contentSize];
    size.height += bounds.size.height - rect.size.height;
    
    [_loginContentView setFrame: bounds];
    [_loginContentView setContentSize: size];
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
        ERSC(GRViewServiceID, GRViewServiceAlertMessageAction, @[ errorMessage], nil);
    }else
    {
        ERServiceCallback callback = (^(id result, id exception)
                                      {
                                          ERSC(GRViewServiceID, GRViewServiceHideLoadingIndicatorAction, nil, nil);
                                          
                                          if (result)
                                          {
                                              if (_disposableCallback)
                                              {
                                                  _disposableCallback();
                                                  [self setDisposableCallback: nil];
                                              }
                                          }else
                                          {
                                             ERSC(GRViewServiceID, GRViewServiceAlertMessageAction, @[ @"登录失败！"], nil);
                                          }
                                      });
        callback = Block_copy(callback);
        
        ERSC(GRViewServiceID, GRViewServiceShowLoadingIndicatorAction, nil, nil);
        
        password = [password MD5String];
        
        ERSC(GRDataServiceID,
             GRDataServiceLoginAction,
             @[userName, password, callback ], nil);
        
        Block_release(callback);
    }
}

- (void)_handleForgotPasswordButtonTappedEvent: (id)sender
{
    ERSC(GRViewServiceID, GRViewServiceAlertMessageAction, @[ @"一封邮件已发送到您的邮箱，请检查！"], nil);
}

- (void)_handleBackgroundTappedEvent: (id)sender
{
    NSLog(@"in func: %s", __func__);
    
    [[self firstResponder] resignFirstResponder];
}

- (void)_notificationForKeyboardShow: (NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    frame = [[self window] convertRect: frame
                                toView: self];
    
    UIView *firstResponder = [self firstResponder];
    CGRect rect = [firstResponder frame];
    
    CGFloat offset = rect.origin.y + rect.size.height - frame.origin.y;
    if (offset > 0)
    {
        [_loginContentView setContentOffset: CGPointMake(0, offset + 10)
                               animated: YES];
    }
    
    _keyboardIsShown = YES;
}

- (void)_notificationForKeyboardHide: (NSNotification *)notification
{
    [_loginContentView setContentOffset: CGPointZero
                               animated: YES];
}

@end
