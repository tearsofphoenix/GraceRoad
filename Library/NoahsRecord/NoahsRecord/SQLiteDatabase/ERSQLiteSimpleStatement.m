#import "ERSQLiteSimpleStatement.h"

#import <NoahsService/NoahsService.h>

#import <NoahsUtility/NoahsUtility.h>

#import "ERSQLiteStatement.h"
#import "ERSQLiteResultSet.h"

@implementation ERSQLiteSimpleStatement

- (id)initWithUTF8SQLString: (const char *)string 
                  managedBy: (ERSQLiteStatement *)statement 
              returningRest: (const char **)rest
{

    self = [super init];
    if (self)
    {
        
        _rawStatement = NULL;
        
        if (sqlite3_prepare_v2([statement rawConnection], string, -1, &_rawStatement, rest) != SQLITE_OK)
        {
            @throw [NSException exceptionWithName: [NSString stringWithFormat: @"Failed to prepare statement: \n%@", [statement sql]]
                                           reason: [NSString stringWithUTF8String: sqlite3_errmsg([statement rawConnection])]
                                         userInfo: nil];
        }

        char *sql = (char *)calloc(*rest - string + 1, sizeof(char));

        strncpy(sql, string, *rest - string);

        _sql = [[NSString stringWithUTF8String: sql] copy];

        ERDInform(ERDatabaseServiceIdentifier,
                  @"Prepare to execute SQL: \n%@",
                  _sql);

        free(sql);
        
        _statement = statement;
        
        _executed = NO;
        
        _resultSet = nil;
        
    }
    
    return self;
    
}

- (void)dealloc
{

    [_sql release];
    
    if (_rawStatement)
    {
        sqlite3_finalize(_rawStatement);
    }
    
    [super dealloc];
    
}

+ (ERSQLiteSimpleStatement *)statementWithUTF8SQLString: (const char *)string 
                                              managedBy: (ERSQLiteStatement *)statement 
                                          returningRest: (const char **)rest
{
    return [[[ERSQLiteSimpleStatement alloc] initWithUTF8SQLString: string
                                                         managedBy: statement
                                                     returningRest: rest] autorelease];
}

- (void)setParameterAtIndex: (NSUInteger)index asObject: (id)object
{

    if ((!object) || ([object isKindOfClass: [NSNull class]]))
    {
        
        ERDInform(ERDatabaseServiceIdentifier,
                  @"  -> Prepare SQL parameter %d: null", index);

        if (sqlite3_bind_null(_rawStatement, index + 1) != SQLITE_OK)
        {
            @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                           reason: @"Failed to bind parameter in statement." 
                                         userInfo: nil];
        }

    }
    else if ([object isKindOfClass: [NSDate class]])
    {

        ERDInform(ERDatabaseServiceIdentifier,
                  @"  -> Prepare SQL parameter %d: #%@#", index, [object stringDescriptionForLocal]);

        [self setParameterAtIndex: index asDate: object];
        
    }
    else if ([object isKindOfClass: [NSData class]])
    {

        ERDInform(ERDatabaseServiceIdentifier,
                  @"  -> Prepare SQL parameter %d: <data>", index);

        [self setParameterAtIndex: index asData: object];
        
    }
    else if ([object isKindOfClass: [NSString class]])
    {

        NSString *string = [[[object stringByReplacingOccurrencesOfString: @"\\" withString: @"\\\\"]
                             stringByReplacingOccurrencesOfString: @"\n" withString: @"\\n"]
                            stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""];

        if ([string length] <= 100)
        {
            ERDInform(ERDatabaseServiceIdentifier,
                      @"  -> Prepare SQL parameter %d: \"%@\"",
                      index,
                      string);
        }
        else
        {
            ERDInform(ERDatabaseServiceIdentifier,
                      @"  -> Prepare SQL parameter %d: \"%@…\"",
                      index,
                      [string substringToIndex: 100]);
        }
        

        [self setParameterAtIndex: index asString: object];
        
    }
    else if ([object isKindOfClass: [NSNumber class]])
    {
        
        ERDInform(ERDatabaseServiceIdentifier,
                  @"  -> Prepare SQL parameter %d: %@",
                  index,
                  object);

        if ([object objCType][0] == 'q')
        {
            [self setParameterAtIndex: index asIntegerValue: [object longLongValue]];
        }
        else
        {
            [self setParameterAtIndex: index asFloatValue: [object doubleValue]];
        }
    }
    else
    {
        
        ERDReport(ERDatabaseServiceIdentifier,
                  @"  -> Failed to prepare SQL parameter %d with unknown data type %@",
                  index,
                  [object class]);

        @throw [NSException exceptionWithName: @"Noah's Record Exception"
                                       reason: @"Unknown data type for parameter setter" 
                                     userInfo: nil];
        
    }
    
}


