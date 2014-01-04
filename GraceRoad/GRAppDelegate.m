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

@implementation GRAppDelegate

- (BOOL)          application: (UIApplication *)application
didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
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
    
    return YES;
}

- (void)        application: (UIApplication *)application
didReceiveLocalNotification: (UILocalNotification *)notification
{    
    NSDictionary *userInfo = [notification userInfo];
    
    [UIAlertView showAlertWithTitle: @"每日读经"
                            message: [NSString stringWithFormat: @"%@\n%@\n%@",
                                      userInfo[@"address"],
                                      userInfo[@"zh_TW"],
                                      userInfo[@"en"]]
                  cancelButtonTitle: @"确定"
                  otherButtonTitles: nil
                           callback: nil];
}

@end
