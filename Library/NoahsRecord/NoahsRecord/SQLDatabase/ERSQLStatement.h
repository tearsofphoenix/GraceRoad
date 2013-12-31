#import <Foundation/Foundation.h>

@protocol ERSQLResultSet;

@protocol ERSQLStatement <NSObject>

- (void)setParameterAtIndex: (NSUInteger)index asObject: (id)object;

- (void)setParameterAtIndex: (NSUInteger)index asData: (NSData *)data;

- (void)setParameterAtIndex: (NSUInteger)index asDate: (NSDate *)date;

- (void)setParameterAtIndex: (NSUInteger)index asString: (NSString *)string;

- (void)setParameterAtIndex: (NSUInteger)index asFloatValue: (double)value;

- (void)setParameterAtIndex: (NSUInteger)index asIntegerValue: (long long)value;

- (BOOL)executeOnce;

- (BOOL)executeUntilGetResultSet;

- (void)executeAll;

- (id<ERSQLResultSet>)currentResultSet;

@end
