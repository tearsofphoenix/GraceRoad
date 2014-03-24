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

#define GRDataServiceAllResourcesInCategoriesAction         @"allResourcesInCategories:"
#define GRDataServiceAllResourceCategoriesAction            @"allResourceCategories"
#define GRDataServiceRefreshResourceWithCallbackAction @"_tryToSynchronizeResourcesWithCallback:"

#define GRDataServiceAllSermonCategoriesAction              @"allSermonCategories"
#define GRDataServiceAllSermonsInCategoriesAction           @"allSermonsInCategories:"

#define GRDataServiceRefreshSermonWithCallbackAction @"_tryToSynchronizeSermonWithCallback:"

#define GRDataServiceAllPrayListAction           @"allPrayList"
#define GRDataServiceAddPrayAction               @"addPray:"
#define GRDataServiceHidePrayByIDAction          @"hidePrayByID:"

#define GRDataServiceRefreshPrayWithCallbackAction @"_tryToRefreshPrayWithCallback:"

#define GRDataServiceSaveLessonForIDAction       @"saveLesson:forID:"
#define GRDataServiceLessonRecordForIDAction     @"lessonRecordForID:"

#define GRDataServiceTeamsForAccountIDAction        @"teamsForAccountID:"
#define GRDataServiceAllMemberForTeamIDAction       @"allMemberForTeamID:"

#define GRDataServiceSendPushNotificationToAccountsWithCallbackAction   @"sendPushNotification:toAccounts:callback:"
#define GRDataServiceSendMessageToWeixinAction                          @"sendMessageToWeixin:"

#define GRDataServiceExportNotificationToReminderAction         @"exportNotificationToReminder:"
#define GRDataServiceRegisterDeviceTokenAction                  @"registerDeviceToken:"

#define GRDataServiceSendFeedbackAction          @"sendFeedback:callback:"

#define GRDataServiceFetchQTDataAction           @"fetchQTData"
#define GRDataServiceRefreshQTDataAction         @"_tryToRefreshQTDataWithCallback:"

#define GRDataServiceStartToSynchronizeAction    @"startToSynchronize"

#pragma mark - notification

#define GRAccountLoginNotification          GRPrefix ".notification.login"
#define GRAccountLogoutNotification          GRPrefix ".notification.logout"

#define GRNotificationResourceSynchronizeFinished   GRPrefix ".notification.resource.synchronized"
#define GRNotificationSermonSynchronizeFinished     GRPrefix ".notification.sermon.synchronized"
#define GRNotificationPraySynchronizeFinished       GRPrefix ".notification.pray.synchronized"
#define GRNotificationQTSynchronizeFinished         GRPrefix ".notification.qt.synchronized"

#define GRPushActionKey             @"action"
#define GRPushArgumentsKey          @"args"

#define GRPushActionReminder        @"r"    //for `reminder'
#define GRPushArgumentDateKey       @"d"    //for `date'
#define GRPushArgumentOffsetKey     @"o"    //for `offset'

#define GRSavedUserNameKey      GRPrefix ".saved-user-name"

@interface GRDataService : ERService

@end
