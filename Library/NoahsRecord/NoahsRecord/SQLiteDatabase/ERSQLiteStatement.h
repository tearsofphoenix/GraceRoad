#import <Foundation/Foundation.h>

#import <sqlite3.h>

#import "ERSQLStatement.h"

@class ERSQLiteDatabase;

@class ERSQLiteResultSet;

@interface ERSQLiteStatement: NSObject<ERSQLStatement>
{
    
    ERSQLiteDatabase *_database;
    
    NSString *_sql;
    
    const char *_nextStatement;
    
    NSUInteger _parameterUsed;
    
    sqlite3 *_rawConnection;
    
    NSMutableArray *_parameters;
    
    ERSQLiteResultSet *_currentResultSet;
    
    BOOL _selfManagedRawConnection;


}

- (id)initFromDatabase: (ERSQLiteDatabase *)database 
          withPassword: (NSString *)password
                forSQL: (NSString *)sql;

- (id)initFromDatabase: (ERSQLiteDatabase *)database 
          withPassword: (NSString *)password 
         rawConnection: (sqlite3 *)rawConnection 
                forSQL: (NSString *)sql;

+ (ERSQLiteStatement *)statementFromDatabase: (ERSQLiteDatabase *)database 
                                withPassword: (NSString *)password
                                      forSQL: (NSString *)sql;

- (sqlite3 *)rawConnection;

- (NSString *)sql;

@end
