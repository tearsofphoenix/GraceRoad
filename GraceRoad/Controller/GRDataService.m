//
//  GRDataService.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRDataService.h"
#import "GRResourceKey.h"
#import "GRSermonKeys.h"
#import "GRShared.h"
#import "GRPrayKeys.h"
#import "GRViewService.h"
#import "GRAccountKeys.h"
#import "GRTeamKeys.h"
#import "WXApi.h"
#import "GRFoundation.h"
#import "GRConfiguration.h"
#import "GRNetworkService.h"

#import <NWPushNotification/NWHub.h>
#import <NoahsUtility/NoahsUtility.h>
#import <EventKit/EventKit.h>

#define GRLocalNotificationScheduleKey  GRPrefix ".hasScheduled"
#define GRCurrentAccountKey             GRPrefix ".current-account"
#define GRHasRegisterDeviceKey          GRPrefix ".hasRegisteredDevice"

#define GRResourceCatogriesKey          @"resources.category"
#define GRResourceCatogryLastUpdateKey  @"resources.category.last-update"

#define GRSermonCategoriesKey           @"sermon.category"
#define GRSermonCategoryLastUpdateKey   @"sermon.category.last-update"

#define GRPrayListKey                   GRPrefix ".pray-list"
#define GRPrayLastUpdateKey             GRPrefix ".pray.last-update"

@interface GRDataService ()<NWHubDelegate>
{
    NSMutableArray *_resourceCategories;
    NSMutableDictionary *_resources;
    
    NSMutableArray *_sermonCategories;
    NSMutableDictionary *_sermons;
    NSMutableArray *_prayList;
    
    NSMutableArray *_scriptures;
    
    NSDictionary *_receiveTeam;
    NSArray *_receiveTeamMembers;
    
#pragma mark - local push
    NWHub *_hub;
    
#pragma mark - export
    EKEventStore *_eventStore;
}
@end

@implementation GRDataService

+ (void)load
{
    [self registerServiceClass: self];
}

+ (NSString *)serviceIdentifier
{
    return GRDataServiceID;
}

- (id)init
{
    if ((self = [super init]))
    {
        _scriptures = [[NSMutableArray alloc] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        _resourceCategories = [[NSMutableArray alloc] initWithArray: [userDefaults objectForKey: GRResourceCatogriesKey]];
        _resources = [[NSMutableDictionary alloc] init];
        
        NSDate *date = [NSDate date];
        
        _sermonCategories = [[NSMutableArray alloc] initWithArray: [userDefaults objectForKey: GRSermonCategoriesKey]];
        _sermons = [[NSMutableDictionary alloc] init];
        
        if (![userDefaults boolForKey: GRLocalNotificationScheduleKey])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                           (^
                            {
                                NSArray *notificationList = [[NSArray alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"notifications0"
                                                                                                                                     ofType: @"plist"]];
                                
                                [notificationList enumerateObjectsUsingBlock:
                                 (^(NSDictionary *obj, NSUInteger idx, BOOL *stop)
                                  {
                                      UILocalNotification *notificationLooper = [[UILocalNotification alloc] init];
                                      
                                      [notificationLooper setFireDate: [date dateByAddingTimeInterval: idx * (24 * 60 * 60)]];
                                      [notificationLooper setTimeZone: [NSTimeZone defaultTimeZone]];
                                      
                                      [notificationLooper setSoundName: UILocalNotificationDefaultSoundName];
                                      [notificationLooper setUserInfo: obj];
                                      
                                      [[UIApplication sharedApplication] scheduleLocalNotification: notificationLooper];
                                      
                                      [notificationLooper release];
                                      
                                      //*stop = YES;
                                  })];
                                
                                [notificationList release];
                            }));
            
            [userDefaults setBool: YES
                           forKey: GRLocalNotificationScheduleKey];
        }
        
        _prayList = [[NSMutableArray alloc] initWithArray: [userDefaults objectForKey: GRPrayListKey]];
        
        _receiveTeam = [(@{
                           GRTeamIDKey : @"8FF406E8-33A7-4374-8855-E58AC9397F2B",
                           GRTeamNameKey : @"接待组",
                           }) retain];
        _receiveTeamMembers = [(@[
                                  (@{
                                     GRAccountNameKey : @"陈晓娟",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"王顶君",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"唐义勇",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"仲怀玉",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"沈玉石",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"吴雷",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"向以平",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"韦红芬",
                                     GRAccountMobilePhoneKey : @"13671765129",
                                     GRAccountEmailKey : @"tearsofphoenix@icloud.com",
                                     }),
                                  ]) retain];
        
        _eventStore = [[EKEventStore alloc] init];
        
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType: EKEntityTypeEvent];
        if (status == EKAuthorizationStatusNotDetermined)
        {
            [_eventStore requestAccessToEntityType: EKEntityTypeEvent
                                        completion:
             (^(BOOL granted, NSError *error)
              {
                  if (granted)
                  {
                      
                  }
              })];
        }
    }
    
    return self;
}

