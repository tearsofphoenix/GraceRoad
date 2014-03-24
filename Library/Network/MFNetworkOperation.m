//
//  MFNetworkOperation.m
//  CMBFoundation
//
//  Created by Mac003 on 13-12-26.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "MFNetworkOperation.h"
#import "NSString+CMBExtensions.h"

@interface MFNetworkOperation ()<NSURLConnectionDataDelegate>
{
    NSMutableData *_receivedData;
    NSURLConnection *_connection;
}

@property (nonatomic, retain) NSDictionary *parameters;

@property (nonatomic, retain) NSURL *URL;

@property (nonatomic) NSTimeInterval lifeTimeInterval;

@property (nonatomic, copy) MFNetworkConnectionCallback callback;

@property (nonatomic) NSInteger statusCode;

@end

@implementation MFNetworkOperation

- (id)initWithURL: (NSURL *)URL
       parameters: (NSDictionary *)parameters
 lifeTimeInterval: (NSTimeInterval)lifeTimeInterval
         callback: (MFNetworkConnectionCallback)callback
{
    if ((self = [super init]))
    {
        _receivedData = [[NSMutableData alloc] init];
        
        [self setParameters: parameters];
        [self setURL: URL];
        [self setLifeTimeInterval: lifeTimeInterval];
        [self setCallback: callback];
        [self setHTTPMethod: @"POST"];
    }
    
    return self;
}

- (void)dealloc
{
#if DEBUG
    NSLog(@"in func: %s %@ %@", __func__, self, _URL);
#endif
    [_parameters release];
    [_receivedData release];
    [_URL release];
    [_connection release];
    [_HTTPMethod release];
    
    if (_callback)
    {
        Block_release(_callback);
    }
    
    [_callbackThread release];
    
    [super dealloc];
}

- (void)_buildMultipartFormRequest: (NSMutableURLRequest *)request
                    withParameters: (NSDictionary *)parameters
{
    @autoreleasepool
    {
        [request setValue: @"application/x-www-form-urlencoded; charset=utf-8;"
       forHTTPHeaderField: @"Content-Type"];
        
        NSMutableArray *parts = [NSMutableArray arrayWithCapacity: [_parameters count]];
        [parameters enumerateKeysAndObjectsUsingBlock: (^(NSString *key, NSString *obj, BOOL *stop)
                                                        {
                                                            [parts addObject: [NSString stringWithFormat: @"%@=%@", key, obj]];
                                                        })];
        
        NSString *str = [parts componentsJoinedByString: @"&"];
        NSData *data = [str dataUsingEncoding: NSUTF8StringEncoding];
        
        [request setHTTPBody: data];
        [request setValue: [NSString stringWithFormat:@"%lu", (unsigned long)[data length]]
       forHTTPHeaderField: @"Content-Length"];
    }
}

- (void)operationDidStart
{
    if (!_connection)
    {
        NSMutableURLRequest *reuqest = [NSMutableURLRequest requestWithURL: _URL];
        [reuqest setHTTPMethod: _HTTPMethod];
        
        if ([_parameters count] > 0)
        {
            [self _buildMultipartFormRequest: reuqest
                              withParameters: _parameters];
        }
        
        _connection = [[NSURLConnection alloc] initWithRequest: reuqest
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
    //clear data if error happened
    //
    if (_statusCode / 100 == 4)
    {
        [_receivedData setLength: 0];
    }

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
    [self setStatusCode: [(NSHTTPURLResponse *)response statusCode]];
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
