#import <Foundation/Foundation.h>

#import <sqlite3.h>

@class ERSQLiteStatement;
@class ERSQLiteResultSet;

@interface ERSQLiteSimpleStatement: NSObject 
{
    
    sqlite3_stmt *_rawStatement;
    
    BOOL _executed;

    NSString *_sql;
    
    ERSQLiteResultSet *_resultSet;
    
    ERSQLiteStatement *_statement;
 
}

- (id)initWithUTF8SQLString: (const char *)string 
                  managedBy: (ERSQLiteStatement *)statement 
              returningRest: (const char **)rest;

+ (ERSQLiteSimpleStatement *)statementWithUTF8SQLString: (const char *)string 
                                              managedBy: (ERSQLiteStatement *)statement 
                                          returningRest: (const char **)rest;

- (sqlite3_stmt *)rawStatement;

- (void)setParameterAtIndex: (NSUInteger)index asObject: (id)object;

- (void)setParameterAtIndex: (NSUInteger)index asDate: (NSDate *)date;

- (void)setParameterAtIndex: (NSUInteger)index asData: (NSData *)data;

- (void)setParameterAtIndex: (NSUInteger)index asString: (NSString *)string;

- (void)setParameterAtIndex: (NSUInteger)index asFloatValue: (double)value;

- (void)setParameterAtIndex: (NSUInteger)index asIntegerValue: (long long)value;

- (NSUInteger)parametersCount;

- (void)execute;

- (ERSQLiteResultSet *)resultSet;

@end
