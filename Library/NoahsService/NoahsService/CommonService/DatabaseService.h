//
//  DatabaseService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//
#define ERDatabaseServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.database"

#define ERDatabaseServiceRegisterRealDatabaseWithIdentifier_OriginalPath_FinalPathFormat_Action @"registerRealDatabaseWithIdentifier:originalPath:finalPathFormat:"
#define ERDatabaseServiceRegisterVirtualDatabaseWithIdentifier_SubdatabaseConfigurations_SubdatabaseNameForParameter_Action @"registerVirtualDatabaseWithIdentifier:subdatabaseConfigurations:subdatabaseNameForParameter:"
#define ERDatabaseServiceLoadDatabaseSettingsAtFilePath_InBundle_Action @"loadDatabaseSettingsAtFilePath:inBundle:"
#define ERDatabaseServiceExecute_ForDatabaseIdentifier_Action @"execute:forDatabaseIdentifier:"
#define ERDatabaseServiceExecuteExclusively_ForDatabaseIdentifier_Action @"executeExclusively:forDatabaseIdentifier:"
#define ERDatabaseServiceExecuteTransaction_ForDatabaseIdentifier_Action @"executeTransaction:forDatabaseIdentifier:"

@protocol ERSQLBatchStatements;
typedef void (^ERDatabaseServiceSQLExecution)(id<ERSQLBatchStatements> batchStatements);
typedef void (^ERDatabaseServiceFileProcedure)(NSDictionary *fileMap);

static inline void ERDB(NSString *databaseIdentifier, ERDatabaseServiceSQLExecution execution)
{
    
    id executionBlock = nil;
    if (execution)
    {
        executionBlock = [execution copy];
    }
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          executionBlock ?: [NSNull null],
                          databaseIdentifier ?: [NSNull null],
                          nil];
    
    ERSSC(ERDatabaseServiceIdentifier,
          ERDatabaseServiceExecute_ForDatabaseIdentifier_Action,
          arguments);
    
}

static inline void ERDBE(NSString *databaseIdentifier, ERDatabaseServiceSQLExecution execution)
{
    
    id executionBlock = nil;
    if (execution)
    {
        executionBlock = [execution copy];
    }
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          executionBlock ?: [NSNull null],
                          databaseIdentifier ?: [NSNull null],
                          nil];
    
    ERSSC(ERDatabaseServiceIdentifier,
          ERDatabaseServiceExecuteExclusively_ForDatabaseIdentifier_Action,
          arguments);
    
}

static inline void ERDBT(NSString *databaseIdentifier, ERDatabaseServiceSQLExecution execution)
{
    
    id executionBlock = nil;
    if (execution)
    {
        executionBlock = [execution copy];
    }
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          executionBlock ?: [NSNull null],
                          databaseIdentifier ?: [NSNull null],
                          nil];
    
    ERSSC(ERDatabaseServiceIdentifier,
          ERDatabaseServiceExecuteTransaction_ForDatabaseIdentifier_Action,
          arguments);
    
}
