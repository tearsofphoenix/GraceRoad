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
#import "GRDatabaseService.h"
#import "GRSynchronizeService.h"
#import "Reachability.h"

#import <NoahsUtility/NoahsUtility.h>
#import <EventKit/EventKit.h>

#define GRCurrentAccountKey             GRPrefix ".current-account"
#define GRHasRegisterDeviceKey          GRPrefix ".hasRegisteredDevice"

#define GRResourceCatogryLastUpdateKey      GRPrefix @".resources.category.last-update"
#define GRResourceLastUpdateKey             GRPrefix @".resources.last-update"

#define GRSermonCategoryLastUpdateKey       GRPrefix @".sermon.category.last-update"
#define GRSermonLastUpdateKey               GRPrefix @".sermon.last-update"

#define GRPrayLastUpdateKey                 GRPrefix ".pray.last-update"
#define GRAccountTeamLastUpdateKey          GRPrefix ".account-team.last-update"
#define GRTeamAccountRelationLastUpdateKey  GRPrefix ".team-account-relation.last-update"
#define GRQTLastUpdateKey                   GRPrefix ".qt.last-update"

@interface GRDataService ()
{
#pragma mark - export
    EKEventStore *_eventStore;
}

//@property (nonatomic) BOOL isSynchronize;

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
        _eventStore = [[EKEventStore alloc] init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(),
                       (^
                        {
                            [self _authorizeCalendar];
                        }));
    }
    
    return self;
}

- (void)_authorizeCalendar
{
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

- (void)_tryToRegisterRemoteNotification
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert
                                                                            | UIRemoteNotificationTypeBadge
                                                                            | UIRemoteNotificationTypeSound)];
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
                                            [defaults setObject: userName
                                                         forKey: GRSavedUserNameKey];
                                            
                                            [defaults synchronize];
                                            
                                            GRDBT(^(id<ERSQLBatchStatements> batchStatements)
                                                  {
                                                      NSArray *teams = accountInfo[GRTeamKey];
                                                      
                                                      for (NSDictionary *tLooper in teams)
                                                      {
                                                          [batchStatements addStatement: (@"insert or replace into team"
                                                                                          "  (uuid, name, properties)  "
                                                                                          "  values(?, ?, ?)           "
                                                                                          )
                                                                         withParameters: (@[
                                                                                            tLooper[GRTeamIDKey],
                                                                                            tLooper[GRTeamNameKey],
                                                                                            [NSKeyedArchiver archivedDataWithRootObject: tLooper],
                                                                                            ])];
                                                      }
                                                      
                                                      [batchStatements executeAll];
                                                  });
                                            
                                            [self _tryToRegisterRemoteNotification];
                                            [self _tryToSynchronizeTeamInfoWithCallback: callback];
                                            
                                        }else
                                        {
                                            callback(nil, nil);
                                        }
                                        
                                        NSLog(@"%@", result);
                                        
                                    })];
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

- (NSDictionary *)allResourcesInCategories: (NSArray *)categories
{
    NSMutableDictionary *resources = [NSMutableDictionary dictionary];
    
    GRDBT((^(id<ERSQLBatchStatements> batchStatements)
           {
               for (NSDictionary *cLooper in categories)
               {
                   @autoreleasepool
                   {
                       NSString *categoryID = cLooper[GRResourceCategoryID];
                       id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select properties from resource where category_id=?")
                                                                         withParameters: @[categoryID]];
                       
                       NSMutableArray *resourcesInCategory = [NSMutableArray array];
                       
                       while ([resultSet moveCursorToNextRecord])
                       {
                           id<ERSQLRecord> record = [resultSet currentRecord];
                           NSDictionary *rLooper = [NSKeyedUnarchiver unarchiveObjectWithData: [record dataAtColumnWithIndex: 0]];
                           [resourcesInCategory addObject: rLooper];
                       }
                       
                       [resources setObject: resourcesInCategory
                                     forKey: categoryID];
                   }
               }
           }));
    
    return resources;
}

- (NSArray *)allResourceCategories
{
    NSMutableArray *result = [NSMutableArray array];
    
    GRDBT((^(id<ERSQLBatchStatements> batchStatements)
           {
               id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select properties from resource_category")];
               
               while ([resultSet moveCursorToNextRecord])
               {
                   id<ERSQLRecord> record = [resultSet currentRecord];
                   NSDictionary *rLooper = [NSKeyedUnarchiver unarchiveObjectWithData: [record dataAtColumnWithIndex: 0]];
                   [result addObject: rLooper];
               }
           }));
    
    return result;
}