- (void)loginUser: (NSString *)userName
         password: (NSString *)password
         callback: (ERServiceCallback)callback
{
    //login
    //
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"login",
                                      GRNetworkArgumentsKey : (@{
                                                                 @"email" : userName,
                                                                 @"password" : password,
                                                                 })
                                      })
                         callback: (^(NSDictionary *result, id exception)
                                    {
                                        if ([result[GRNetworkStatusKey] isEqualToString: GRNetworkStatusOKValue])
                                        {
                                            NSDictionary *accountInfo = result[GRNetworkDataKey];
                                            
                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            [defaults setObject: accountInfo
                                                         forKey: GRCurrentAccountKey];
                                            [defaults synchronize];
                                            
                                            callback(accountInfo, nil);
                                            
                                        }else
                                        {
                                            callback(nil, nil);
                                        }
                                        
                                        NSLog(@"%@", result);
                                        
                                    })];
}

- (void)addScripture: (NSDictionary *)scriptureInfo
{
    [_scriptures addObject: scriptureInfo];
}

- (NSDictionary *)currentAccount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: GRCurrentAccountKey][GRAccountKey];
}

- (void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey: GRCurrentAccountKey];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: GRAccountLogoutNotification
                                                        object: nil
                                                      userInfo: nil];
}

- (NSDictionary *)allResources
{
    return _resources;
}

- (NSArray *)allResourceCategories
{
    return _resourceCategories;
}

- (NSArray *)allSermonCategories
{
    return _sermonCategories;
}

- (NSDictionary *)allSermons
{
    return _sermons;
}

- (NSArray *)allPrayList
{
    return _prayList;
}

- (void)addPray: (NSDictionary *)prayInfo
{
    [_prayList insertObject: prayInfo
                    atIndex: 0];
}

- (void)saveLesson: (NSDictionary *)lesson
             forID: (NSString *)lesssonID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: lesson
                 forKey: lesssonID];
    
    [defaults synchronize];
}

- (NSDictionary *)lessonRecordForID: (NSString *)lessonID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: lessonID];
}

- (NSDictionary *)teamForAccountID: (NSString *)accountID
{
    return _receiveTeam;
}

- (NSArray *)allMemberForTeamID: (NSString *)teamID
{
    return _receiveTeamMembers;
}

- (void)sendPushNotification: (NSString *)obj
                    callback: (ERServiceCallback)callback
{
    if (!_hub)
    {
        [self _connectToPushAPN];
    }
    
    NSString *payload = [NSString stringWithFormat: @"{\"aps\":{\"alert\":\"%@\"}}", obj];
    NSString *token = @"04e7338bd3e7e3f191ffc6319b78eec9d39dcd8149bd05655c4ca55d598d8749";
    NSLog(@"Pushing..");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue,
                   (^
                    {
                        NSUInteger failed = [_hub pushPayload: payload
                                                        token: token];
                        
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
                        
                        dispatch_after(popTime, dispatch_get_main_queue(),
                                       //dispatch_async(dispatch_get_main_queue(),
                                       (^
                                        {
                                            NSUInteger failed2 = failed + [_hub flushFailed];
                                            if (!failed2)
                                            {
                                                if (callback)
                                                {
                                                    callback(nil, nil);
                                                }
                                                
                                                NSLog(@"Payload has been pushed");
                                            }else
                                            {
                                                if (callback)
                                                {
                                                    callback(nil, [NSError errorWithDomain: GRPrefix ".error"
                                                                                      code: -1
                                                                                  userInfo: (@{
                                                                                               NSLocalizedDescriptionKey : @"发送失败",
                                                                                               })]);
                                                }
                                            }
                                        }));
                    }));
}

