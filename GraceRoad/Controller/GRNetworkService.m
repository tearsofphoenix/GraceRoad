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
    @autoreleasepool
    {
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary: parameters];
        NSString *action = parameters[GRNetworkActionKey];
        
        NSString *messageID = [NSString randomStringWithLength: 8];
        NSLog(@"messageID: %@", messageID);
        
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
                                                                    NSLog(@"network: %@", response);
                                                                    [response release];
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


@end
