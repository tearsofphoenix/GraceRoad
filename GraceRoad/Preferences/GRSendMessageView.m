//
//  GRSendMessageView.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-16.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRSendMessageView.h"
#import "ERGalleryView.h"
#import "ERGalleryViewThumbnail.h"
#import "GRAccountKeys.h"
#import "UIActionSheet+BlockSupport.h"
#import "UIView+FirstResponder.h"
#import "GRMessageType.h"
#import "UIAlertView+BlockSupport.h"
#import "GRViewService.h"
#import "GRDataService.h"
#import "GRTheme.h"

#import <MessageUI/MessageUI.h>

#define  GRAccountPerRow (5)

@interface GRSendMessageView ()<ERGalleryViewDataSource, ERGalleryViewDelegate,
MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    UIScrollView *_scrollView;
    ERGalleryView *_galleryView;
    UIButton *_notifyButton;
    UIButton *_typeButton;
    
    UILabel *_contentTitleLabel;
    UITextView *_textView;
    UIButton *_sendButton;
}

@property (nonatomic, retain) NSString *messageType;

@end

@implementation GRSendMessageView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        [self setTitle: @"发送消息"];
        [self setHideTabbar: YES];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                               action: @selector(_handleBackgroundTappedEvent:)];
        [self addGestureRecognizer: tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        CGRect bounds = [self bounds];
        _scrollView = [[UIScrollView alloc] initWithFrame: bounds];
        [self addSubview: _scrollView];
        
        UIFont *labelFont = [UIFont systemFontOfSize: 14.5];
        
        CGRect rect = CGRectMake(10, 0, 70, 30);
        UILabel *galleryTitleLabel = [[UILabel alloc] initWithFrame: rect];
        [galleryTitleLabel setText: @"收信人："];
        [galleryTitleLabel setFont: labelFont];
        [_scrollView addSubview: galleryTitleLabel];
        [galleryTitleLabel release];
        
        rect.origin.y += rect.size.height;
        rect.size.width = frame.size.width - 2 * rect.origin.x;
        rect.size.height = 60;
        
        _galleryView = [[ERGalleryView alloc] initWithFrame: rect];
        [_galleryView setArrangementDirection: ERGalleryViewArrangementDirectionVertical];
        [[_galleryView layer] setCornerRadius: 3];
        [[_galleryView layer] setBorderWidth: 1];
        [[_galleryView layer] setBorderColor: [[UIColor whiteColor] CGColor]];
        [_galleryView setBackgroundColor: [UIColor whiteColor]];
        
        [_galleryView setClipsToBounds: YES];
        
        [_scrollView addSubview: _galleryView];
        
        [_galleryView setDataSource: self];
        [_galleryView setDelegate: self];
        
        rect.origin.y += rect.size.height + 6;
        rect.size = CGSizeMake(80, 30);
        
        UILabel *notifyLabel = [[UILabel alloc] initWithFrame: rect];
        [notifyLabel setFont: labelFont];
        [notifyLabel setText: @"额外提醒："];
        [_scrollView addSubview: notifyLabel];
        [notifyLabel release];
        
        rect.origin.x += rect.size.width;
        rect.size = CGSizeMake(50, 26);
        
        _notifyButton = [[UIButton alloc] initWithFrame: rect];
        
        [_notifyButton setBackgroundColor: [GRTheme lightBlueColor]];
        [_notifyButton setTitle: @"无"
                       forState: UIControlStateNormal];
        [[_notifyButton titleLabel] setFont: labelFont];
        [_notifyButton setTitleColor: [UIColor blackColor]
                            forState: UIControlStateNormal];
        [_notifyButton addTarget: self
                          action: @selector(_handleNotifyButtonTappedEvent:)
                forControlEvents: UIControlEventTouchUpInside];
        [_scrollView addSubview: _notifyButton];
        
        rect.origin.x = 190;
        rect.size = CGSizeMake(50, 30);
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame: rect];
        [typeLabel setText: @"类型："];
        [typeLabel setFont: labelFont];
        [_scrollView addSubview: typeLabel];
        [typeLabel release];
        
        rect.origin.x += rect.size.width;
        rect.size = CGSizeMake(50, 26);
        
        [self setMessageType: GRMessageTypePushNotification];

        _typeButton = [[UIButton alloc] initWithFrame: rect];
        [_typeButton setBackgroundColor: [GRTheme lightBlueColor]];
        [_typeButton setTitle: @"推送"
                     forState: UIControlStateNormal];
        [[_typeButton titleLabel] setFont: labelFont];
        [_typeButton setTitleColor: [UIColor blackColor]
                          forState: UIControlStateNormal];
        [_typeButton addTarget: self
                        action: @selector(_handleTypeButtonTappedEvent:)
              forControlEvents: UIControlEventTouchUpInside];
        [_scrollView addSubview: _typeButton];
        
        rect.origin.y += rect.size.height;
        rect.origin.x = 10;
        rect.size = CGSizeMake(50, 26);
        
        _contentTitleLabel = [[UILabel alloc] initWithFrame: rect];
        [_contentTitleLabel setFont: labelFont];
        [_contentTitleLabel setText: @"内容："];
        [_scrollView addSubview: _contentTitleLabel];
        
        rect.origin.y += rect.size.height + 20;
        rect.size = CGSizeMake(frame.size.width - 2 * rect.origin.x, 120);
        
        _textView = [[UITextView alloc] initWithFrame: rect];
        [_scrollView addSubview: _textView];
        
        [_scrollView setContentSize: bounds.size];
        
