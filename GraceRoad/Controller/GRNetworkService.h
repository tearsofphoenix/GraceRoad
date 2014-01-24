//
//  GRNetworkService.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-22.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <NoahsService/NoahsService.h>
#import "GRShared.h"

#define GRNetworkServiceID  GRPrefix ".service.network"

#define GRNetworkActionKey              @"action"
#define GRNetworkArgumentsKey           @"arguments"
#define GRNetworkStatusKey              @"status"
#define GRNetworkDataKey                @"data"
#define GRNetworkMessageIDKey           @"messageID"
#define GRNetworkMessageHashKey         @"messageHash"
#define GRNetworkLastUpdateKey          @"last_update"

#define GRNetworkStatusOKValue          @"0"

@interface GRNetworkService : ERService

+ (void)postMessage: (NSDictionary *)parameters
           callback: (ERServiceCallback)callback;

@end
