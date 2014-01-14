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
                                     GRResourcePath : @"1.html",
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
                                GRSermonPath : @"t0101.mp3",
                                GRSermonTitle : @"教导孩子",
                                GRSermonAbstract : @"1. 起初　神创造天地。\n"
                                "2. 地是空虚混沌．渊面黑暗．　神的灵运行在水面上。\n"
                                "3. 　神说、要有光、就有了光。\n"
                                "4. 　神看光是好的、就把光暗分开了。\n",
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: GRCurrentAccountKey];
    
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

@end
