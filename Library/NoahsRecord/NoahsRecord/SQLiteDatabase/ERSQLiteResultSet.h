#import <Foundation/Foundation.h>

#import "ERSQLResultSet.h"

@class ERSQLiteSimpleStatement;
@class ERSQLiteRecord;

@interface ERSQLiteResultSet : NSObject<ERSQLResultSet> 
{
    
    NSInteger _position;
    
    BOOL _fetched;
    
    BOOL _ended;
    
    ERSQLiteRecord * _currentRecord;
    
    ERSQLiteSimpleStatement *_simpleStatement;

}

- (id)initFromSimpleStatement: (ERSQLiteSimpleStatement *)statement;

+ (ERSQLiteResultSet *)resultSetFromSimpleStatement: (ERSQLiteSimpleStatement *)statement;

@end
