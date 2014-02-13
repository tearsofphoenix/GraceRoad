//
//  GRSynchronizeService.m
//  GraceRoad
//
//  Created by Lei on 14-1-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRSynchronizeService.h"
#import "GRResourceManager.h"
#import "GRConfiguration.h"
#import "GRNetworkService.h"

#import <NoahsRecord/NoahsRecord.h>

@interface GRSynchronizeService ()
{
    id<ERSQLDatabase> _database;
    NSThread *_synchronizeThread;
}
@end

@implementation GRSynchronizeService

+ (NSString *)serviceIdentifier
{
    return GRSynchronizeServiceID;
}

+ (void)load
{
    [self registerServiceClass: self];
}

- (id)init
{
    if ((self = [super init]))
    {
        NSString *path = [[GRResourceManager manager] databasePath];
        NSString *databasePath = [path stringByAppendingPathComponent: @"synchronize.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: databasePath])
        {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource: @"synchronize"
                                                                   ofType: @"sqlite"];
            NSError *error = nil;
            [fileManager copyItemAtPath: sourcePath
                                 toPath: databasePath
                                  error: &error];
            if (error)
            {
                NSLog(@"in func: %s error: %@", __func__, error);
            }
        }
        
        _database = [[ERSQLiteDatabase alloc] initWithFilePath: databasePath];
        _synchronizeThread = [[NSThread alloc] initWithTarget: self
                                                     selector: @selector(_synchronizeMain)
                                                       object: nil];
    }
    
    return self;
}

- (void)dealloc
{
    [_database release];
    
    [super dealloc];
}

- (void)addRecords: (NSArray *)records
{
    @autoreleasepool
    {
        id<ERSQLBatchStatements> statements = [_database prepareBatchStatements];
        
        for (NSDictionary *rLooper in records)
        {
            [statements addStatement: (@"insert into synchronize"
                                        "   (uuid, parameters, last_update)  "
                                        "   values(?, ?, ?);")
                      withParameters: (@[
                                         [[NSUUID UUID] UUIDString],
                                         [NSKeyedArchiver archivedDataWithRootObject: records],
                                         [GRConfiguration stringFromDate: [NSDate date]],
                                         ])];
        }
        
        [statements executeAll];
    }
}

- (void)_synchronizeData
{
    @autoreleasepool
    {
        id<ERSQLBatchStatements> statements = [_database prepareBatchStatements];
        id<ERSQLResultSet> resultSet = [statements resultSetFromSQL: (@"select * from synchronize where status='LOCAL' limit 50")];
        NSMutableArray *arguments = [NSMutableArray array];
        while ([resultSet moveCursorToNextRecord])
        {
            //TODO
        }
        
        [GRNetworkService postMessage: (@{
                                          GRNetworkActionKey : @"synchronize",
                                          GRNetworkArgumentsKey : (@{
                                                                     @"records" : arguments
                                                                     })
                                          })
                             callback: (^(NSDictionary *result, id exception)
                                        {
            
                                        })];
    }
}

- (void)_startSynchronize
{
    if (![_synchronizeThread isExecuting])
    {
        [_synchronizeThread start];
    }
    
    [self performSelector: @selector(_synchronizeData)
                 onThread: _synchronizeThread
               withObject: nil
            waitUntilDone: NO];
}

- (NSThread *)synchronizeThread
{
    return _synchronizeThread;
}

- (void)_synchronizeMain
{
    while (YES)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] runUntilDate: [NSDate distantFuture]];
        }
    }
}

@end
