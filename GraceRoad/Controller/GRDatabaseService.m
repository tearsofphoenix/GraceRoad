//
//  GRDatabaseService.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRDatabaseService.h"
#import "GRResourceManager.h"

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
        NSString *path = [[GRResourceManager manager] databasePath];
        NSString *databasePath = [path stringByAppendingPathComponent: @"gr.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: databasePath])
        {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource: @"gr"
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
    }
    
    return self;
}

- (void)dealloc
{
    [_database release];
    
    [super dealloc];
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

@end
