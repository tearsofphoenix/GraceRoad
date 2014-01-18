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
#import "NSString+CMBExtensions.h"
#import "GRTeamKeys.h"
#import "WXApi.h"

#import <NWPushNotification/NWHub.h>

#import <NoahsUtility/NoahsUtility.h>
#import <EventKit/EventKit.h>

#define GRLocalNotificationScheduleKey  GRPrefix ".hasScheduled"
#define GRCurrentAccountKey             GRPrefix ".current-account"

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
        _resourceCategories = [[NSMutableArray alloc] init];
        _resources = [[NSMutableDictionary alloc] init];
        
        NSDictionary *typeLooper = (@{
                                      GRResourceCategoryName : @"每周作业",
                                      GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                                      });
        [_resourceCategories addObject: typeLooper];
        
        NSDate *date = [NSDate date];
        NSInteger year = [date year];
        NSInteger month = [date month];
        NSInteger day = [date day];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第一周作业",
                                     GRResourceAbstract : @"作业的内容是...",
                                     //GRResourcePath : @"1.html",
                                     GRResourcePath : @"week1.bundle",
                                     GRResourceUploadDate : date,
                                     GRResourceTypeName : GRResourceTypeHTML,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第二周作业",
                                     GRResourceAbstract : @"这是一份作业...",
                                     GRResourcePath : @"亚干犯罪.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 1],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第三周作业",
                                     GRResourceAbstract : @"需要好好做...",
                                     GRResourcePath : @"狡猾的基遍人.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 1],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        typeLooper = (@{
                        GRResourceCategoryName : @"CEF课程",
                        GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                        });
        [_resourceCategories addObject: typeLooper];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"神与约书亚同在",
                                     GRResourceAbstract : @"神与约书亚同在",
                                     GRResourcePath : @"神与约书亚同在.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 2],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"一条朱红线绳",
                                     GRResourceAbstract : @"一条朱红线绳",
                                     GRResourcePath : @"一条朱红线绳.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 2],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"围绕耶利哥城",
                                     GRResourceAbstract : @"围绕耶利哥城",
                                     GRResourcePath : @"围绕耶利哥城.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 3],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        typeLooper = (@{
                        GRResourceCategoryName : @"亞伯拉罕的故事",
                        GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                        });
        [_resourceCategories addObject: typeLooper];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"應許與順服",
                                     GRResourcePath : @"2009-01-18_Mandarin1StudyGuide.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: 2009
                                                                           month: 1
                                                                             day: 18],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"信心和眼見",
                                     GRResourcePath : @"2009-01-25_Mandarin1StudyGuide.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: 2009
                                                                           month: 1
                                                                             day: 25],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"因信為義",
                                     GRResourcePath : @"2009-02-08_Mandarin1StudyGuide.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: 2009
                                                                           month: 2
                                                                             day: 8],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        _sermonCategories = [[NSMutableArray alloc] init];
        _sermons = [[NSMutableDictionary alloc] init];
        
        NSDictionary *category = (@{
                                    GRSermonCategoryID : [[ERUUID UUID] stringDescription],
                                    GRSermonCategoryTitle : @"主日讲道",
                                    });
        NSMutableArray *categoryContent = [NSMutableArray array];
        [categoryContent addObject: (@{
                                       GRSermonID : [[ERUUID UUID] stringDescription],
                                       GRSermonPath : @"重生的生命，丰盛的人生.mp3",
                                       GRSermonTitle : @"重生的生命，丰盛的人生",
                                       GRSermonAbstract : @"人失去神之后，对祝福的观念已经变质了。人无法对幸福有正确的认识与标准，专在肉身与暂时的亨通顺利找寻幸福。另外，人也对自己真正的问题也失去了知觉。鱼活着没有水，树没有泥土不能生长，人却没有意识到他离开那全善全爱的上帝是最大的问题。事实上，神赐下基督，将祂救恩的启示显明，使人再次得见而认识神。认识了神之后，人当要重新认识与设计自己的人生，好跟从这位神，才得以享受在祂里头的丰盛生命。因为基督来乃是叫人得生命，并且得的更丰盛。",
                                       GRSermonUploadDate : [NSDate date],
                                       })];
        
        [categoryContent addObject: (@{
                                       GRSermonID : [[ERUUID UUID] stringDescription],
                                       GRSermonPath : @"寻见基督之人必大大地欢喜.mp3",
                                       GRSermonTitle : @"寻见基督之人必大大地欢喜",
                                       GRSermonAbstract : @"上帝已经将祂自己的生命完完整整的赐给我们了。凡在基督里重生之人，我们的好处不在祂以外。但是，如果我们要的不是基督，所寻求依靠的不是祂里头的属灵福气与大能，我们所寻求依靠的必定叫我们跌倒。这不是将来会看见的，乃是至今在不认识神的世界里都已经显明出来了。在主耶稣降临时，特别有两种因基督而被绊倒的人。",
                                       GRSermonUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 1],
                                       })];
        
        [_sermonCategories addObject: category];
        
        [_sermons setObject: categoryContent
                     forKey: category[GRSermonCategoryID]];
        
        category = (@{
                      GRSermonCategoryID : [[ERUUID UUID] stringDescription],
                      GRSermonCategoryTitle : @"专题讲道",
                      });
        categoryContent = [NSMutableArray array];
        
        [categoryContent addObject: (@{
                                       GRSermonID : [[ERUUID UUID] stringDescription],
                                       GRSermonPath : @"2009-01-18_Mandarin1Audio.mp3",
                                       GRSermonTitle : @"應許與順服",
                                       GRSermonUploadDate : [NSDate dateWithYear: 2009
                                                                           month: 1
                                                                             day: 18],
                                       })];
        [categoryContent addObject: (@{
                                       GRSermonID : [[ERUUID UUID] stringDescription],
                                       GRSermonPath : @"2009-01-25_Mandarin1Audio.mp3",
                                       GRSermonTitle : @"信心和眼見",
                                       GRSermonUploadDate : [NSDate dateWithYear: 2009
                                                                           month: 1
                                                                             day: 25],
                                       })];
        
        [categoryContent addObject: (@{
                                       GRSermonID : [[ERUUID UUID] stringDescription],
                                       GRSermonPath : @"2009-02-08_Mandarin1Audio.mp3",
                                       GRSermonTitle : @"因信為義",
                                       GRSermonUploadDate : [NSDate dateWithYear: 2009
                                                                           month: 2
                                                                             day: 8],
                                       })];
        
        
        [_sermonCategories addObject: category];
        
        [_sermons setObject: categoryContent
                     forKey: category[GRSermonCategoryID]];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
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
        
        _prayList = [[NSMutableArray alloc] init];
        [_prayList addObject: (@{
                                 GRPrayTitleKey : @"为福音广传祷告",
                                 GRPrayContentKey : @"传福音是每个基督徒的使命，请为这使命献上祷告。",
                                 GRPrayUploadDateKey : [NSDate date],
                                 })];
        [_prayList addObject: (@{
                                 GRPrayTitleKey : @"为恩典教会的复兴祷告",
                                 GRPrayContentKey : @"教会需要复兴，需要在地上见证主、传扬主，请为教会献上祷告",
                                 GRPrayUploadDateKey : [NSDate date],
                                 })];
        [_prayList addObject: (@{
                                 GRPrayTitleKey : @"为自己的难处和软弱祷告",
                                 GRPrayContentKey : @"所以我们只管坦然无惧的、来到施恩的宝座前、为要得怜恤、蒙恩惠作随时的帮助。(来4:16)",
                                 GRPrayUploadDateKey : [NSDate date],
                                 })];
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
        
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType: EKEntityTypeReminder];
        if (status == EKAuthorizationStatusNotDetermined)
        {
            [_eventStore requestAccessToEntityType: EKEntityTypeReminder
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
    ERSC(GRViewServiceID,
         GRViewServiceShowLoadingIndicatorAction, nil, nil);
    
    //login
    //
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: (@{
                            GRAccountEmailKey : userName,
                            GRAccountPasswordKey : [password MD5String],
                            GRAccountIDKey : [[NSUUID UUID] UUIDString],
                            GRAccountNameKey : @"刘晓明",
                            GRAccountMobilePhoneKey : @"13671765129",
                            GRAccountQQKey : @"664943643",
                            })
                 forKey: GRCurrentAccountKey];
    
    [defaults synchronize];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),
                   (^(void)
                    {
                        ERSC(GRViewServiceID,
                             GRViewServiceHideLoadingIndicatorAction,
                             nil, nil);
                        
                        NSDictionary *scripture = [_scriptures lastObject];
                        if (scripture)
                        {
                            double delayInSeconds = 2.0;
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                            dispatch_after(popTime, dispatch_get_main_queue(),
                                           (^(void)
                                            {
                                                ERSC(GRViewServiceID, GRViewServiceShowDailyScriptureAction, @[ scripture ], nil);
                                            }));
                            
                            [_scriptures removeLastObject];
                        }
                        
                        if (callback)
                        {
                            callback(nil, nil);
                        }
                        
                        dispatch_async(dispatch_get_main_queue(),
                                       (^
                                        {
                                            [[NSNotificationCenter defaultCenter] postNotificationName: GRAccountLoginNotification
                                                                                                object: nil
                                                                                              userInfo: nil];
                                        }));
                    }));
}

- (void)addScripture: (NSDictionary *)scriptureInfo
{
    [_scriptures addObject: scriptureInfo];
}

- (NSDictionary *)currentAccount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: GRCurrentAccountKey];
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
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType: EKEntityTypeReminder];
    if (EKAuthorizationStatusAuthorized == status)
    {
        EKReminder *reminder = [[EKReminder alloc] init];
        NSString *month = [content substringWithRange: NSMakeRange(0, 2)];
        NSString *day = [content substringWithRange: NSMakeRange(2, 2)];
        NSString *eventContent = [content substringFromIndex: 4];
        
        [reminder setTitle: eventContent];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];

        [components setYear: [[NSDate date] year]];
        [components setMonth: [month integerValue]];
        [components setDay: [day integerValue]];
        
        [reminder setStartDateComponents: components];
        [components release];
        
        [reminder setCalendar: [_eventStore defaultCalendarForNewReminders]];
        
        NSError *error = nil;
        [_eventStore saveReminder: reminder
                           commit: YES
                            error: &error];
        [reminder release];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
    }
}

@end