- (void)_connectToPushAPN
{
    if (!_hub)
    {
        NWPusher *p = [[NWPusher alloc] init];
        NSURL *url = [NSBundle.mainBundle URLForResource: @"push.p12"
                                           withExtension: nil];
        
        NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue,
                       (^
                        {
                            NWPusherResult connected = [p connectWithPKCS12Data: pkcs12
                                                                       password: @"3141"
                                                                        sandbox: YES];
                            dispatch_async(dispatch_get_main_queue(),
                                           (^
                                            {
                                                if (connected == kNWPusherResultSuccess)
                                                {
                                                    NSLog(@"Connected to APN");
                                                    _hub = [[NWHub alloc] initWithPusher: p
                                                                                delegate: self];
                                                } else
                                                {
                                                    NSLog(@"Unable to connect: %@", [NWPusher stringFromResult: connected]);
                                                }
                                            }));
                        }));
    }
}

- (void)notification: (NWNotification *)notification
   didFailWithResult: (NWPusherResult)result
{
    dispatch_async(dispatch_get_main_queue(),
                   (^
                    {
                        NSLog(@"Notification could not be pushed: %@", [NWPusher stringFromResult: result]);
                    }));
    
}

- (void)sendMessageToWeixin: (NSString *)message
{
    if ([message length] > 0)
    {
        @autoreleasepool
        {
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            
            [req setText: message];
            [req setBText: YES];
            [req setScene: WXSceneSession];
            
            [WXApi sendReq: req];
            
            [req release];
        }
    }
}

- (void)exportNotificationToReminder: (NSString *)content
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType: EKEntityTypeEvent];
    if (EKAuthorizationStatusAuthorized == status)
    {
        EKEvent *event = [EKEvent eventWithEventStore: _eventStore];
        NSString *month = [content substringWithRange: NSMakeRange(0, 2)];
        NSString *day = [content substringWithRange: NSMakeRange(2, 2)];
        NSString *eventContent = [content substringFromIndex: 4];
        
        [event setTitle: eventContent];
        
        NSInteger year = [[NSDate date] year];
        NSInteger monthValue = [month integerValue];
        NSInteger dayValue = [day integerValue];
        
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate: [NSDate dateWithYear: year
                                                                        month: monthValue
                                                                          day: dayValue - 1]];
        [event addAlarm: alarm];
        [event setCalendar: [_eventStore calendarsForEntityType: EKEntityTypeEvent][0]];
        
        NSDate *startDate = [NSDate dateWithYear: year
                                           month: monthValue
                                             day: dayValue];
        [event setStartDate: startDate];
        [event setEndDate: [NSDate dateWithYear: year
                                          month: monthValue
                                            day: dayValue + 1]];
        NSError *error = nil;
        [_eventStore saveEvent: event
                          span: EKSpanFutureEvents
                        commit: YES
                         error: &error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
    }
}

- (void)sendFeedback: (NSString *)feedback
            callback: (ERServiceCallback)callback
{
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"feedback",
                                      GRNetworkArgumentsKey : (@{
                                                                 @"device_id" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                                                 @"content" : feedback
                                                                 })
                                      })
                         callback: (^(NSDictionary *result, id exception)
                                    {
                                        if (result)
                                        {
                                            NSLog(@"feedback ok!");
                                        }else
                                        {
                                            NSLog(@"feedback failed!");
                                        }
                                        
                                        if (callback)
                                        {
                                            callback(result, exception);
                                        }
                                    })];
}

- (void)registerDeviceToken: (NSString *)deviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey: GRHasRegisterDeviceKey])
    {
        UIDevice *device = [UIDevice currentDevice];
        NSString *idForVender = [[device identifierForVendor] UUIDString];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject: [device model]
                       forKey: @"model"];
        [parameters setObject: [device systemVersion]
                       forKey: @"system_version"];
        [parameters setObject: deviceToken
                       forKey: @"device_token"];
        [parameters setObject: idForVender
                       forKey: @"device_id"];
        
        [GRNetworkService postMessage: (@{
                                          GRNetworkActionKey : @"register_device",
                                          GRNetworkArgumentsKey : (@{
                                                                     @"device_id" : idForVender,
                                                                     @"device_token" : deviceToken,
                                                                     @"properties" : parameters
                                                                     })
                                          })
                             callback: (^(NSDictionary *result, id exception)
                                        {
                                            if ([result[GRNetworkStatusKey] isEqualToString: GRNetworkStatusOKValue])
                                            {
                                                [defaults setBool: YES
                                                           forKey: GRHasRegisterDeviceKey];
                                            }
                                            
                                            NSLog(@"%@", result);
                                        })];
    }
}

