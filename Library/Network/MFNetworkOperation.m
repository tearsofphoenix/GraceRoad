//
//  MFNetworkOperation.m
//  CMBFoundation
//
//  Created by Mac003 on 13-12-26.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "MFNetworkOperation.h"

@interface MFNetworkOperation ()<NSURLConnectionDataDelegate>
{
    NSMutableData *_receivedData;
    NSURLConnection *_connection;
}

@property (nonatomic, retain) NSURL *URL;

@property (nonatomic) NSTimeInterval lifeTimeInterval;

@property (nonatomic, copy) MFNetworkConnectionCallback callback;

@end

@implementation MFNetworkOperation

- (id)initWithURL: (NSURL *)URL
 lifeTimeInterval: (NSTimeInterval)lifeTimeInterval
         callback: (MFNetworkConnectionCallback)callback
{
    if ((self = [super init]))
    {
        _receivedData = [[NSMutableData alloc] init];
        
        [self setURL: URL];
        [self setLifeTimeInterval: lifeTimeInterval];
        [self setCallback: callback];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"in func: %s %@", __func__, self);
    
    [_receivedData release];
    [_URL release];
    [_connection release];
    
    if (_callback)
    {
        Block_release(_callback);
    }
    
    [_callbackThread release];
    
    [super dealloc];
}

- (void)operationDidStart
{
    if (!_connection)
    {
        _connection = [[NSURLConnection alloc] initWithRequest: [NSURLRequest requestWithURL: _URL]
                                                      delegate: self
                                              startImmediately: YES];
    }
}

- (void)cancel
{    
    [_connection cancel];

    [super cancel];
}

- (void)operationWillFinish
{
    [_delegate operationWillFinish: self];
}

- (NSData *)receivedData
{
    return _receivedData;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection: (NSURLConnection *)connection
didReceiveResponse: (NSURLResponse *)response
{
    [_receivedData setLength: 0];
}

- (void)connection: (NSURLConnection *)connection
    didReceiveData: (NSData *)data
{
    [_receivedData appendData: data];
}

- (void)connection: (NSURLConnection *)connection
  didFailWithError: (NSError *)error
{
    [self finishWithError: error];
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection
{
    [self finishWithError: nil];
}

@end