- (NSArray *)allSermonCategories
{
    NSMutableArray *result = [NSMutableArray array];
    
    GRDBT((^(id<ERSQLBatchStatements> batchStatements)
           {
               id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select properties from sermon_category")];
               
               while ([resultSet moveCursorToNextRecord])
               {
                   id<ERSQLRecord> record = [resultSet currentRecord];
                   NSDictionary *rLooper = [NSKeyedUnarchiver unarchiveObjectWithData: [record dataAtColumnWithIndex: 0]];
                   [result addObject: rLooper];
               }
           }));
    
    return result;
}

- (NSDictionary *)allSermonsInCategories: (NSArray *)categories
{
    NSMutableDictionary *sermons = [NSMutableDictionary dictionary];
    
    GRDBT((^(id<ERSQLBatchStatements> batchStatements)
           {
               for (NSDictionary *cLooper in categories)
               {
                   @autoreleasepool
                   {
                       NSString *categoryID = cLooper[GRSermonCategoryID];
                       id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select properties from sermon where category_id=?")
                                                                         withParameters: @[categoryID]];
                       
                       NSMutableArray *sermonInCategory = [NSMutableArray array];
                       
                       while ([resultSet moveCursorToNextRecord])
                       {
                           id<ERSQLRecord> record = [resultSet currentRecord];
                           NSDictionary *rLooper = [NSKeyedUnarchiver unarchiveObjectWithData: [record dataAtColumnWithIndex: 0]];
                           [sermonInCategory addObject: rLooper];
                       }
                       
                       [sermons setObject: sermonInCategory
                                   forKey: categoryID];
                   }
               }
           }));
    
    return sermons;
}

- (NSArray *)allPrayList
{
    NSMutableArray *result = [NSMutableArray array];
    
    GRDBT((^(id<ERSQLBatchStatements> batchStatements)
           {
               id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select properties from pray where hide=0")];
               
               while ([resultSet moveCursorToNextRecord])
               {
                   id<ERSQLRecord> record = [resultSet currentRecord];
                   NSDictionary *rLooper = [NSKeyedUnarchiver unarchiveObjectWithData: [record dataAtColumnWithIndex: 0]];
                   [result addObject: rLooper];
               }
           }));
    
    return result;
}

- (void)addPray: (NSDictionary *)prayInfo
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
    {
        [GRNetworkService postMessage: (@{
                                          GRNetworkActionKey : @"add_pray",
                                          GRNetworkArgumentsKey : prayInfo
                                          })
                             callback: nil];
    }else
    {
        ERSC(GRSynchronizeServiceID,
             GRSynchronizeAddRecordsAction,
             (@[ @[
                     (@{
                        GRNetworkActionKey : @"add_pray",
                        GRNetworkArgumentsKey : prayInfo,
                        })
                     ] ]), nil);
    }
}

- (void)hidePrayByID: (NSString *)prayID
{
    GRDBT((^(id<ERSQLBatchStatements> batchStatements)
           {
               [batchStatements executeStatementForSQL: (@"update pray set hide=1 where uuid=?")
                                        withParameters: @[ prayID ]];
           }));
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

- (NSArray *)teamsForAccountID: (NSString *)accountID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: GRCurrentAccountKey][GRTeamKey];
}

- (NSArray *)allMemberForTeamID: (NSString *)teamID
{
    NSMutableArray *result = [NSMutableArray array];
    
    GRDBT((^(id<ERSQLBatchStatements> batchStatements)
           {
               id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select account.properties from account "
                                                                                  "     left join team_account_relation    "
                                                                                  "     on account.uuid=team_account_relation.account_id "
                                                                                  "     where team_account_relation.team_id=?; "
                                                                                  )
                                                                 withParameters: @[ teamID ]];
               
               while ([resultSet moveCursorToNextRecord])
               {
                   id<ERSQLRecord> record = [resultSet currentRecord];
                   NSDictionary *rLooper = [NSKeyedUnarchiver unarchiveObjectWithData: [record dataAtColumnWithIndex: 0]];
                   [result addObject: rLooper];
               }
           }));
    
    return result;
}

