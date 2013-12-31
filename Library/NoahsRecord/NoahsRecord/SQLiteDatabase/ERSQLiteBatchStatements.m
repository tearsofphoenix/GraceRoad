//
//  ERSQLiteBatchStatements.m
//  Nutricia
//
//  Created by Minun Dragonation on 5/15/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERSQLiteBatchStatements.h"

#include <sqlite3.h>

#import "ERSQLResultSet.h"

#import "ERSQLiteDatabase.h"

#import "ERSQLStatement.h"

#import "ERSQLiteStatement.h"

#import "ERSQLRecord.h"

@implementation ERSQLiteBatchStatements

- (id)initWithDatabase: (ERSQLiteDatabase *)database
              password: (NSString *)password
{
    
    self = [super init];
    if (self)
    {
        
        _database = database;
        
        [_database retain];
        
        _password = password;
        
        [_password retain];

        _rawConnection = NULL;
        
        int status = sqlite3_open([[_database filePath] UTF8String], &_rawConnection);
        
        if (status != SQLITE_OK)
        {
            @throw [NSException exceptionWithName: @"Noah's Record Exception"
                                           reason: @"Failed to start batch statements."
                                         userInfo: nil];
        }
        
        _statements = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)dealloc
{
    
    [_currentResultSet release];
    
    [_currentStatement release];
    
    [_statements release];
    
    sqlite3_close(_rawConnection);
    
    [_password release];
    
    [_database release];

    [super dealloc];
}

- (void)addStatement: (NSString *)statement 
      withParameters: (NSArray *)parameters
{
    
    NSMutableArray *finalStatement = [NSMutableArray arrayWithObject: statement];
    
    [finalStatement addObjectsFromArray: parameters];
    
    [_statements addObject: finalStatement];
    
}

- (BOOL)executeOnce
{
    
    if (!_currentStatement)
    {
        
        if (_nextStatementIndex < [_statements count])
        {

            NSArray *statement = [_statements objectAtIndex: _nextStatementIndex];
            
            _currentStatement = [[ERSQLiteStatement alloc] initFromDatabase: _database
                                                               withPassword: _password
                                                              rawConnection: _rawConnection
                                                                     forSQL: [statement objectAtIndex: 0]];
            
            NSInteger looper = 1;
            while (looper < [statement count])
            {
                
                [_currentStatement setParameterAtIndex: looper - 1
                                              asObject: [statement objectAtIndex: looper]];
                
                ++looper;
            }
            
            ++_nextStatementIndex;
        }
        
    }
    
    if (_currentStatement)
    {
        
        BOOL hasNextExecution = [_currentStatement executeOnce];
        
        [_currentResultSet release];
        
        _currentResultSet = [_currentStatement currentResultSet];
        
        [_currentResultSet retain];
        
        if (hasNextExecution)
        {
            return YES;
        }
        else
        {
            
            [_currentStatement release];
            
            _currentStatement = nil;
            
            return _nextStatementIndex < [_statements count];
            
        }
        
    }
    else
    {
        return NO;
    }
    
}

- (BOOL)executeUntilGetResultSet
{
    
    BOOL result = NO;
    
    do
    {
        
        result = [self executeOnce];
        
    } while (result && (!_currentResultSet));
    
    return result;
}

- (void)executeAll
{
    while ([self executeOnce]);   
}

- (void)flushStatements
{
    
    if (_nextStatementIndex > 0)
    {
        
        [_statements removeObjectsInRange: NSMakeRange(0, _nextStatementIndex)];

        _nextStatementIndex = 0;
        
        [_currentStatement release];
        
        _currentStatement = nil;
        
        [_currentResultSet release];
        
        _currentResultSet = nil;
        
    }
    
}

- (id<ERSQLResultSet>)currentResultSet
{
    return _currentResultSet;
}

- (void)executeStatementForSQL: (NSString *)sql
{
    [self executeStatementForSQL: sql
                  withParameters: nil];
}

- (void)executeStatementForSQL: (NSString *)sql
                withParameters: (NSArray *)parameters
{

    [self addStatement: sql
        withParameters: parameters];

    [self executeAll];

}

- (id<ERSQLResultSet>)resultSetFromSQL: (NSString *)sql
{
    return [self resultSetFromSQL: sql
                   withParameters: nil];
}

- (id<ERSQLResultSet>)resultSetFromSQL: (NSString *)sql
                        withParameters: (NSArray *)parameters
{
    [self executeAll];

    [self addStatement: sql withParameters: parameters];

    [self executeUntilGetResultSet];

    return [self currentResultSet];

}

- (id<ERSQLRecord>)recordFromSQL: (NSString *)sql
{
    return [self recordFromSQL: sql
                withParameters: nil];
}

- (id<ERSQLRecord>)recordFromSQL: (NSString *)sql
                  withParameters: (NSArray *)parameters
{

    id<ERSQLResultSet> resultSet = [self resultSetFromSQL: sql
                                           withParameters: parameters];

    [resultSet moveCursorToNextRecord];

    return [resultSet currentRecord];

}

- (id)objectFromSQL: (NSString *)sql
{
    return [self objectFromSQL: sql
                withParameters: nil];
}

- (id)objectFromSQL: (NSString *)sql
     withParameters: (NSArray *)parameters
{

    return [[self recordFromSQL: sql
                 withParameters: parameters] objectAtColumnWithIndex: 0];
}

- (NSDate *)dateFromSQL: (NSString *)sql
{
    return [self dateFromSQL: sql withParameters: nil];
}

- (NSDate *)dateFromSQL: (NSString *)sql
         withParameters: (NSArray *)parameters
{
    return [[self recordFromSQL: sql
                 withParameters: parameters] dateAtColumnWithIndex: 0];
}

- (NSString *)stringFromSQL: (NSString *)sql
{
    return [self stringFromSQL: sql
                withParameters: nil];
}

- (NSString *)stringFromSQL: (NSString *)sql
             withParameters: (NSArray *)parameters
{
    return [[self recordFromSQL: sql
                 withParameters: parameters] stringAtColumnWithIndex: 0];
}

- (NSData *)dataFromSQL: (NSString *)sql
{
    return [self dataFromSQL: sql
              withParameters: nil];
}

- (NSData *)dataFromSQL: (NSString *)sql
         withParameters: (NSArray *)parameters
{
    return [[self recordFromSQL: sql
                 withParameters: parameters] dataAtColumnWithIndex: 0];
}

- (long long)integerValueFromSQL: (NSString *)sql
{
    return [self integerValueFromSQL: sql
                      withParameters: nil];
}

- (long long)integerValueFromSQL: (NSString *)sql
                  withParameters: (NSArray *)parameters
{
    return [[self recordFromSQL: sql
                 withParameters: parameters] integerValueAtColumnWithIndex: 0];
}

- (double)floatValueFromSQL: (NSString *)sql
{
    return [self floatValueFromSQL: sql
                    withParameters: nil];
}

- (double)floatValueFromSQL:(NSString *)sql
             withParameters:(NSArray *)parameters
{
    return [[self recordFromSQL: sql
                 withParameters: parameters] floatValueAtColumnWithIndex: 0];
}

@end
