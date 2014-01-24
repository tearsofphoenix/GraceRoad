//
//  GRDataService.h
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import <NoahsService/NoahsService.h>
#import "GRShared.h"

#define GRDataServiceID                 GRPrefix ".service.data"

#pragma mark - account

#define GRDataServiceCurrentAccountAction        @"currentAccount"
#define GRDataServiceLoginAction                 @"loginUser:password:callback:"
#define GRDataServiceLogoutAction                @"logout"
#define GRDataServiceAddScriptureAlertAction     @"addScripture:"

#define GRDataServiceAllResourcesAction          @"allResources"
#define GRDataServiceAllResourceCategoriesAction @"allResourceCategories"

#define GRDataServiceAllSermonCategoriesAction   @"allSermonCategories"
#define GRDataServiceAllSermonsAction            @"allSermons"

#define GRDataServiceAllPrayListAction           @"allPrayList"
#define GRDataServiceAddPrayAction               @"addPray:"

#define GRDataServiceSaveLessonForIDAction       @"saveLesson:forID:"
#define GRDataServiceLessonRecordForIDAction     @"lessonRecordForID:"

#define GRDataServiceTeamForAccountIDAction      @"teamForAccountID:"
#define GRDataServiceAllMemberForTeamIDAction    @"allMemberForTeamID:"

#define GRDataServiceSendPushNotificationWithCallbackAction  @"sendPushNotification:callback:"
#define GRDataServiceSendMessageToWeixinAction   @"sendMessageToWeixin:"

#define GRDataServiceExportNotificationToReminderAction      @"exportNotificationToReminder:"
#define GRDataServiceRegisterDeviceTokenAction   @"registerDeviceToken:"

#define GRDataServiceSendFeedbackAction          @"sendFeedback:callback:"

#define GRDataServiceStartToSynchronizeAction    @"startToSynchronize"

#pragma mark - notification

#define GRAccountLoginNotification          GRPrefix ".notification.login"
#define GRAccountLogoutNotification          GRPrefix ".notification.logout"

#define GRNotificationResourceSynchronizeFinished   GRPrefix ".notification.resource.synchronized"
#define GRNotificationSermonSynchronizeFinished     GRPrefix ".notification.sermon.synchronized"

@interface GRDataService : ERService

@end
