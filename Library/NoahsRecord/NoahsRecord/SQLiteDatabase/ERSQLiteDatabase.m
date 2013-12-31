#import "ERSQLiteDatabase.h"

#import <objc/runtime.h>

#import "ERSQLiteBatchStatements.h"

#import "ERSQLiteStatement.h"

#import "ERSQLiteResultSet.h"

#import "ERSQLiteRecord.h"

static char ERSQLiteDatabaseResultSetStatementKey;

@implementation ERSQLiteDatabase

- (id)initWithFilePath: (NSString *)filePath
{
    return [self initWithFilePath: filePath
                         password: nil];
}

- (id)initWithFilePath: (NSString *)filePath 
              password: (NSString *)password
{
    return [self initWithFilePath: filePath
                         password: password
                      forceCreate: NO];
}

- (id)initWithFilePath: (NSString *)filePath 
              password: (NSString *)password
           forceCreate: (BOOL)forceCreate
{
    
    if ((!forceCreate) && (![[NSFileManager defaultManager] fileExistsAtPath: filePath]))
    {
        
        [self release];
        
        @throw [NSException exceptionWithName: @"Noah's Record Exception"
                                       reason: @"SQLite database file does not exist." 
                                     userInfo: nil];
        
    }
    
    self = [super init];
    if (self)
    {
        
        _filePath = filePath;
        [_filePath retain];
        
        if (([_filePath length] > 0 ) && (![_filePath hasPrefix: @":memory:"]))
        {
            [[NSFileManager defaultManager] createDirectoryAtPath: [filePath stringByDeletingLastPathComponent]
                                      withIntermediateDirectories: YES
                                                       attributes: nil
                                                            error: NULL];
        }
        
        //_password = password;
        //[_password retain];
        
    }
    
    return self;
}

- (id)initAtFilePath: (NSString *)filePath
{
    return [self initAtFilePath: filePath
                       password: nil];
}

- (id)initAtFilePath: (NSString *)filePath 
            password: (NSString *)password
{
    return [self initWithFilePath: filePath 
                         password: password
                      forceCreate: YES];
}

- (void)dealloc
{
    
//    [_password release];
    
    [_filePath release];
    
    [super dealloc];
}

+ (ERSQLiteDatabase *)databaseWithFilePath: (NSString *)filePath
{
    return [[[ERSQLiteDatabase alloc] initAtFilePath: filePath] autorelease];
}

+ (ERSQLiteDatabase *)databaseWithFilePath: (NSString *)filePath
                                  password: (NSString *)password
{
    return [[[ERSQLiteDatabase alloc] initAtFilePath: filePath 
                                              password: password] autorelease];
    
}

+ (ERSQLiteDatabase *)databaseAtFilePath: (NSString *)filePath
{
    return [[[ERSQLiteDatabase alloc] initWithFilePath: filePath] autorelease];
}

+ (ERSQLiteDatabase *)databaseAtFilePath: (NSString *)filePath
                                  password: (NSString *)password
{
    return [[[ERSQLiteDatabase alloc] initWithFilePath: filePath 
                                              password: password] autorelease];
    
}

- (NSString *)filePath
{
    return _filePath;
}


- (id<ERSQLBatchStatements>)prepareBatchStatements
{
    return [[[ERSQLiteBatchStatements alloc] initWithDatabase: self
                                                     password: _password] autorelease];
}

- (id<ERSQLStatement>)prepareStatementForSQL: (NSString *)sql
{
    return [ERSQLiteStatement statementFromDatabase: self
                                       withPassword: _password
                                             forSQL: sql];
}

- (void)executeStatementForSQL: (NSString *)sql
{
    [self executeStatementForSQL: sql
                  withParameters: nil];
}

- (void)executeStatementForSQL: (NSString *)sql
                withParameters: (NSArray *)parameters
{
    
    @autoreleasepool
    {
        
        ERSQLiteStatement *statement = [self prepareStatementForSQL: sql];
        
        NSInteger looper = 0;
        while (looper < [parameters count])
        {
            
            [statement setParameterAtIndex: looper asObject: [parameters objectAtIndex: looper]];
            
            ++looper;
        }
        
        [statement executeAll];
        
    }
    
}

- (id<ERSQLResultSet>)resultSetFromSQL: (NSString *)sql
{
    return [self resultSetFromSQL: sql
                   withParameters: nil];
}

- (id<ERSQLResultSet>)resultSetFromSQL: (NSString *)sql
                        withParameters: (NSArray *)parameters
{
    
    id<ERSQLResultSet> resultSet = nil;
    
    @autoreleasepool 
    {
        
        ERSQLiteStatement *statement = [self prepareStatementForSQL: sql];
        
        NSInteger looper = 0;
        while (looper < [parameters count])
        {
            [statement setParameterAtIndex: looper asObject: [parameters objectAtIndex: looper]];
            ++looper;
        }
        
        BOOL finished = NO;
        do 
        {
            finished = [statement executeUntilGetResultSet];
            
            id<ERSQLResultSet> tempResultSet = [statement currentResultSet];
            if (tempResultSet)
            {
                resultSet = tempResultSet;                
            }
            
        } while (finished);
        
        objc_setAssociatedObject(resultSet, &ERSQLiteDatabaseResultSetStatementKey, statement, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [resultSet retain];
        
    }
    
    return [resultSet autorelease];
    
}

- (id<ERSQLRecord>)recordFromSQL: (NSString *)sql
{
    return [self recordFromSQL: sql
                withParameters: nil];
}

- (id<ERSQLRecord>)recordFromSQL: (NSString *)sql
                  withParameters: (NSArray *)parameters
{
    
    id<ERSQLRecord> record = nil;
    
    @autoreleasepool 
    {
        
        id<ERSQLResultSet> resultSet = [self resultSetFromSQL: sql
                                               withParameters: parameters];
    
        [resultSet moveCursorToNextRecord];
    
        record = [resultSet currentRecord];
        
        [record retain];
        
    }

    return [record autorelease];
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
