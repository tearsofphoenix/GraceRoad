#import <Foundation/Foundation.h>

#import "ERSQLiteDatabase.h"

@interface ERSQLiteDatabase(ApplicationDirectories)

- (id)initWithResourceNameInApplicationDirectoryInIOS: (NSString *)name;

- (id)initWithFilePathInDocumentDirectoryInIOS: (NSString *)filePath;

- (id)initWithFilePathInTempDirectoryInIOS: (NSString *)filePath;

@end