- (void)sendPushNotification: (NSDictionary *)info
                  toAccounts: (NSArray *)accountIDs
                    callback: (ERServiceCallback)callback
{
    NSMutableDictionary *arguments = [NSMutableDictionary dictionaryWithDictionary: info];
    [arguments setObject: accountIDs
                  forKey: @"account_ids"];
    
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"aps_push",
                                      GRNetworkArgumentsKey : arguments
                                      })
                         callback: (^(NSDictionary *result, id exception)
                                    {
                                        if (callback)
                                        {
                                            callback(result, exception);
                                        }
                                    })];
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

- (void)exportNotificationToReminder: (NSDictionary *)userInfo
{
    NSDictionary *aps = userInfo[@"aps"];
    NSString *action = userInfo[GRPushActionKey];
    NSDictionary *args = userInfo[GRPushArgumentsKey];
    
    if ([action isEqualToString: GRPushActionReminder])
    {
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType: EKEntityTypeEvent];
        if (EKAuthorizationStatusAuthorized == status)
        {
            EKEvent *event = [EKEvent eventWithEventStore: _eventStore];
            
            NSString *dateString = args[GRPushArgumentDateKey];
            NSDate *date = [GRConfiguration dateFromString: dateString];
            NSInteger offset = [args[GRPushArgumentOffsetKey] integerValue];
            
            NSString *eventContent = aps[@"alert"];
            
            [event setTitle: eventContent];
            
            NSInteger year = [date year];
            NSInteger monthValue = [date month];
            NSInteger dayValue = [date day];
            
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate: [NSDate dateWithYear: year
                                                                            month: monthValue
                                                                              day: dayValue - offset]];
            [event addAlarm: alarm];
            EKCalendar *calendar = nil;
            NSArray *allCalendars = [_eventStore calendarsForEntityType: EKEntityTypeEvent];
            for (EKCalendar *cLooper in allCalendars)
            {
                if (![cLooper isImmutable])
                {
                    calendar = cLooper;
                    break;
                }
            }
            
            [event setCalendar: calendar];
            
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
    if (![defaults objectForKey: GRHasRegisterDeviceKey])
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
        
        NSDictionary *account = [self currentAccount];
        
        [GRNetworkService postMessage: (@{
                                          GRNetworkActionKey : @"register_device",
                                          GRNetworkArgumentsKey : (@{
                                                                     @"device_id" : idForVender,
                                                                     @"device_token" : deviceToken,
                                                                     @"account_id" : account[GRAccountIDKey],
                                                                     @"properties" : parameters
                                                                     })
                                          })
                             callback: (^(NSDictionary *result, id exception)
                                        {
                                            if ([result[GRNetworkStatusKey] isEqualToString: GRNetworkStatusOKValue])
                                            {
                                                [defaults setObject: @YES
                                                             forKey: GRHasRegisterDeviceKey];
                                                [defaults synchronize];
                                            }
                                            
                                            NSLog(@"%@", result);
                                        })];
    }
}

#pragma mark - qt

- (NSArray *)fetchQTData
{
    NSMutableArray *qtContents = [NSMutableArray arrayWithCapacity: 30];
    
    GRDBT(^(id<ERSQLBatchStatements> batchStatements)
          {
              id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select * from qt order by last_update limit 30")];
              while ([resultSet moveCursorToNextRecord])
              {
                  id<ERSQLRecord> record = [resultSet currentRecord];
                  
                  [qtContents addObject: [NSKeyedUnarchiver unarchiveObjectWithData: [record dataAtColumnWithName: @"properties"]]];
              }
          });
    
    return qtContents;
}

#pragma mark - sync

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

