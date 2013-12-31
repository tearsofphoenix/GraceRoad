#import "ERSQLStatement.h"

#import "ERSQLiteDatabase.h"
#import "ERSQLiteStatement.h"
#import "ERSQLiteResultSet.h"

#import "ERSQLiteSimpleStatement.h"

typedef void (^ERSQLiteStatementValueSetter)(ERSQLiteSimpleStatement *statement, NSUInteger index);

@implementation ERSQLiteStatement

- (id)initFromDatabase: (ERSQLiteDatabase *)database 
          withPassword: (NSString *)password
                forSQL: (NSString *)sql
{

    return [self initFromDatabase: database 
                     withPassword: password
                    rawConnection: NULL
                           forSQL: sql];

}

- (id)initFromDatabase: (ERSQLiteDatabase *)database 
          withPassword: (NSString *)password
         rawConnection: (sqlite3 *)rawConnection
                forSQL: (NSString *)sql
{

    
    self = [super init];
    if (self)
    {
        
        _database = database;
        
        [_database retain];
        
        _sql = [sql stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        [_sql retain];
        
        _nextStatement = [_sql UTF8String];
        
        if (rawConnection)
        {
            
            _rawConnection = rawConnection;
            
            _selfManagedRawConnection = NO;
            
        }
        else
        {
            
            _selfManagedRawConnection = YES;

            int status = sqlite3_open([[_database filePath] UTF8String], &_rawConnection);
            while (status == SQLITE_BUSY)
            {
                
                sqlite3_close(_rawConnection); 
                
                _rawConnection = NULL;

                [NSThread sleepForTimeInterval: 0.001];
                
                status = sqlite3_open([[_database filePath] UTF8String], &_rawConnection);
                
            }
            
            if(status != SQLITE_OK)
            {
                
                NSString *errorMessage = [NSString stringWithUTF8String: sqlite3_errmsg(_rawConnection)];
                
                sqlite3_close(_rawConnection);   
                
                [self release];
                
                @throw [NSException exceptionWithName: @"Failed to open SQLite database." 
                                               reason: errorMessage
                                             userInfo: nil];
            }
            
            /*
             if (password)
             {
             
             const char* key = [password UTF8String];
             
             sqlite3_key(_rawConnection, key, strlen(key));
             
             if (sqlite3_exec(_rawConnection, 
             [@"SELECT count(*) FROM sqlite_master;" UTF8String], 
             NULL, 
             NULL, 
             NULL) != SQLITE_OK) 
             {
             @throw [NSException exceptionWithName: @"Noah's Record Exception" 
             reason: @"Incorrect password for SQLite database." 
             userInfo: nil];
             }
             
             }
             */
            
        }
        
        _parameters = [[NSMutableArray alloc] init];
        
    }

    return self;
    
}

- (void)dealloc
{
    
    [_currentResultSet release];
    
    [_parameters release];
    
    if (_selfManagedRawConnection)
    {
        if (_rawConnection)
        {
            sqlite3_close(_rawConnection);   
        }
    }
    
    [_sql release];
    
    [_database release];
    
    [super dealloc];    
}

+ (ERSQLiteStatement *)statementFromDatabase: (ERSQLiteDatabase *)database 
                                withPassword: (NSString *)password
                                      forSQL: (NSString *)sql
{
    return [[[ERSQLiteStatement alloc] initFromDatabase: database
                                           withPassword: password
                                                 forSQL: sql] autorelease];
}

- (NSString *)sql
{
    return self->_sql;
}

- (sqlite3 *)rawConnection
{
    return _rawConnection;
}

- (void)setParameterAtIndex:(NSUInteger)index asObject: (id)object
{
    
    while ([_parameters count] <= index)
    {
        [_parameters addObject: [NSNull null]];
    }
    
    if (!object)
    {
        object = [NSNull null];
    }
    
    [_parameters replaceObjectAtIndex: index withObject: object];
    
}

- (void)setParameterAtIndex: (NSUInteger)index asData: (NSData *)data
{
    [self setParameterAtIndex: index asObject: data];
}

- (void)setParameterAtIndex: (NSUInteger)index asDate: (NSDate *)date
{
    [self setParameterAtIndex: index asObject: date];
}

- (void)setParameterAtIndex: (NSUInteger)index asString: (NSString *)string
{
    [self setParameterAtIndex: index asObject: string];
}

- (void)setParameterAtIndex: (NSUInteger)index asIntegerValue: (long long)value
{
    [self setParameterAtIndex: index 
                     asObject: [NSNumber numberWithLongLong: value]];
}

- (void)setParameterAtIndex: (NSUInteger)index asFloatValue: (double)value
{
    [self setParameterAtIndex: index 
                     asObject: [NSNumber numberWithDouble: value]];
}

- (BOOL)executeOnce
{
    
    if (_nextStatement && (*_nextStatement))
    {
        
        ERSQLiteSimpleStatement *simpleStatement = [ERSQLiteSimpleStatement statementWithUTF8SQLString: _nextStatement 
                                                                                             managedBy: self 
                                                                                         returningRest: &_nextStatement];
        NSUInteger looper = 0;
        while (looper < [simpleStatement parametersCount])
        {
            
            [simpleStatement setParameterAtIndex: looper
                                        asObject: [_parameters objectAtIndex: _parameterUsed + looper]];
            
            ++looper;
        }
        
        _parameterUsed += [simpleStatement parametersCount];
        
        [simpleStatement execute];
        
        [_currentResultSet release];
        
        _currentResultSet = [simpleStatement resultSet];
        
        [_currentResultSet retain];
        
        return YES;
    }
    else 
    {
        
        [_currentResultSet release];
        
        _currentResultSet = nil;

        return NO;
    }
    
}

- (void)executeAll
{
    while ([self executeOnce]);
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

- (id<ERSQLResultSet>)currentResultSet
{
    return _currentResultSet;
}

@end
