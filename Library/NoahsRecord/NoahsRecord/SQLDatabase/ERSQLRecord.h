#import <Foundation/Foundation.h>

@protocol ERSQLRecord<NSObject>

- (NSData *)dataAtColumnWithIndex: (NSUInteger)columnIndex;
- (NSData *)dataAtColumnWithName: (NSString *)columnName;

- (NSDate *)dateAtColumnWithIndex: (NSUInteger)columnIndex;
- (NSDate *)dateAtColumnWithName: (NSString *)columnName;

- (id)objectAtColumnWithIndex: (NSUInteger)columnIndex;
- (id)objectAtColumnWithName: (NSString *)columnName;

- (NSString *)stringAtColumnWithIndex: (NSUInteger)columnIndex;
- (NSString *)stringAtColumnWithName: (NSString *)columnName;

- (long long)integerValueAtColumnWithIndex: (NSUInteger)columnIndex;
- (long long)integerValueAtColumnWithName: (NSString *)columnName;

- (double)floatValueAtColumnWithIndex: (NSUInteger)columnIndex;
- (double)floatValueAtColumnWithName: (NSString *)columnName;

- (NSUInteger)numberOfColumns;

@end
