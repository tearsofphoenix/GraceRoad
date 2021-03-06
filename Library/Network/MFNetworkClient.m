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
    MFNetworkClientInternal *_internal;
    MFNetworkClientInternal *_fileDownloadInternal;
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
        _internal = [[MFNetworkClientInternal alloc] initWithThreadName: @"com.cmb.foundation.thread.network"];
        _fileDownloadInternal = [[MFNetworkClientInternal alloc] initWithThreadName: @"com.cmb.foundation.thread.network.file-download"];
    }
    
    return self;
}

- (void)dealloc
{
    [_internal release];
    [_fileDownloadInternal release];
    
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

- (void)postToURL: (NSURL *)targetURL
       parameters: (NSDictionary *)parameters
         lifeTime: (NSTimeInterval)timeInterval
         callback: (MFNetworkConnectionCallback)callback
{
    [_internal postToURL: targetURL
              parameters: parameters
                lifeTime: timeInterval
                callback: callback];
}


+ (void)downloadFileAtPath: (NSString *)filePath
                  callback: (MFNetworkConnectionCallback)callback
{
    if (filePath)
    {
        [[self sharedClient] downloadFileAtURL: [NSURL URLWithString: filePath]
                                      callback: callback];
    }
}

- (void)downloadFileAtURL: (NSURL *)fileURL
                 callback: (MFNetworkConnectionCallback)callback
{
    [_fileDownloadInternal downloadFileAtURL: fileURL
                                    callback: callback];
}

- (void)cancelRequestForURL: (NSURL *)targetURL
{
    [_internal cancelRequestForURL: targetURL];
    [_fileDownloadInternal cancelRequestForURL: targetURL];
}

@end