- (void)_tryToRefreshQTDataWithCallback: (ERServiceCallback)callback
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdateString = [self _lastUpdateStringForKey: GRQTLastUpdateKey];
    
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"fetch_qt",
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
                                                         forKey: GRQTLastUpdateKey];
                                            [defaults synchronize];
                                            
                                            GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                   {
                                                       for (NSDictionary *pLooper in data)
                                                       {
                                                           [batchStatements addStatement: (@"insert or replace into qt"
                                                                                           "    (uuid, title, last_update, properties)"
                                                                                           "    values(?, ?, ?, ?)"
                                                                                           )
                                                                          withParameters: (@[
                                                                                             pLooper[@"uuid"],
                                                                                             pLooper[@"title"] ?: [NSNull null],
                                                                                             pLooper[GRNetworkLastUpdateKey] ?: [NSNull null],
                                                                                             [NSKeyedArchiver archivedDataWithRootObject: pLooper],
                                                                                             ])];
                                                       }
                                                       
                                                       [batchStatements executeAll];
                                                   }));
                                        }
                                        
                                        if (callback)
                                        {
                                            callback(nil, nil);
                                        }
                                    })];
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
                                            [defaults synchronize];
                                            
                                            GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                   {
                                                       for (NSDictionary *pLooper in data)
                                                       {
                                                           [batchStatements addStatement: (@"insert or replace into pray"
                                                                                           "    (uuid, title, content, last_update, properties)"
                                                                                           "    values(?, ?, ?, ?, ?)"
                                                                                           )
                                                                          withParameters: (@[
                                                                                             pLooper[@"uuid"],
                                                                                             pLooper[GRPrayTitleKey] ?: [NSNull null],
                                                                                             pLooper[GRPrayContentKey] ?: [NSNull null],
                                                                                             pLooper[GRNetworkLastUpdateKey] ?: [NSNull null],
                                                                                             [NSKeyedArchiver archivedDataWithRootObject: pLooper],
                                                                                             ])];
                                                       }
                                                       
                                                       [batchStatements executeAll];
                                                   }));
                                        }
                                        
                                        if (callback)
                                        {
                                            callback(nil, nil);
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
                                        NSArray *data = result[GRNetworkDataKey];
                                        if ([data count] > 0)
                                        {
                                            
                                            GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                   {
                                                       for (NSDictionary *cLooper in data)
                                                       {
                                                           [batchStatements addStatement: (@"insert or replace into resource_category"
                                                                                           "    (uuid, name, properties)"
                                                                                           "    values(?, ?, ?);"
                                                                                           )
                                                                          withParameters: (@[cLooper[GRResourceID],
                                                                                             cLooper[GRResourceName],
                                                                                             [NSKeyedArchiver archivedDataWithRootObject: cLooper],
                                                                                             ])];
                                                       }
                                                       
                                                       [batchStatements executeAll];
                                                   }));
                                        }
                                        
                                        [defaults setObject: [GRConfiguration stringFromDate: [NSDate date]]
                                                     forKey: GRResourceCatogryLastUpdateKey];
                                        [defaults synchronize];
                                        
                                        
                                        [GRNetworkService postMessage: (@{
                                                                          GRNetworkActionKey : @"fetch_resource",
                                                                          GRNetworkArgumentsKey : (@{
                                                                                                     GRNetworkLastUpdateKey : [self _lastUpdateStringForKey: GRResourceLastUpdateKey]
                                                                                                     })
                                                                          })
                                                             callback: (^(NSDictionary *result, id exception)
                                                                        {
                                                                            NSArray *resourcesInCategory = result[GRNetworkDataKey];
                                                                            
                                                                            if ([resourcesInCategory count] > 0)
                                                                            {
                                                                                GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                                                       {
                                                                                           for (NSDictionary *rLooper in resourcesInCategory)
                                                                                           {
                                                                                               [batchStatements addStatement: (@"insert or replace into resource"
                                                                                                                               "     (uuid, category_id, name, content, path, type, properties)"
                                                                                                                               "   values(?, ?, ?, ?, ?, ?, ?)"
                                                                                                                               )
                                                                                                              withParameters: (@[
                                                                                                                                 rLooper[GRResourceID],
                                                                                                                                 rLooper[@"category_id"],
                                                                                                                                 rLooper[GRResourceName] ?: [NSNull null],
                                                                                                                                 rLooper[@"content"] ?: [NSNull null],
                                                                                                                                 rLooper[GRResourcePath],
                                                                                                                                 rLooper[GRResourceTypeKey],
                                                                                                                                 [NSKeyedArchiver archivedDataWithRootObject: rLooper],
                                                                                                                                 ])];
                                                                                           }
                                                                                           
                                                                                           [batchStatements executeAll];
                                                                                       }));
                                                                            }
                                                                            
                                                                            [defaults setObject: [GRConfiguration stringFromDate: [NSDate date]]
                                                                                         forKey: GRResourceLastUpdateKey];
                                                                            
                                                                            
                                                                            if (callback)
                                                                            {
                                                                                callback(nil, nil);
                                                                            }
                                                                        })];
                                        
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
                                        NSLog(@"in func: %s %@", __func__, result);
                                        
                                        NSArray *data = result[GRNetworkDataKey];
                                        if ([data count] > 0)
                                        {
                                            GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                   {
                                                       for (NSDictionary *cLooper in data)
                                                       {
                                                           [batchStatements addStatement: (@"insert or replace into sermon_category"
                                                                                           "    (uuid, name, properties)"
                                                                                           "    values(?, ?, ?);"
                                                                                           )
                                                                          withParameters: (@[
                                                                                             cLooper[GRSermonCategoryID],
                                                                                             cLooper[GRSermonCategoryNameKey],
                                                                                             [NSKeyedArchiver archivedDataWithRootObject: cLooper],
                                                                                             ])];
                                                       }
                                                       
                                                       [batchStatements executeAll];
                                                   }));
                                        }
                                        
                                        [defaults setObject: [GRConfiguration stringFromDate: [NSDate date]]
                                                     forKey: GRSermonCategoryLastUpdateKey];
                                        
                                        [GRNetworkService postMessage: (@{
                                                                          GRNetworkActionKey : @"fetch_sermon",
                                                                          GRNetworkArgumentsKey : (@{
                                                                                                     GRNetworkLastUpdateKey : [self _lastUpdateStringForKey: GRSermonLastUpdateKey]
                                                                                                     })
                                                                          })
                                                             callback: (^(NSDictionary *result, id exception)
                                                                        {
                                                                            NSLog(@"in func: %s %@", __func__, result);
                                                                            
                                                                            NSArray *sermonsInCategory = result[GRNetworkDataKey];
                                                                            if ([sermonsInCategory count] > 0)
                                                                            {
                                                                                GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                                                       {
                                                                                           for (NSDictionary *sLooper in sermonsInCategory)
                                                                                           {
                                                                                               [batchStatements addStatement: (@"insert or replace into sermon"
                                                                                                                               "    (uuid, category_id, image_path, title, content, audio_path, properties)"
                                                                                                                               "    values(?, ?, ?, ?, ?, ?, ?)"
                                                                                                                               )
                                                                                                              withParameters: (@[
                                                                                                                                 sLooper[GRSermonID],
                                                                                                                                 sLooper[@"category_id"],
                                                                                                                                 sLooper[@"image_path"] ?: [NSNull null],
                                                                                                                                 sLooper[GRSermonTitle] ?: [NSNull null],
                                                                                                                                 sLooper[GRSermonContent] ?: [NSNull null],
                                                                                                                                 sLooper[@"audio_path"] ?: [NSNull null],
                                                                                                                                 [NSKeyedArchiver archivedDataWithRootObject: sLooper],
                                                                                                                                 ])];
                                                                                           }
                                                                                           
                                                                                           [batchStatements executeAll];
                                                                                       }));
                                                                            }
                                                                            
                                                                            [defaults setObject: [GRConfiguration stringFromDate: [NSDate date]]
                                                                                         forKey: GRSermonLastUpdateKey];
                                                                            
                                                                            [defaults synchronize];
                                                                            
                                                                            if (callback)
                                                                            {
                                                                                callback(nil, nil);
                                                                            }
                                                                        })];
                                    })];
}