//        UIButton *templateButton = [[UIButton alloc] initWithFrame: CGRectMake(240, 220, 50, 26)];
//        [templateButton setTitle: @"模板"
//                        forState: UIControlStateNormal];
//        [templateButton addTarget: self
//                           action: @selector(_handleTemplateButtonTappedEvent:)
//                 forControlEvents:  UIControlEventTouchUpInside];
//        [_scrollView addSubview: templateButton];
//        [templateButton release];
        
        _sendButton = [[UIButton alloc] initWithFrame: CGRectMake(30, bounds.size.height - 60,
                                                                  bounds.size.width - 30 * 2,
                                                                  40)];
        [_sendButton setTitle: @"确定"
                     forState: UIControlStateNormal];
        [[_sendButton titleLabel] setFont: [UIFont boldSystemFontOfSize: 24]];
        [_sendButton setTitleColor: [UIColor whiteColor]
                          forState: UIControlStateNormal];
        [_sendButton addTarget: self
                        action: @selector(_handleSendButtonTappedEvent:)
              forControlEvents: UIControlEventTouchUpInside];
        [_sendButton setBackgroundColor: [GRTheme blueColor]];
        
        [_scrollView addSubview: _sendButton];
        
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
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_targetAccounts release];
    [_galleryView release];
    
    [_notifyButton release];
    [_typeButton release];
    
    [_contentTitleLabel release];
    [_textView release];
    [_sendButton release];
    [_messageType release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    [_scrollView setFrame: frame];
    
    CGRect bounds = [self bounds];
    
    [_sendButton setFrame: CGRectMake(30, bounds.size.height - 60,
                                      bounds.size.width - 30 * 2,
                                      40)];
}

- (void)setTargetAccounts: (NSArray *)targetAccounts
{
    if (_targetAccounts != targetAccounts)
    {
        [_targetAccounts release];
        _targetAccounts = [targetAccounts retain];
        
        [_galleryView reloadData];
    }
}

- (NSInteger)numberOfSectionsInGalleryView: (ERGalleryView *)galleryView
{
    NSInteger count = [_targetAccounts count];
    NSInteger row = count / GRAccountPerRow;
    
    if (0 == count % GRAccountPerRow)
    {
        return row;
    }
    
    return row + 1;
}

- (NSInteger)galleryView: (ERGalleryView *)galleryView
numberOfThumbnailsInSectionAtIndex: (NSInteger)sectionIndex
{
    NSInteger count = [_targetAccounts count];
    NSInteger reminder = count % GRAccountPerRow;
    
    if (reminder == 0)
    {
        return GRAccountPerRow;
    }else
    {
        if (count > sectionIndex * GRAccountPerRow + reminder)
        {
            return GRAccountPerRow;
        }else
        {
            return reminder;
        }
    }
}

