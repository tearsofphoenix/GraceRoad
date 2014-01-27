//
//  GRDatabaseService.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <NoahsService/NoahsService.h>
#import <NoahsRecord/NoahsRecord.h>
#import "GRShared.h"

#define GRDatabaseServiceID                         GRPrefix ".service.database"
#define GRDatabaseServiceExecuteTransactionAction   @"executeTransaction:"


@interface GRDatabaseService : ERService

@end

static inline void GRDBT(ERDatabaseServiceSQLExecution execution)
{
    execution = Block_copy(execution);
    
    ERSSC(GRDatabaseServiceID,
          GRDatabaseServiceExecuteTransactionAction,
          @[ execution ]);
    
    Block_release(execution);
}
