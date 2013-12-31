//
//  ERSQLBatchStatements.h
//  Nutricia
//
//  Created by Minun Dragonation on 5/15/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ERSQLResultSet;
@protocol ERSQLRecord;

@protocol ERSQLBatchStatements<NSObject>

- (void)addStatement: (NSString *)statement withParameters: (NSArray *)parameters;

- (BOOL)executeOnce;

- (BOOL)executeUntilGetResultSet;

- (void)executeAll;

- (void)flushStatements;

- (id<ERSQLResultSet>)currentResultSet;

- (void)executeStatementForSQL: (NSString *)sql;

- (void)executeStatementForSQL: (NSString *)sql
                withParameters: (NSArray *)parameters;

- (id<ERSQLResultSet>)resultSetFromSQL: (NSString *)sql;

- (id<ERSQLResultSet>)resultSetFromSQL: (NSString *)sql
                        withParameters: (NSArray *)parameters;

- (id<ERSQLRecord>)recordFromSQL: (NSString *)sql;

- (id<ERSQLRecord>)recordFromSQL: (NSString *)sql
                  withParameters: (NSArray *)parameters;

- (id)objectFromSQL: (NSString *)sql;

- (id)objectFromSQL: (NSString *)sql
     withParameters: (NSArray *)parameters;

- (NSDate *)dateFromSQL: (NSString *)sql;

- (NSDate *)dateFromSQL: (NSString *)sql
         withParameters: (NSArray *)parameters;

- (NSString *)stringFromSQL: (NSString *)sql;

- (NSString *)stringFromSQL: (NSString *)sql
             withParameters: (NSArray *)parameters;

- (NSData *)dataFromSQL: (NSString *)sql;

- (NSData *)dataFromSQL: (NSString *)sql
         withParameters: (NSArray *)parameters;

- (long long)integerValueFromSQL: (NSString *)sql;

- (long long)integerValueFromSQL: (NSString *)sql
                  withParameters: (NSArray *)parameters;

- (double)floatValueFromSQL: (NSString *)sql;

- (double)floatValueFromSQL: (NSString *)sql
             withParameters: (NSArray *)parameters;

@end