- (void)setParameterAtIndex: (NSUInteger)index asDate: (NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    
    [self setParameterAtIndex: index asString: [formatter stringFromDate: date]];
    
    [formatter release];
}

- (void)setParameterAtIndex: (NSUInteger)index asData: (NSData *)data
{

    if (_executed)
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Parameters in the executed statement couldn't be binded again." 
                                     userInfo: nil];
    }

    if (index < sqlite3_bind_parameter_count(_rawStatement))
    {
        
        if (data)
        {
            if (sqlite3_bind_blob(_rawStatement, index + 1, [data bytes], [data length], SQLITE_TRANSIENT) != SQLITE_OK)
            {
                @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                               reason: @"Failed to bind parameter in statement." 
                                             userInfo: nil];
            }
        }
        else
        {
            if (sqlite3_bind_null(_rawStatement, index + 1) != SQLITE_OK)
            {
                @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                               reason: @"Failed to bind parameter in statement." 
                                             userInfo: nil];
            }
        }
        
    }
    else
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Bindind parameter index out of range in statement." 
                                     userInfo: nil];
    }

}

- (void)setParameterAtIndex: (NSUInteger)index asString: (NSString *)string
{
    
    if (_executed)
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Parameters in the executed statement couldn't be binded again." 
                                     userInfo: nil];
    }
    
    if (index < sqlite3_bind_parameter_count(_rawStatement))
    {
        
        if (string)
        {
            if (sqlite3_bind_text(_rawStatement, index + 1, [string UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK)
            {
                @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                               reason: @"Failed to bind parameter in statement." 
                                             userInfo: nil];
            }
        }
        else
        {
            if (sqlite3_bind_null(_rawStatement, index + 1) != SQLITE_OK)
            {
                @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                               reason: @"Failed to bind parameter in statement." 
                                             userInfo: nil];
            }
        }
        
    }
    else
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Bindind parameter index out of range in statement." 
                                     userInfo: nil];
    }
    
}

- (void)setParameterAtIndex: (NSUInteger)index asIntegerValue: (long long)value
{
    
    if (_executed)
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Parameters in the executed statement couldn't be binded again." 
                                     userInfo: nil];
    }
    
    if (index < sqlite3_bind_parameter_count(_rawStatement))
    {
        
        if (sqlite3_bind_int64(_rawStatement, index + 1, value) != SQLITE_OK)
        {
            @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                           reason: @"Failed to bind parameter in statement." 
                                         userInfo: nil];
        }
        
    }
    else
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Bindind parameter index out of range in statement." 
                                     userInfo: nil];
    }
    
}

- (void)setParameterAtIndex: (NSUInteger)index asFloatValue: (double)value
{
    
    if (_executed)
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Parameters in the executed statement couldn't be binded again." 
                                     userInfo: nil];
    }
    
    if (index < sqlite3_bind_parameter_count(_rawStatement))
    {
        
        if (sqlite3_bind_double(_rawStatement, index + 1, value) != SQLITE_OK)
        {
            @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                           reason: @"Failed to bind parameter in statement." 
                                         userInfo: nil];
        }
        
    }
    else
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception" 
                                       reason: @"Bindind parameter index out of range in statement." 
                                     userInfo: nil];
    }
    
}

- (NSUInteger)parametersCount
{
    return sqlite3_bind_parameter_count(_rawStatement);
}

- (sqlite3_stmt *)rawStatement
{
    return _rawStatement;
}

- (void)execute
{
    
    if (!_executed)
    {

        ERDInform(ERDatabaseServiceIdentifier, @"  -> Execute SQL prepared");

        _executed = YES;

        if (sqlite3_column_count(_rawStatement) > 0)
        {
            _resultSet = [ERSQLiteResultSet resultSetFromSimpleStatement: self];
        }
        else
        {
            
            int status = sqlite3_step(_rawStatement);
            while (status == SQLITE_BUSY)
            {

                [NSThread sleepForTimeInterval: 0.001];
                
                status = sqlite3_step(_rawStatement);
            
            }
            
            if ((status != SQLITE_OK) && (status != SQLITE_DONE))
            {
                
                const char *lastError = sqlite3_errmsg([_statement rawConnection]);
                
                @throw [NSException exceptionWithName: [NSString stringWithFormat: @"Noah's Record Exception: \n %s", lastError]
                                               reason: @"Failed to execute SQL statement" 
                                             userInfo: nil];
            }
            
        }
        
    }
    else 
    {
        @throw [NSException exceptionWithName: @"Noah's Record Exception"
                                       reason: @"Each SQL statement could be only executed once." 
                                     userInfo: nil];
    }

}

- (ERSQLiteResultSet *)resultSet
{
    
    if (_executed)
    {
        return _resultSet;
    }
    else
    {
        return nil;
    }
    
}

@end
