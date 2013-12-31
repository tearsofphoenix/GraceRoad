#import <Foundation/Foundation.h>

@protocol ERSQLRecord;

@protocol ERSQLResultSet<NSObject>

- (id<ERSQLRecord>)currentRecord;

- (NSArray *)fetchRecords;

- (BOOL)moveCursorToNextRecord;

- (BOOL)moveCursorBy: (NSUInteger)offset;

- (BOOL)atTheEndOfResultSet;

@end