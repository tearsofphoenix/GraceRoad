#import "ERSQLiteResultSet.h"

#import <sqlite3.h>

#import "ERSQLiteSimpleStatement.h"
#import "ERSQLiteRecord.h"

@implementation ERSQLiteResultSet

- (id)initFromSimpleStatement: (ERSQLiteSimpleStatement *)simpleStatement
{

    self = [super init];
    if (self)
    {
        
        _simpleStatement = simpleStatement;
        
        [_simpleStatement retain];
        
        _ended = NO;
        
    }
    
    return self;
}

- (void)dealloc
{

    [_currentRecord release];

    [_simpleStatement release];
    
    [super dealloc];
}

+ (ERSQLiteResultSet *)resultSetFromSimpleStatement: (ERSQLiteSimpleStatement *)simpleStatement
{
    return [[[ERSQLiteResultSet alloc] initFromSimpleStatement: simpleStatement] autorelease];
}

- (id<ERSQLRecord>)currentRecord
{
    return _currentRecord;
}

- (NSArray *)fetchRecords
{
    
    if (_fetched)
    {
        return nil;
    }
    else
    {
        
        NSMutableArray *result = [NSMutableArray array];
        
        while ([self moveCursorToNextRecord])
        {
            [result addObject: _currentRecord];
        }
        
        return result;
    }
    
}

- (BOOL)moveCursorToNextRecord
{
    return [self moveCursorBy: 1];
}

- (BOOL)moveCursorBy: (NSUInteger)offset
{
    
    _fetched = YES;
    
    sqlite3_stmt *rawStatement = [_simpleStatement rawStatement];
    
    while (offset > 0)
    {
    
        int status = sqlite3_step(rawStatement);
        while (status == SQLITE_BUSY)
        {

            [NSThread sleepForTimeInterval: 0.001];
            
            status = sqlite3_step(rawStatement);
            
        }
        
        if (status != SQLITE_ROW)
        {
            
            if ((status != SQLITE_DONE) && (status != SQLITE_OK))
            {
                @throw [NSException exceptionWithName: @"Noah's Record" 
                                               reason: @"Failed to fetch records in SQLite database." 
                                             userInfo: nil];
            }
            
            _ended = YES;
            
            return NO;
        }
        
        ++_position;
        
        --offset;
    }
    
    [_currentRecord release];

    _currentRecord = [[ERSQLiteRecord alloc] init];
    
    int columnCount = sqlite3_data_count(rawStatement);
    int looper = 0;
    while (looper < columnCount)
    {
        
        NSString *name = [NSString stringWithUTF8String: sqlite3_column_name(rawStatement, looper)];
        NSObject *value = nil;
        
        switch (sqlite3_column_type(rawStatement, looper))
        {
                
            case SQLITE_TEXT:
            {
                
                value = [NSString stringWithUTF8String: (const char*)sqlite3_column_text(rawStatement, looper)];
                
                break;
            }
                
            case SQLITE_INTEGER:
            {
                
                value = [NSNumber numberWithLongLong: sqlite3_column_int64(rawStatement, looper)];
                
                break;
            }
                
            case SQLITE_FLOAT:
            {
                
                value = [NSNumber numberWithDouble: sqlite3_column_double(rawStatement, looper)];
                
                break;
            }
                
            case SQLITE_BLOB:
            {
                
                value = [NSData dataWithBytes: sqlite3_column_blob(rawStatement, looper) 
                                       length: sqlite3_column_bytes(rawStatement, looper)];
                
                break;
            }
                
            case SQLITE_NULL:
            default:
            {
                
                value = nil;
                
                break;
            }
                
        }
        
        [_currentRecord setValue: value atColumn: looper withName: name];
        
        ++looper;
    }
    
    return YES;
    
}

- (BOOL)atTheEndOfResultSet
{
    return _ended;
}

@end
