//
//  GRDatabaseService.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRDatabaseService.h"
#import "GRResourceManager.h"

#define GRLocalNotificationScheduleKey  GRPrefix ".hasScheduled"
#define GRCurrentDatabaseVersion        @"1"

@interface GRDatabaseService ()
{
    id<ERSQLDatabase> _database;
}
@end

@implementation GRDatabaseService

+ (NSString *)serviceIdentifier
{
    return GRDatabaseServiceID;
}

+ (void)load
{
    [self registerServiceClass: self];
}

- (id)init
{
    if ((self = [super init]))
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource: @"gr"
                                                               ofType: @"sqlite"];

        NSString *path = [[GRResourceManager manager] databasePath];
        NSString *databasePath = [path stringByAppendingPathComponent: @"gr.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *versionFilePath = [path stringByAppendingString: @"db_version"];
        NSError *error = nil;
        
        BOOL needUpdateDatabase = NO;
        
        if ([fileManager fileExistsAtPath: versionFilePath])
        {
            //check version
            NSString *version = [NSString stringWithContentsOfFile: versionFilePath
                                                          encoding: NSUTF8StringEncoding
                                                             error: &error];
            if ([version integerValue] < [GRCurrentDatabaseVersion integerValue])
            {
                needUpdateDatabase = YES;
            }
        }else
        {
            needUpdateDatabase = YES;
        }
        
        if (needUpdateDatabase)
        {
            //first update
            if ([fileManager fileExistsAtPath: databasePath])
            {
                [fileManager removeItemAtPath: databasePath
                                        error: &error];
                if (error)
                {
                    NSLog(@"in func: %s error: %@", __func__, error);
                }
            }
            
            [fileManager copyItemAtPath: sourcePath
                                 toPath: databasePath
                                  error: &error];
            if (error)
            {
                NSLog(@"in func: %s error: %@", __func__, error);
            }else
            {
                [GRCurrentDatabaseVersion writeToFile: versionFilePath
                                           atomically: YES
                                             encoding: NSUTF8StringEncoding
                                                error: &error];
                if (error)
                {
                    NSLog(@"in func: %s error: %@", __func__, error);
                }
            }
            
            NSLog(@"updated database!");
        }
        
        _database = [[ERSQLiteDatabase alloc] initWithFilePath: databasePath];
        
        [self _prepareLocalNotificationIfNeeded];
    }
    
    return self;
}

- (void)executeTransaction: (ERDatabaseServiceSQLExecution)transactionBlock
{
    if (transactionBlock)
    {
        @autoreleasepool
        {
            id<ERSQLBatchStatements> statement = [_database prepareBatchStatements];
            transactionBlock(statement);
        }
    }
}

- (void)_prepareLocalNotificationIfNeeded
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults objectForKey: GRLocalNotificationScheduleKey])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                       (^
                        {
                            NSDate *date = [NSDate date];
                            GRDBT(^(id<ERSQLBatchStatements> batchStatements)
                                  {
                                      id<ERSQLResultSet> resultSet = [batchStatements resultSetFromSQL: (@"select * from scripture limit 365")];
                                      NSInteger idx = 0;
                                      
                                      while ([resultSet moveCursorToNextRecord])
                                      {
                                          @autoreleasepool
                                          {
                                              id<ERSQLRecord> record = [resultSet currentRecord];
                                              
                                              NSMutableDictionary *obj = [NSMutableDictionary dictionary];
                                              NSString *address = [record stringAtColumnWithName: @"address"];
                                              [obj setObject: address
                                                      forKey: @"address"];
                                              [obj setObject: [record stringAtColumnWithName: @"en"]
                                                      forKey: @"en"];
                                              [obj setObject: [record stringAtColumnWithName: @"zh_TW"]
                                                      forKey: @"zh_TW"];
                                              
                                              UILocalNotification *notificationLooper = [[UILocalNotification alloc] init];
                                              
                                              [notificationLooper setFireDate: [date dateByAddingTimeInterval: idx * (24 * 60 * 60)]];
                                              
                                              [notificationLooper setSoundName: UILocalNotificationDefaultSoundName];
                                              [notificationLooper setUserInfo: obj];
                                              [notificationLooper setAlertBody: [NSString stringWithFormat: @"每日读经： %@", address]];
                                              
                                              [[UIApplication sharedApplication] scheduleLocalNotification: notificationLooper];                                              
                                          }
                                          
                                          ++idx;
                                      }
                                  });
                            
                            [userDefaults setObject: @YES
                                             forKey: GRLocalNotificationScheduleKey];
                            [userDefaults synchronize];
                        }));
    }
    
}

@end
