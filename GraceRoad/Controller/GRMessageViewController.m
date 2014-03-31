//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "GRMessageViewController.h"
#import "JSMessage.h"
#import "GRViewService.h"
#import "GRDataService.h"
#import "GRConfiguration.h"
#import "GRAccountKeys.h"
#import "GRChatRoom.h"
#import <NoahsUtility/NoahsUtility.h>

@interface GRMessageViewController ()

@property (nonatomic, strong) NSDictionary *currentAccount;
@property (nonatomic, strong) GRChatRoom *currentChatRoom;
@end

@implementation GRMessageViewController

- (id)initWithNibName: (NSString *)nibNameOrNil
               bundle: (NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName: nibNameOrNil
                                bundle: nibBundleOrNil]))
    {
        _messages = [[NSMutableArray alloc] init];
        _currentChatRoom = [[GRChatRoom alloc] init];
        
        [self setCurrentAccount: ERSSC(GRDataServiceID, GRDataServiceCurrentAccountAction, nil)];
        
        [[NSNotificationCenter serviceCenter] addObserver: self
                                                 selector: @selector(_notificationForReceivedChatMessage:)
                                                     name: GRNotificationDidReceivedChatMessage
                                                   object: nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter serviceCenter] removeObserver: self];
}

- (void)_notificationForReceivedChatMessage: (NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"line: %d args: %@", __LINE__, userInfo);
    NSDictionary *aps = userInfo[@"aps"];
    NSDictionary *args = userInfo[GRPushArgumentsKey];
    
    NSDate *date = [GRConfiguration dateFromString: args[GRPushArgumentDateKey]];
    
    
    NSString *senderID = args[GRPushArgumentSenderKey];
    NSDictionary *accountInfo = [_currentChatRoom memberOfID: senderID];
    
    JSMessage *message = [[JSMessage alloc] initWithText: aps[@"alert"]
                                                  sender: accountInfo[GRAccountNameKey]
                                                    date: date];
    [_messages addObject: message];
    
    [[self tableView] reloadData];
    [[self tableView] scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: [_messages count] - 1
                                                                 inSection: 0]
                            atScrollPosition: UITableViewScrollPositionBottom
                                    animated: YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setDelegate: self];
    [self setDataSource: self];
    
    [super viewDidLoad];
    
    [[JSBubbleView appearance] setFont: [UIFont systemFontOfSize: 16.0f]];
    
    [self setSender: _currentAccount[GRAccountNameKey]];
    
    [self setBackgroundColor: [UIColor whiteColor]];
    
    [[self navigationItem] setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                               target: self
                                                                                               action: @selector(_handleBackButtonEvent:)]];
}

- (void)setRecipients: (NSMutableArray *)recipients
{
    if (_recipients != recipients)
    {
        _recipients = recipients;
        
        [_currentChatRoom addMembers: _recipients];
        
        if ([_recipients count] == 1)
        {
            NSDictionary *account = _recipients[0];
            
            [self setTitle: account[GRAccountNameKey]];
        }
    }
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    [self scrollToBottomAnimated:NO];
}

#pragma mark - Actions

- (void)_handleBackButtonEvent: (UIBarButtonItem *)sender
{
    UIViewController *vc = ERSSC(GRViewServiceID, GRViewServiceRootViewControllerAction, nil);
    [vc dismissViewControllerAnimated: YES
                           completion: nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messages count];
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText: (NSString *)text
         fromSender: (NSString *)sender
             onDate: (NSDate *)date
{
    [_messages addObject: [[JSMessage alloc] initWithText: text
                                                       sender: sender
                                                         date: date]];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
    
    NSMutableArray *recipients = [NSMutableArray arrayWithCapacity: [_recipients count]];
    
    for (NSDictionary *tLooper in _recipients)
    {
        [recipients addObject: tLooper[GRAccountIDKey]];
    }
    

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    [info setObject: text
             forKey: @"message"];
    
    [info setObject: GRPushActionChat
             forKey: GRPushActionKey];
    [info setObject: (@{
                        GRPushArgumentDateKey : [GRConfiguration stringFromDate: [NSDate date]],
                        GRPushArgumentTypeKey : GRPushChatTypeText,
                        GRPushArgumentSenderKey : _currentAccount[GRAccountIDKey],
                        })
             forKey: GRPushArgumentsKey];
    
    ERServiceCallback callback = (^(id result, NSError *error)
                                  {
                                      if (error)
                                      {
                                          ERSC(GRViewServiceID, GRViewServiceAlertMessageAction, @[ [error localizedDescription]], nil);
                                      }else
                                      {
                                          [JSMessageSoundEffect playMessageSentSound];
                                      }
                                  });
    callback = [callback copy];
    
    ERSSC(GRDataServiceID,
          GRDataServiceSendPushNotificationToAccountsWithCallbackAction,
          @[ info, recipients, callback]);
    
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath: (NSIndexPath *)indexPath
{
    JSMessage *message = (JSMessage *)[self messageForRowAtIndexPath: indexPath];
    
    if ([[message sender] isEqualToString: [self sender]])
    {
        return JSBubbleMessageTypeOutgoing;
    }else
    {
        return JSBubbleMessageTypeIncoming;
    }
}

- (UIImageView *)bubbleImageViewWithType: (JSBubbleMessageType)type
                       forRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (JSBubbleMessageTypeIncoming == type)
    {
        return [JSBubbleImageViewFactory bubbleImageViewForType: type
                                                          color: [UIColor js_bubbleLightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType: type
                                                      color: [UIColor js_bubbleBlueColor]];
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages view delegate: OPTIONAL

- (BOOL)shouldDisplayTimestampForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger count = [_messages count];
    NSInteger row = [indexPath row];
    
    if (row == 0)
    {
        return YES;
        
    }else if (row >= 2 && row == count - 1)
    {
        JSMessage *lastMessage = _messages[count - 1];
        JSMessage *compMessage = _messages[count - 2];
        
        if ([[lastMessage date] timeIntervalSinceDate: [compMessage date]] > GRChatMessageTimeStampInterval)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)configureCell: (JSBubbleMessageCell *)cell
          atIndexPath: (NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing)
    {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
        if ([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)])
        {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:UITextAttributeTextColor];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    if (cell.timestampLabel)
    {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if (cell.subtitleLabel)
    {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
    
#if TARGET_IPHONE_SIMULATOR
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
#else
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
#endif
}

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return NO;
}

// *** Implemnt to enable/disable pan/tap todismiss keyboard
//
- (BOOL)allowsPanToDismissKeyboard
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (JSMessage *)messageForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return _messages[[indexPath row]];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath: (NSIndexPath *)indexPath
                                           sender: (NSString *)sender
{
    UIImage *image = _avatars[sender];
    return [[UIImageView alloc] initWithImage: image];
}

@end
