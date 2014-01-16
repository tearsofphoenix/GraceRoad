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

#import <NoahsUtility/NoahsUtility.h>

#define GRLocalNotificationScheduleKey  GRPrefix ".hasScheduled"
#define GRCurrentAccountKey             GRPrefix ".current-account"

@interface GRDataService ()
{
    NSMutableArray *_resourceCategories;
    NSMutableDictionary *_resources;
    NSMutableArray *_sermons;
    NSMutableArray *_prayList;
    NSMutableArray *_scriptures;
    NSDictionary *_receiveTeam;
    NSArray *_receiveTeamMembers;
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
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第二周作业",
                                     GRResourceAbstract : @"这是一份作业...",
                                     GRResourcePath : @"2.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 1],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第三周作业",
                                     GRResourceAbstract : @"需要好好做...",
                                     GRResourcePath : @"3.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 1],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        typeLooper = (@{
                        GRResourceCategoryName : @"CEF培训",
                        GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                        });
        [_resourceCategories addObject: typeLooper];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"无字书",
                                     GRResourceAbstract : @"怎样向儿童传福音？",
                                     GRResourcePath : @"cef1.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 2],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"金句教导",
                                     GRResourceAbstract : @"需要让孩子能记住...",
                                     GRResourcePath : @"cef2.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 2],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"圣经故事",
                                     GRResourceAbstract : @"怎样在圣经故事中穿插福音信息...",
                                     GRResourcePath : @"cef3.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 3],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        typeLooper = (@{
                        GRResourceCategoryName : @"福音手册",
                        GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                        });
        [_resourceCategories addObject: typeLooper];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"传福音的使命",
                                     GRResourceAbstract : @"来自圣经的教导，耶稣的吩咐",
                                     GRResourcePath : @"fuyin1.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 3],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"怎样传福音",
                                     GRResourceAbstract : @"把福音的要义告诉第一次听到的人",
                                     GRResourcePath : @"fuyin2.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 4],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        _sermons = [[NSMutableArray alloc] init];
        
        [_sermons addObject: (@{
                                GRSermonID : [[ERUUID UUID] stringDescription],
                                GRSermonPath : @"重生的生命，丰盛的人生.mp3",
                                GRSermonTitle : @"重生的生命，丰盛的人生",
                                GRSermonAbstract : @"人失去神之后，对祝福的观念已经变质了。人无法对幸福有正确的认识与标准，专在肉身与暂时的亨通顺利找寻幸福。另外，人也对自己真正的问题也失去了知觉。鱼活着没有水，树没有泥土不能生长，人却没有意识到他离开那全善全爱的上帝是最大的问题。事实上，神赐下基督，将祂救恩的启示显明，使人再次得见而认识神。认识了神之后，人当要重新认识与设计自己的人生，好跟从这位神，才得以享受在祂里头的丰盛生命。因为基督来乃是叫人得生命，并且得的更丰盛。",
                                GRSermonUploadDate : [NSDate date],
                                })];
        
        [_sermons addObject: (@{
                                GRSermonID : [[ERUUID UUID] stringDescription],
                                GRSermonPath : @"sermon2.mp3",
                                GRSermonTitle : @"传福音",
                                GRSermonUploadDate : [NSDate dateWithYear: year
                                                                    month: month
                                                                      day: day - 1],
                                })];
        
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
                                     GRAccountMobilePhoneKey : @"13247777777",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"王顶君",
                                     GRAccountMobilePhoneKey : @"13347766777",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"唐义勇",
                                     GRAccountMobilePhoneKey : @"13447755777",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"仲怀玉",
                                     GRAccountMobilePhoneKey : @"13547744777",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"沈玉石",
                                     GRAccountMobilePhoneKey : @"13747722777",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"吴雷",
                                     GRAccountMobilePhoneKey : @"13847711777",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"向以平",
                                     GRAccountMobilePhoneKey : @"13947700777",
                                     }),
                                  (@{
                                     GRAccountNameKey : @"韦红芬",
                                     GRAccountMobilePhoneKey : @"13147788777",
                                     }),
                                  ]) retain];
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

- (NSArray *)allSermons
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

@end