- (ERGalleryViewThumbnail *)galleryView: (ERGalleryView *)galleryView
                   thumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    ERGalleryViewThumbnail *thumbnail = [[ERGalleryViewThumbnail alloc] init];
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    NSDictionary *account = _targetAccounts[section * GRAccountPerRow + row];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 1, 50, 24)];
    [nameLabel setTextColor: [UIColor blackColor]];
    [nameLabel setText: account[GRAccountNameKey]];
    [nameLabel setFont: [UIFont systemFontOfSize: 13]];
    [thumbnail addSubview: nameLabel];
    [[nameLabel layer] setCornerRadius: 8];
    [nameLabel setBackgroundColor: [GRTheme lightBlueColor]];
    [nameLabel setTextAlignment: NSTextAlignmentCenter];
    [[nameLabel layer] setBorderWidth: 0.5];
    [[nameLabel layer] setBorderColor: [[UIColor colorWithRed:0.67 green:0.72 blue:0.97 alpha:1] CGColor]];
    
    [nameLabel release];
    
    return [thumbnail autorelease];
}

- (CGSize)      galleryView: (ERGalleryView *)galleryView
sizeForThumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    return CGSizeMake(56, 26);
}

- (CGFloat)  galleryView: (ERGalleryView *)galleryView
weightForHeaderOfSection: (NSInteger)section
{
    return 2;
}

- (void)_handleNotifyButtonTappedEvent: (id)sender
{
    NSArray *choices = (@[
                          @"无",
                          @"提前1天",
                          @"提前2天",
                          @"提前3天",
                          ]);
    
    [UIActionSheet showWithTitle: nil
                         choices: choices
                          inView: self
                        callback: (^(NSInteger buttonIndex)
                                   {
                                       if (buttonIndex > 0)
                                       {
                                           [_notifyButton setTitle: choices[buttonIndex - 1]
                                                          forState: UIControlStateNormal];
                                       }
                                       
                                       NSLog(@"selected: %d", buttonIndex);
                                   })];
}

- (void)_handleTypeButtonTappedEvent: (id)sender
{
    NSArray *choices = (@[
                          @"推送",
                          @"微信",
                          @"短信",
                          @"邮件",
                          ]);
    
    NSArray *types = @[GRMessageTypePushNotification, GRMessageTypeWeiXin, GRMessageTypeSMS, GRMessageTypeEmail ];
    
    [UIActionSheet showWithTitle: nil
                         choices: choices
                          inView: self
                        callback: (^(NSInteger buttonIndex)
                                   {
                                       if (buttonIndex > 0)
                                       {
                                           [_typeButton setTitle: choices[buttonIndex - 1]
                                                        forState: UIControlStateNormal];
                                           
                                           [self setMessageType: types[buttonIndex - 1]];
                                       }
                                       
                                       //is SMS or Mail ?
                                       //
                                       if (buttonIndex == 3
                                           || buttonIndex == 4)
                                       {
                                           [_contentTitleLabel setAlpha: 0];
                                           [_textView setAlpha: 0];
                                       }else
                                       {
                                           [_contentTitleLabel setAlpha: 1];
                                           [_textView setAlpha: 1];
                                       }
                                       
                                       NSLog(@"selected: %d", buttonIndex);
                                   })];
}

- (void)_handleBackgroundTappedEvent: (id)sender
{
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
        [_scrollView setContentOffset: CGPointMake(0, offset + 10)
                             animated: YES];
    }
}

- (void)_notificationForKeyboardHide: (NSNotification *)notification
{
    [_scrollView setContentOffset: CGPointZero
                         animated: YES];
}

- (void)_handleTemplateButtonTappedEvent: (id)sender
{
    
}

