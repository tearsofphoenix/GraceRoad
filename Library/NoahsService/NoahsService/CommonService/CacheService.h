//
//  CacheService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//
#define ERCacheServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.cache"

#define ERCacheServiceObjectForKey_Handle_InDomain_ExpirationDate_Scope_Recreation_Serialisation_Action @"objectForKey:handle:inDomain:expirationDate:scope:recreation:serialisation:"
#define ERCacheServiceUpdateObjectForKey_Handle_InDomain_ExpirationDate_Scope_Recreation_Serialisation_Action @"updateObjectForKey:handle:inDomain:expirationDate:scope:recreation:serialisation:"
#define ERCacheServiceRemoveObjectForKey_Handle_InDomain_Action @"removeObjectForKey:handle:inDomain:"
#define ERCacheServiceRemoveObjectsWithHandle_InDomain_Action @"removeObjectsWithHandle:inDomain:"
#define ERCacheServiceFlushCachesAction @"flushCaches"

#define ERCacheServiceScopePermanent @"com.eintsoft.gopher-wood.noahs-service.cache.permanent"
#define ERCacheServiceScopeSession @"com.eintsoft.gopher-wood.noahs-service.cache.session"
#define ERCacheServiceScopeTemporary @"com.eintsoft.gopher-wood.noahs-service.cache.temporary"

typedef id (^ERCacheServiceRecreation)(id oldObject, NSData *serialisedData);

typedef NSData *(^ERCacheServiceSerialisation)(id object);

