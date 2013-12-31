#import "ERSQLiteRecord.h"

@implementation ERSQLiteRecord

- (id)init
{
    
    self = [super init];
    if (self)
    {
        _valueDictionary = [[NSMutableDictionary alloc] init];
        _valueArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (ERSQLiteRecord *)record
{
    return [[[ERSQLiteRecord alloc] init] autorelease];
}

- (void)dealloc
{
    
    [_valueArray release];
    
    [_valueDictionary release];
    
    [super dealloc];
    
}

- (void)setValue: (NSObject *)value atColumn: (NSUInteger)columnIndex withName: (NSString *)name
{
 
    while ([_valueArray count] <= columnIndex)
    {
        [_valueArray addObject: [NSNull null]];
    }

    if (!value)
    {
        value = [NSNull null];
    }
    
    [_valueDictionary setObject: value forKey: name];
    
    [_valueArray replaceObjectAtIndex: columnIndex withObject: value];
    
}

- (id)objectAtColumnWithIndex: (NSUInteger)columnIndex
{

    if (columnIndex < [_valueArray count])
    {
        
        id object = [_valueArray objectAtIndex: columnIndex];
        if ([object isKindOfClass: [NSNull class]])
        {
            return nil;
        }
        else 
        {
            return object;
        }
        
    }
    else
    {
        return nil;
    }
    
}

- (id)objectAtColumnWithName: (NSString *)columnName
{
    
    id object = [_valueDictionary objectForKey: columnName];
    if ([object isKindOfClass: [NSNull class]])
    {
        return nil;
    }
    else 
    {
        return object;
    }
    
}

- (NSData *)dataAtColumnWithIndex: (NSUInteger)columnIndex
{
    
    id object = [self objectAtColumnWithIndex: columnIndex];
    if ([object isKindOfClass: [NSData class]])
    {
        return object;
    }
    else
    {
        return nil;
    }
    
}

- (NSData *)dataAtColumnWithName: (NSString *)columnName
{
    
    id object = [self objectAtColumnWithName: columnName];
    if ([object isKindOfClass: [NSData class]])
    {
        return object;
    }
    else
    {
        return nil;
    }
    
}

static NSDateFormatter *ERSQLiteDateFormatter;

- (NSDate *)dateAtColumnWithIndex: (NSUInteger)columnIndex
{
    
    id object = [self objectAtColumnWithIndex: columnIndex];
    if ([object isKindOfClass: [NSString class]])
    {
        
        if (!ERSQLiteDateFormatter)
        {
            ERSQLiteDateFormatter = [[NSDateFormatter alloc] init];
            [ERSQLiteDateFormatter setDateFormat: @"yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSS"];
        }
		
		return [ERSQLiteDateFormatter dateFromString: object];
				        
    }
    else 
    {
        return nil;
    }
    
}

- (NSDate *)dateAtColumnWithName: (NSString *)columnName
{
    
    id object = [self objectAtColumnWithName: columnName];
    if ([object isKindOfClass: [NSString class]])
    {
        
        if (!ERSQLiteDateFormatter)
        {
            
            ERSQLiteDateFormatter = [[NSDateFormatter alloc] init];
            
            [ERSQLiteDateFormatter setDateFormat: @"yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSS"];
            
        }
		
		return [ERSQLiteDateFormatter dateFromString: object];

    }
    else 
    {
        return nil;
    }
    
}

- (NSString *)stringAtColumnWithIndex: (NSUInteger)columnIndex
{
    
    id object = [self objectAtColumnWithIndex: columnIndex];
    if ([object isKindOfClass: [NSString class]])
    {
        return object;
    }
    else
    {
        return nil;
    }
    
}

- (NSString *)stringAtColumnWithName: (NSString *)columnName
{
    
    id object = [self objectAtColumnWithName: columnName];
    if ([object isKindOfClass: [NSString class]])
    {
        return object;
    }
    else
    {
        return nil;
    }
    
}

- (long long)integerValueAtColumnWithIndex: (NSUInteger)columnIndex
{
    
    id object = [self objectAtColumnWithIndex: columnIndex];
    if ([object isKindOfClass: [NSNumber class]])
    {
        return [object longLongValue];
    }
    else
    {
        return 0;
    }
    
}

- (long long)integerValueAtColumnWithName: (NSString *)columnName
{
    
    id object = [self objectAtColumnWithName: columnName];
    if ([object isKindOfClass: [NSNumber class]])
    {
        return [object longLongValue];
    }
    else
    {
        return 0;
    }
    
}

- (double)floatValueAtColumnWithIndex: (NSUInteger)columnIndex
{
    
    id object = [self objectAtColumnWithIndex: columnIndex];
    if ([object isKindOfClass: [NSNumber class]])
    {
        return [object doubleValue];
    }
    else
    {
        return 0;
    }

}

- (double)floatValueAtColumnWithName: (NSString *)columnName
{
    
    id object = [self objectAtColumnWithName: columnName];
    if ([object isKindOfClass: [NSNumber class]])
    {
        return [object doubleValue];
    }
    else
    {
        return 0;
    }
    
}

- (NSUInteger)numberOfColumns
{
    return [_valueArray count];
}

@end