- (void)_handleSendButtonTappedEvent: (id)sender
{
    if ([_messageType isEqualToString: GRMessageTypePushNotification])
    {
        //
        ERServiceCallback callback = (^(id result, NSError *error)
                                      {
                                          ERSC(GRViewServiceID, GRViewServiceHideLoadingIndicatorAction, nil, nil);
                                          
                                          if (error)
                                          {
                                              [UIAlertView alertWithMessage: [error localizedDescription]
                                                          cancelButtonTitle: @"确定"];
                                          }else
                                          {
                                              [UIAlertView alertWithMessage: @"发送成功！"
                                                          cancelButtonTitle: @"确定"];
                                          }
                                      });
        callback = Block_copy(callback);
        
        ERSC(GRViewServiceID, GRViewServiceShowLoadingIndicatorAction, nil, nil);
        
        ERSSC(GRDataServiceID,
              GRDataServiceSendPushNotificationWithCallbackAction,
              @[ [_textView text], callback ]);
        
        Block_release(callback);
        
    }else if ([_messageType isEqualToString: GRMessageTypeSMS])
    {
        if ([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            [controller setMessageComposeDelegate: self];
            
            NSMutableArray *recipients = [NSMutableArray arrayWithCapacity: [_targetAccounts count]];
            
            for (NSDictionary *tLooper in _targetAccounts)
            {
                NSString *phoneNumber = tLooper[GRAccountMobilePhoneKey];
                if (phoneNumber)
                {
                    [recipients addObject: phoneNumber];
                }
            }
            
            [controller setRecipients: recipients];
            
            UIViewController *rootViewController = ERSSC(GRViewServiceID, GRViewServiceRootViewControllerAction, nil);
            [rootViewController presentViewController: controller
                                             animated: YES
                                           completion: nil];
            [controller release];
        }else
        {
            [UIAlertView alertWithMessage: @"您的设备无法发送短息！"
                        cancelButtonTitle: @"确定"];
        }
    }else if ([_messageType isEqualToString: GRMessageTypeWeiXin])
    {        
        NSString *message = [_textView text];
        if ([message length] > 0)
        {
            ERSC(GRDataServiceID, GRDataServiceSendMessageToWeixinAction, @[ message ], nil);
        }
    }else if ([_messageType isEqualToString: GRMessageTypeEmail])
    {
        if([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            
            [controller setMailComposeDelegate: self];
            
            NSMutableArray *recipients = [NSMutableArray arrayWithCapacity: [_targetAccounts count]];
            
            for (NSDictionary *tLooper in _targetAccounts)
            {
                NSString *email = tLooper[GRAccountEmailKey];
                if (email)
                {
                    [recipients addObject: email];
                }
            }
            
            [controller setToRecipients: recipients];
            
            UIViewController *rootViewController = ERSSC(GRViewServiceID, GRViewServiceRootViewControllerAction, nil);
            [rootViewController presentViewController: controller
                                             animated: YES
                                           completion: nil];
            [controller release];
            
        }else
        {
            [UIAlertView alertWithMessage: @"您的设备无法发送邮件！"
                        cancelButtonTitle: @"确定"];
        }
    }
}

- (void)messageComposeViewController: (MFMessageComposeViewController *)controller
                 didFinishWithResult: (MessageComposeResult)result
{
    UIViewController *rootViewController = ERSSC(GRViewServiceID, GRViewServiceRootViewControllerAction, nil);
    
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            [rootViewController dismissViewControllerAnimated: YES
                                                   completion: nil];
            break;
        }
        case MessageComposeResultFailed:
        {
            [rootViewController dismissViewControllerAnimated: YES
                                                   completion: (^
                                                                {
                                                                    [UIAlertView alertWithMessage: @"发送失败！"
                                                                                cancelButtonTitle: @"确定"];
                                                                })];
            break;
        }
        case MessageComposeResultSent:
        {
            [rootViewController dismissViewControllerAnimated: YES
                                                   completion: (^
                                                                {
                                                                    [UIAlertView alertWithMessage: @"发送成功！"
                                                                                cancelButtonTitle: @"确定"];
                                                                })];
            break;
        }
        default:
            break;
    }
}

- (void)mailComposeController: (MFMailComposeViewController *)controller
          didFinishWithResult: (MFMailComposeResult)result
                        error: (NSError *)error
{
    UIViewController *rootViewController = ERSSC(GRViewServiceID, GRViewServiceRootViewControllerAction, nil);
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        {
            [rootViewController dismissViewControllerAnimated: YES
                                                   completion: nil];
            break;
        }
        case MFMailComposeResultFailed:
        {
            [rootViewController dismissViewControllerAnimated: YES
                                                   completion: (^
                                                                {
                                                                    NSString *errorMessage = error ? [error localizedDescription] : @"发送失败！";
                                                                    
                                                                    [UIAlertView alertWithMessage: errorMessage
                                                                                cancelButtonTitle: @"确定"];
                                                                    
                                                                })];
            break;
        }
        case MFMailComposeResultSent:
        {
            [rootViewController dismissViewControllerAnimated: YES
                                                   completion: (^
                                                                {
                                                                    [UIAlertView alertWithMessage: @"发送成功！"
                                                                                cancelButtonTitle: @"确定"];
                                                                    
                                                                })];
            
            break;
        }
        default:
            break;
    }
}

@end
