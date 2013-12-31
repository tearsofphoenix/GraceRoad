#import "ERSQLiteDatabase+ApplicationDirectories.h"

#import "ERSQLiteDatabase.h"

@implementation ERSQLiteDatabase(ApplicationDirectories)

- (id)initWithResourceNameInApplicationDirectoryInIOS: (NSString *)name
{
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: name];
    
    return [self initWithFilePath: filePath];
}

- (id)initWithFilePathInDocumentDirectoryInIOS:(NSString *)filePath
{
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
    
	filePath = [[arrayPaths objectAtIndex:0] stringByAppendingPathComponent: filePath];
    
    return [self initWithFilePath: filePath];
}

- (id)initWithFilePathInTempDirectoryInIOS:(NSString *)filePath
{
    
	filePath = [NSTemporaryDirectory() stringByAppendingPathComponent: filePath];
    
    return [self initWithFilePath: filePath];
}

@end
