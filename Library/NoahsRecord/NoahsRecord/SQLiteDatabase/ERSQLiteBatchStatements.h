//
//  ERSQLiteBatchStatements.h
//  Nutricia
//
//  Created by Minun Dragonation on 5/15/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ERSQLBatchStatements.h"

#import <sqlite3.h>

@class ERSQLiteDatabase;

@class ERSQLiteStatement;

@protocol ERSQLResultSet;

@interface ERSQLiteBatchStatements: NSObject<ERSQLBatchStatements>
{
    
    NSMutableArray *_statements;
    
    NSInteger _nextStatementIndex;
    
    ERSQLiteStatement *_currentStatement;
    
    id<ERSQLResultSet> _currentResultSet;

    ERSQLiteDatabase *_database;
    
    sqlite3 *_rawConnection;
    
    NSString *_password;
    
}

- (id)initWithDatabase: (ERSQLiteDatabase *)database
              password: (NSString *)password;

@end