- (void)_tryToSynchronizeMembersInTeams: (NSArray *)teamIDs
                           withCallback: (ERServiceCallback)callback
{
    [GRNetworkService postMessage: (@{
                                      GRNetworkActionKey : @"get_team_members",
                                      GRNetworkArgumentsKey : (@{
                                                                 @"team_ids" : teamIDs,
                                                                 })
                                      })
                         callback: (^(NSDictionary *result, id exception)
                                    {
                                        NSDictionary *data = result[GRNetworkDataKey];
                                        if (data)
                                        {
                                            GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                   {
                                                       NSLog(@"in func: %s %@", __func__, data);
                                                       
                                                       [data enumerateKeysAndObjectsUsingBlock:
                                                        (^(NSString *teamID, NSArray *obj, BOOL *stop)
                                                         {
                                                             for (NSDictionary *mLooper in obj)
                                                             {
                                                                 [batchStatements addStatement: (@"insert or replace into account"
                                                                                                 "    (uuid, email, mobilephone, qq, wechat, name, role, properties)"
                                                                                                 "    values(?, ?, ?, ?, ?, ?, ?, ?);"
                                                                                                 )
                                                                                withParameters: (@[
                                                                                                   mLooper[GRAccountIDKey],
                                                                                                   mLooper[GRAccountEmailKey] ?: [NSNull null],
                                                                                                   mLooper[GRAccountMobilePhoneKey] ?: [NSNull null],
                                                                                                   mLooper[GRAccountQQKey] ?: [NSNull null],
                                                                                                   mLooper[GRAccountWeChatKey] ?: [NSNull null],
                                                                                                   mLooper[GRAccountNameKey] ?: [NSNull null],
                                                                                                   mLooper[GRAccountRoleKey] ?: [NSNull null],
                                                                                                   [NSKeyedArchiver archivedDataWithRootObject: mLooper],
                                                                                                   ])];
                                                             }
                                                             
                                                             [batchStatements executeAll];
                                                             
                                                         })];
                                                   }));
                                        }
                                        
                                        if (callback)
                                        {
                                            callback(data, nil);
                                        }
                                    })];
}

