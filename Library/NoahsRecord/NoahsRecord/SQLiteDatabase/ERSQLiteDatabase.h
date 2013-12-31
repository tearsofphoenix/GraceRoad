#import <Foundation/Foundation.h>

#import "ERSQLDatabase.h"

@interface ERSQLiteDatabase: NSObject<ERSQLDatabase>
{
    
    NSString *_filePath;
    
    NSString *_password;
    
}

- (id)initWithFilePath: (NSString *)filePath;

- (id)initWithFilePath: (NSString *)filePath 
              password: (NSString *)password;

- (id)initAtFilePath: (NSString *)filePath;

- (id)initAtFilePath: (NSString *)filePath 
            password: (NSString *)password;

+ (ERSQLiteDatabase *)databaseWithFilePath: (NSString *)filePath;

+ (ERSQLiteDatabase *)databaseWithFilePath: (NSString *)filePath
                                  password: (NSString *)password;

+ (ERSQLiteDatabase *)databaseAtFilePath: (NSString *)filePath;

+ (ERSQLiteDatabase *)databaseAtFilePath: (NSString *)filePath
                                password: (NSString *)password;

- (NSString *)filePath;

@end
