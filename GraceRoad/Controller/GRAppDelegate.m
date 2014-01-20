//
//  GRAppDelegate.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRAppDelegate.h"
#import "GRMainViewController.h"
#import "GRViewService.h"
#import "UIAlertView+BlockSupport.h"
#import "GRDataService.h"
#import "WXApi.h"
#import "NSObject+GRExtensions.h"
#import <NoahsUtility/NSData+HEXStringDescription.h>

@interface iOSHierarchyViewer : NSObject

+ (BOOL)start;

+ (void)stop;

@end


@interface GRAppDelegate ()<WXApiDelegate>

@end

@implementation GRAppDelegate

- (BOOL)          application: (UIApplication *)application
didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    //[iOSHierarchyViewer start];
    
    id obj = (@{
               @"device_id" : @"a",
               @"device_token" : @"b",
               });
    
    NSLog(@"%@", [obj JSONString]);
    
    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    [_window setBackgroundColor: [UIColor whiteColor]];
    
    GRMainViewController *rootViewController = [[GRMainViewController alloc] init];
    
    [_window setRootViewController: rootViewController];
    
    ERSC(GRViewServiceID,
         GRViewServiceRegisterRootViewControllerAction,
         @[ rootViewController ], nil);
    
    [rootViewController release];
    
    [_window makeKeyAndVisible];
    
    [WXApi registerApp: @"wx862decf228c6b60b"
       withDescription: @"恩典之路"];
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),
                   (^(void)
    {
        [self application: application
didReceiveRemoteNotification: (@{
                                 @"aps" : (@{
                                             @"alert" : @"0126服侍",
                                             @"sound" : @"default",
                                             })
                                 })
   fetchCompletionHandler: nil];
    }));
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert
                                                                            | UIRemoteNotificationTypeBadge
                                                                            | UIRemoteNotificationTypeSound)];
    return YES;
}

- (void)        application: (UIApplication *)application
didReceiveLocalNotification: (UILocalNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    //has logged in?
    //
    ERSC(GRViewServiceID, GRViewServiceShowDailyScriptureAction, @[ userInfo ], nil);
    
}

- (void)         application: (UIApplication *)application
didReceiveRemoteNotification: (NSDictionary *)userInfo
{
    NSString *alert = userInfo[@"aps"][@"alert"];
    ERSC(GRDataServiceID,
         GRDataServiceExportNotificationToReminderAction,
         @[ alert ], nil);
    
    NSLog(@"in func: %s, userInfo: %@", __func__, userInfo);
}

- (void)         application: (UIApplication *)application
didReceiveRemoteNotification: (NSDictionary *)userInfo
      fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString *alert = userInfo[@"aps"][@"alert"];
    ERSC(GRDataServiceID,
         GRDataServiceExportNotificationToReminderAction,
         @[ alert ], nil);
    
    NSLog(@"in func: %s, userInfo: %@", __func__, userInfo);
}

- (BOOL)application: (UIApplication *)application
      handleOpenURL: (NSURL *)url
{
    return [WXApi handleOpenURL: url
                       delegate: self];
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation
{
    return [WXApi handleOpenURL: url
                       delegate: self];
}

- (void)onReq: (BaseReq *)req
{
    NSLog(@"in func: %@", req);
}

- (void)onResp: (BaseResp *)resp
{
    NSLog(@"in func: %@", resp);
}

- (void)                             application: (UIApplication *)app
didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)deviceToken
{
    NSString *deviceTokenString = [deviceToken hexBytesStringDescription];
    
    ERSC(GRDataServiceID,
         GRDataServiceRegisterDeviceTokenAction,
         @[ deviceTokenString ], nil);
}

- (void)                             application: (UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError: (NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}

@end