- (void)_tryToSynchronizeTeamInfoWithCallback: (ERServiceCallback)callback
{
    NSArray *teams = [self teamsForAccountID: nil];
    if ([teams count] > 0)
    {
        NSMutableArray *teamIDs = [[NSMutableArray alloc] initWithCapacity: [teams count]];
        for (NSDictionary *tLooper in teams)
        {
            [teamIDs addObject: tLooper[GRTeamIDKey]];
        }
        
        NSString *lastUpdateString = [self _lastUpdateStringForKey: GRTeamAccountRelationLastUpdateKey];
        
        [GRNetworkService postMessage: (@{
                                          GRNetworkActionKey : @"get_team_relations",
                                          GRNetworkArgumentsKey : (@{
                                                                     @"team_ids" : teamIDs,
                                                                     GRNetworkLastUpdateKey : lastUpdateString,
                                                                     })
                                          })
                             callback: (^(NSDictionary *result, id exception)
                                        {
                                            NSLog(@"in func: %s %@", __func__, result);
                                            
                                            NSDictionary *data = result[GRNetworkDataKey];
                                            if (data)
                                            {
                                                GRDBT((^(id<ERSQLBatchStatements> batchStatements)
                                                       {
                                                           [data enumerateKeysAndObjectsUsingBlock:
                                                            (^(NSString *teamID, NSArray *obj, BOOL *stop)
                                                             {
                                                                 for (NSDictionary *mLooper in obj)
                                                                 {
                                                                     [batchStatements addStatement: (@"insert or replace into team_account_relation"
                                                                                                     "    (uuid, team_id, account_id, role, last_update)"
                                                                                                     "    values(?, ?, ?, ?, ?);"
                                                                                                     )
                                                                                    withParameters: (@[
                                                                                                       mLooper[@"uuid"],
                                                                                                       mLooper[@"team_id"],
                                                                                                       mLooper[@"account_id"],
                                                                                                       mLooper[@"role"],
                                                                                                       mLooper[@"last_update"],
                                                                                                       ])];
                                                                 }
                                                             })];
                                                           
                                                           [batchStatements executeAll];
                                                           
                                                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                           [defaults setObject: [GRConfiguration stringFromDate: [NSDate date]]
                                                                        forKey: GRTeamAccountRelationLastUpdateKey];
                                                           [defaults synchronize];
                                                           
                                                           [self _tryToSynchronizeMembersInTeams: teamIDs
                                                                                    withCallback: callback];
                                                       }));
                                            }
                                        })];
    }
}

- (void)_startToSynchronize
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
                      [self _tryToRefreshQTDataWithCallback:
                       (^(id result, id exception)
                        {
                            dispatch_async(dispatch_get_main_queue(),
                                           (^
                                            {
                                                [[NSNotificationCenter defaultCenter] postNotificationName: GRNotificationQTSynchronizeFinished
                                                                                                    object: nil];
                                            }));
                        })];
                  })];
                
            })];
      })];
}

- (void)startToSynchronize
{
    NSThread *thread = ERSSC(GRSynchronizeServiceID,
                             GRSynchronizeServiceGetSynchronizeThreadAction,
                             nil);
    if (![thread isExecuting])
    {
        [thread start];
    }
    
    [self _startToSynchronize];
//    [self performSelector: @selector(_startToSynchronize)
//                 onThread: thread
//               withObject: nil
//            waitUntilDone: NO];
}

@end