- (NSString *)_lastUpdateStringForKey: (NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdateString = [defaults objectForKey: key];
    if (!lastUpdateString)
    {
        lastUpdateString = [GRConfiguration stringFromDate: [NSDate dateWithYear: 2014
                                                                           month: 1
                                                                             day: 1]];
    }
    
    return lastUpdateString;
}

- (void)_tryToRefreshPrayWithCallback: (ERServiceCallback)callback
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdateString = [self _lastUpdateStringForKey: GRPrayLastUpdateKey];
    
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"fetch_pray",
                                      GRNetworkArgumentsKey : (@{
                                                                 GRNetworkLastUpdateKey : lastUpdateString
                                                                 })
                                      })
                         callback: (^(id result, id exception)
                                    {
                                        NSLog(@"in func: %s %@", __func__, result);
                                        
                                        NSArray *data = result[GRNetworkDataKey];
                                        NSString *newLastUpdateString = [GRConfiguration stringFromDate: [NSDate date]];
                                        
                                        if (data)
                                        {
                                            [defaults setObject: newLastUpdateString
                                                         forKey: GRPrayLastUpdateKey];
                                            [defaults setObject: _prayList
                                                         forKey: GRPrayListKey];
                                            [_prayList addObjectsFromArray: data];
                                            [defaults synchronize];
                                        }
                                        
                                        if (callback)
                                        {
                                            callback(_prayList, nil);
                                        }
                                    })];
}

- (void)_tryToSynchronizeResourcesWithCallback: (ERServiceCallback)callback
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdateString = [self _lastUpdateStringForKey: GRResourceCatogryLastUpdateKey];
    
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"fetch_resource_category",
                                      GRNetworkArgumentsKey : (@{
                                                                 GRNetworkLastUpdateKey : lastUpdateString
                                                                 })
                                      })
                         callback: (^(NSDictionary *result, id exception)
                                    {
                                        NSLog(@"in func: %s %@", __func__, result);
                                        
                                        NSArray *data = result[GRNetworkDataKey];
                                        if (data)
                                        {
                                            [_resourceCategories addObjectsFromArray: data];
                                            
                                            NSDictionary *category = [data lastObject];
                                            [defaults setObject: category[GRNetworkLastUpdateKey]
                                                         forKey: GRResourceCatogryLastUpdateKey];
                                            [defaults setObject: _resourceCategories
                                                         forKey: GRResourceCatogriesKey];
                                            
                                            [defaults synchronize];
                                        }
                                        
                                        NSMutableArray *resourceCategoriesCopy = [NSMutableArray arrayWithArray: _resourceCategories];
                                        if ([_resourceCategories count] > 0)
                                        {
                                            for (NSDictionary *cLooper in  _resourceCategories)
                                            {
                                                NSString *categoryID = cLooper[@"uuid"];
                                                [GRNetworkService postMessage: (@{
                                                                                  GRNetworkActionKey : @"fetch_resource",
                                                                                  GRNetworkArgumentsKey : (@{
                                                                                                             @"category_id" : categoryID,
                                                                                                             GRNetworkLastUpdateKey : [self _lastUpdateStringForKey: categoryID]
                                                                                                             })
                                                                                  })
                                                                     callback: (^(NSDictionary *result, id exception)
                                                                                {
                                                                                    NSLog(@"in func: %s %@", __func__, result);
                                                                                    
                                                                                    NSArray *resourcesInCategory = result[GRNetworkDataKey];
                                                                                    if (resourcesInCategory)
                                                                                    {
                                                                                        [_resources setObject: resourcesInCategory
                                                                                                       forKey: categoryID];
                                                                                    }
                                                                                    
                                                                                    [defaults setObject: [GRConfiguration stringFromDate: [NSDate date]]
                                                                                                 forKey: categoryID];
                                                                                    
                                                                                    [resourceCategoriesCopy removeObject: cLooper];
                                                                                    
                                                                                    if ([resourceCategoriesCopy count] == 0)
                                                                                    {
                                                                                        [defaults synchronize];
                                                                                        if (callback)
                                                                                        {
                                                                                            callback(_resourceCategories, nil);
                                                                                        }
                                                                                    }
                                                                                })];
                                            }
                                        }else
                                        {
                                            if (callback)
                                            {
                                                callback(_resourceCategories, nil);
                                            }
                                        }
                                    })];
    
}

