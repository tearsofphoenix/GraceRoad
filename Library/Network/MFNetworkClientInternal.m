//
//  MFNetworkClientInternal.m
//  CMBFoundation
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "MFNetworkClientInternal.h"
#import "MFNetworkOperation.h"
#import "MFCacheManager.h"
#import "MFNetworkFileCacheManager.h"

static NSString * const MFNetworkCachePoolID = @"cache.pool.network";
static NSUInteger MFNetworkTransferQueueCapacity = 4;

@interface MFNetworkClientInternal ()<MFNetworkOperationDelegate>
{
    NSMutableArray *_connections;
    NSMutableArray *_executingOperations;
    NSMutableDictionary *_connectionInformations;
    NSThread *_networkThread;
    NSOperationQueue *_networkTransferQueue;
}
@end

@implementation MFNetworkClientInternal

- (id)init
{
    if ((self = [super init]))
    {
        _connections = [[NSMutableArray alloc] init];
        _connectionInformations = [[NSMutableDictionary alloc] init];
        _executingOperations = [[NSMutableArray alloc] initWithCapacity: MFNetworkTransferQueueCapacity * 2];
        
        _networkTransferQueue = [[NSOperationQueue alloc] init];
        [_networkTransferQueue setMaxConcurrentOperationCount: MFNetworkTransferQueueCapacity];
        
        _networkThread = [[NSThread alloc] initWithTarget: self
                                                 selector: @selector(_networkThreadMain)
                                                   object: nil];
        
        [_networkThread setName: @"com.cmb.foundation.thread.network"];
        
        [_networkThread start];
    }
    
    return self;
}

- (void)dealloc
{
    [_executingOperations release];
    [_connections release];
    [_connectionInformations release];
    [_networkTransferQueue release];
    [_networkThread release];
    
    [super dealloc];
}

- (void)_networkThreadMain
{
    assert( ![NSThread isMainThread] );
    
    while (YES)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] run];
        }
    }
    
    assert(NO);
}

- (void)_postConnectionToURL: (NSURL *)targetURL
                    lifeTime: (NSTimeInterval)timeInterval
                    callback: (MFNetworkConnectionCallback)callback
{
    @synchronized (self)
    {
        if (!_connectionInformations[targetURL])
        {
            MFNetworkOperation *operation = [[MFNetworkOperation alloc] initWithURL: targetURL
                                                                   lifeTimeInterval: timeInterval
                                                                           callback: callback];
            [operation setDelegate: self];
            [operation setRunLoopThread: _networkThread];
            [operation setCallbackThread: [NSThread currentThread]];
            
            [_connectionInformations setObject: operation
                                        forKey: targetURL];
            
            if ([_networkTransferQueue operationCount] < [_networkTransferQueue maxConcurrentOperationCount])
            {
                [_executingOperations addObject: operation];
                [_networkTransferQueue addOperation: operation];
            }else
            {
                [_connections addObject: operation];
            }
            
            [operation release];
        }
    }
}

- (void)addConnectionToURL: (NSURL *)targetURL
                  lifeTime: (NSTimeInterval)timeInterval
                  callback: (MFNetworkConnectionCallback)callback
{
    //check if in cache
    //
    NSData *cachedData =  [[MFCacheManager sharedManager] objectForKey: targetURL
                                                                inPool: MFNetworkCachePoolID];
    if (cachedData)
    {
        if (callback)
        {
            callback(cachedData, nil);
        }
    }else
    {
        [self _postConnectionToURL: targetURL
                          lifeTime: timeInterval
                          callback: callback];
    }
}

- (void)downloadFileAtURL: (NSURL *)fileURL
              enableCache: (BOOL)enableCache
                 callback: (MFNetworkConnectionCallback)callback
{
    if (fileURL)
    {
        NSString *filePath = [fileURL absoluteString];
        
        __block MFNetworkFileCacheManager *manager = [MFNetworkFileCacheManager defaultManager];
        NSData *data = [manager dataForFileID: filePath];
        if (data)
        {
            callback(data, nil);
        }else
        {
            [self _postConnectionToURL: fileURL
                              lifeTime: 0
                              callback: (^(id result, id error)
                                         {
                                             if (!error)
                                             {
                                                 if (enableCache)
                                                 {
                                                    [manager cacheData: result
                                                                withID: filePath];
                                                 }
                                                 
                                                 if (callback)
                                                 {
                                                     callback(result, error);
                                                 }
                                             }
                                         })];
        }
    }
}

#pragma mark - Delegate

- (void)operationWillFinish: (MFNetworkOperation *)operation
{
    @synchronized (self)
    {
        NSError *error = [operation error];
        MFNetworkConnectionCallback callback = [operation callback];
        
        if (error)
        {
            if (callback)
            {
                callback(nil, error);
            }
        }else
        {
            NSURL *targetURL = [operation URL];
            
            //check if need save into memory cache
            //
            NSTimeInterval lifeTime = [operation lifeTimeInterval];
            NSData *receivedData = [operation receivedData];
            NSThread *callbackThread = [operation callbackThread];
            
            if (lifeTime > 0)
            {
                [[MFCacheManager sharedManager] addObject: receivedData
                                                   forKey: targetURL
                                                 lifetime: lifeTime
                                                   toPool: MFNetworkCachePoolID];
            }
            
            callback = Block_copy(callback);
                        
            [self performSelector: @selector(_performOperationWithArguments:)
                         onThread: callbackThread
                       withObject: @[callback, receivedData]
                    waitUntilDone: NO];
            
            Block_release(callback);
        }
        
        [_connectionInformations removeObjectForKey: [operation URL]];
        [_executingOperations removeObject: operation];
        
        if ([_connections count] > 0)
        {
            MFNetworkOperation *waitingOperation = _connections[0];
            [_executingOperations addObject: waitingOperation];
            [_connections removeObjectAtIndex: 0];

            [_networkTransferQueue addOperation: waitingOperation];
        }
    }
}

- (void)_performOperationWithArguments: (NSArray *)arguments
{
    MFNetworkConnectionCallback callback = arguments[0];
    NSData *data = arguments[1];
    
    callback(data, nil);
}

@end
