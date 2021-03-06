//
//  GRViewService.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-3.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <NoahsService/NoahsService.h>
#import "GRShared.h"

#define GRViewServiceID     GRPrefix ".service.view"

#define GRViewServiceRegisterRootViewControllerAction  @"registerRootViewController:"
#define GRViewServiceRootViewControllerAction          @"rootViewController"

#define GRViewServicePushContentViewAction              @"pushContentView:"
#define GRViewServicePopContentViewAction               @"popContentView"

#define GRViewServiceShowLoadingIndicatorAction         @"showLoadingIndicator"
#define GRViewServiceHideLoadingIndicatorAction         @"hideLoadingIndicator"

#define GRViewServiceShowDailyScriptureAction           @"showDailyScripture:"
#define GRViewServiceViewPDFAtPathAction                @"viewPDFAtPath:"

#define GRViewServiceSendMessageAction                  @"sendMessageToRecipients:delegate:"
#define GRViewServiceAlertMessageWithCallbackAction     @"alertTitle:message:cancelButtonTile:otherButtonTitles:callback:"
#define GRViewServiceAlertMessageAction                 @"alertMessage:"

@interface GRViewService : ERService

@end