- (void)_tryToSynchronizeSermonWithCallback: (ERServiceCallback)callback
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastUpdateString = [self _lastUpdateStringForKey: GRSermonCategoryLastUpdateKey];
    
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"fetch_sermon_category",
                                      GRNetworkArgumentsKey : (@{
                                                                 GRNetworkLastUpdateKey : lastUpdateString
                                                                 })
                                      })
                         callback: (^(NSDictionary *result, id exception)
                                    {
                                        //NSLog(@"in func: %s %@", __func__, result);
                                        
                                        NSArray *data = result[GRNetworkDataKey];
                                        if (data)
                                        {
                                            [_sermonCategories addObjectsFromArray: data];
                                            
                                            NSDictionary *category = [data lastObject];
                                            [defaults setObject: category[GRNetworkLastUpdateKey]
                                                         forKey: GRSermonCategoryLastUpdateKey];
                                            [defaults setObject: _sermonCategories
                                                         forKey: GRSermonCategoriesKey];
                                            [defaults synchronize];
                                        }
                                        
                                        NSMutableArray *sermonCategoriesCopy = [NSMutableArray arrayWithArray: _sermonCategories];
                                        if ([_sermonCategories count] > 0)
                                        {
                                            for (NSDictionary *cLooper in  _sermonCategories)
                                            {
                                                NSString *categoryID = cLooper[@"uuid"];
                                                [GRNetworkService postMessage: (@{
                                                                                  GRNetworkActionKey : @"fetch_sermon",
                                                                                  GRNetworkArgumentsKey : (@{
                                                                                                             @"category_id" : categoryID,
                                                                                                             GRNetworkLastUpdateKey : [self _lastUpdateStringForKey: categoryID]
                                                                                                             })
                                                                                  })
                                                                     callback: (^(NSDictionary *result, id exception)
                                                                                {
                                                                                    //NSLog(@"in func: %s %@", __func__, result);
                                                                                    
                                                                                    NSArray *sermonsInCategory = result[GRNetworkDataKey];
                                                                                    if (sermonsInCategory)
                                                                                    {
                                                                                        [_sermons setObject: sermonsInCategory
                                                                                                     forKey: categoryID];
                                                                                    }
                                                                                    
                                                                                    [defaults setObject: [GRConfiguration stringFromDate: [NSDate date]]
                                                                                                 forKey: categoryID];
                                                                                    
                                                                                    [sermonCategoriesCopy removeObject: cLooper];
                                                                                    
                                                                                    if ([sermonCategoriesCopy count] == 0)
                                                                                    {
                                                                                        [defaults synchronize];
                                                                                        
                                                                                        if (callback)
                                                                                        {
                                                                                            callback(_sermonCategories, nil);
                                                                                        }
                                                                                    }
                                                                                })];
                                            }
                                        }else
                                        {
                                            if (callback)
                                            {
                                                callback(_sermonCategories, nil);
                                            }
                                        }
                                    })];
}

- (void)startToSynchronize
{
    [self _tryToSynchronizeSermonWithCallback:
     (^(id result, id exception)
      {
          dispatch_async(dispatch_get_main_queue(),
                         (^
                          {
                              [[NSNotificationCenter defaultCenter] postNotificationName: GRNotificationSermonSynchronizeFinished
                                                                                  object: nil];
                          }));
          
          [self _tryToSynchronizeResourcesWithCallback:
           (^(id result, id exception)
            {
                dispatch_async(dispatch_get_main_queue(),
                               (^
                                {
                                    [[NSNotificationCenter defaultCenter] postNotificationName: GRNotificationResourceSynchronizeFinished
                                                                                        object: nil];
                                }));
                [self _tryToRefreshPrayWithCallback:
                 (^(id result, id exception)
                  {
                      dispatch_async(dispatch_get_main_queue(),
                                     (^
                                      {
                                          [[NSNotificationCenter defaultCenter] postNotificationName: GRNotificationPraySynchronizeFinished
                                                                                              object: nil];
                                      }));
                  })];
                
            })];
      })];
}

@end
