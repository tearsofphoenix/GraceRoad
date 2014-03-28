//
//  GRNetworkService.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-22.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRNetworkService.h"
#import "MFNetworkClient.h"
#import "GRConfiguration.h"
#import "GRFoundation.h"
#import "GRViewService.h"
#import "Reachability.h"
#import "GRUIExtensions.h"

@implementation GRNetworkService

+ (NSString *)serviceIdentifier
{
    return GRNetworkServiceID;
}

+ (void)load
{
    [self registerServiceClass: self];
}

+ (void)postMessage: (NSDictionary *)parameters
           callback: (ERServiceCallback)callback
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        if (callback)
        {
            callback(nil, [NSError errorWithDomain: GRPrefix
                                              code: -1
                                          userInfo: (@{
                                                       NSLocalizedDescriptionKey : @"网络异常！"
                                                       })]);
        }
        
        ERSC(GRViewServiceID, GRViewServiceAlertMessageAction, @[ @"请检查您的网络连接！"], nil);
    }else
    {
        @autoreleasepool
        {
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary: parameters];
            NSString *action = parameters[GRNetworkActionKey];
            
            NSString *messageID = [NSString randomStringWithLength: 8];
            
            [info setObject: messageID
                     forKey: GRNetworkMessageIDKey];
            [info setObject: [[action stringByAppendingString: messageID] MD5String]
                     forKey: GRNetworkMessageHashKey];
            
            NSString *str = [info JSONString];
            if (str)
            {
                [[MFNetworkClient sharedClient] postToURL: [GRConfiguration serverURL]
                                               parameters: (@{
                                                              @"request" : str,
                                                              })
                                                 lifeTime: 0
                                                 callback: (^(NSData *data, id error)
                                                            {
                                                                NSDictionary *result = nil;
                                                                if (data)
                                                                {
                                                                    result = [data JSONObject];
                                                                    if (!result)
                                                                    {
                                                                        NSString *response = [[NSString alloc] initWithData: data
                                                                                                                   encoding: NSUTF8StringEncoding];
                                                                        NSLog(@"in func: %s network: %@", __func__, response);
                                                                    }
                                                                }
                                                                
                                                                if (callback)
                                                                {
                                                                    callback(result, error);
                                                                }
                                                            })];
            }
        }
    }
}


@end
