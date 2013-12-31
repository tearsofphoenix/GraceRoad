#import <Foundation/Foundation.h>

#import "ERSQLRecord.h"

@interface ERSQLiteRecord: NSObject<ERSQLRecord>
{
    
    NSMutableDictionary *_valueDictionary;
    NSMutableArray *_valueArray;

}

+ (ERSQLiteRecord *)record;

- (void)setValue: (NSObject *)value atColumn: (NSUInteger)columnIndex withName: (NSString *)name;

@end
