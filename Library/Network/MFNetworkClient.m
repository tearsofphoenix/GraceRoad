//
//  CMBNetworkClient.m
//  CMBNetwork
//
//  Created by Mac003 on 13-12-5.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "MFNetworkClient.h"
#import "MFNetworkClientInternal.h"

@interface MFNetworkClient ()
{
    id<MFNetworkClient> _internal;
}
@end

@implementation MFNetworkClient

static id gsNetworkClient = nil;

+ (id)sharedClient
{
    if (!gsNetworkClient)
    {
        gsNetworkClient = [[self alloc] init];
    }
    
    return gsNetworkClient;
}

- (id)init
{
    if ((self = [super init]))
    {
        _internal = [[MFNetworkClientInternal alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_internal release];
    
    [super dealloc];
}

- (void)addConnectionToURL: (NSURL *)targetURL
                  lifeTime: (NSTimeInterval)timeInterval
                  callback: (MFNetworkConnectionCallback)callback
{
    [_internal addConnectionToURL: targetURL
                         lifeTime: timeInterval
                         callback: callback];
}

+ (void)downloadFileAtPath: (NSString *)filePath
               enableCache: (BOOL)enableCache
                  callback: (MFNetworkConnectionCallback)callback
{
    if (filePath)
    {
        [[self sharedClient] downloadFileAtURL: [NSURL URLWithString: filePath]
                                   enableCache: enableCache
                                      callback: callback];
    }
}

- (void)downloadFileAtURL: (NSURL *)fileURL
              enableCache: (BOOL)enableCache
                 callback: (MFNetworkConnectionCallback)callback
{
    [_internal downloadFileAtURL: fileURL
                     enableCache: enableCache
                        callback: callback];
}

@end
