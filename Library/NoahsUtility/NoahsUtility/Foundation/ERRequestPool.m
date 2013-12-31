//
//  ERRequestPool.m
//  DoctorsLink
//
//  Created by Minun Dragonation on 3/22/13.
//  Copyright (c) 2013 Minun Dragonation. All rights reserved.
//

//#import "ERRequestPool.h"

#import <NoahsUtility/NoahsUtility.h>

@implementation ERRequestPool

- (id)initWithRequestTarget: (id)requestTarget
                   selector: (SEL)requestSelector
{
    return [self initWithRequestTarget: requestTarget
                              selector: requestSelector
                   minimumTimeInterval: 0.1];
}

- (id)initWithRequestTarget: (id)requestTarget
                   selector: (SEL)requestSelector
        minimumTimeInterval: (NSTimeInterval)minimumTimeInterval
{
    return [self initWithRequestTarget: requestTarget
                              selector: requestSelector
                   minimumTimeInterval: minimumTimeInterval
                   maximumTimeInterval: minimumTimeInterval];
}

- (id)initWithRequestTarget: (id)requestTarget
                   selector: (SEL)requestSelector
        minimumTimeInterval: (NSTimeInterval)minimumTimeInterval
        maximumTimeInterval: (NSTimeInterval)maximumTimeInterval
{
    
    self = [super init];
    if (self)
    {
        
        _poolEnabled = YES;
        
        _requestTarget = requestTarget;
        
        _requestSelector = requestSelector;
        
        _minimumTimeInterval = minimumTimeInterval;
        
        _maximumTimeInterval = maximumTimeInterval;
        
    }
    
    return self;
}

- (void)dealloc
{
    
    [_firstNotCompletedApplicationTimestamp release];
    [_lastApplicationTimestamp release];
    
    [super dealloc];
}

- (void)applyForRequest
{

    if ((_minimumTimeInterval < 0) || (_maximumTimeInterval < 0))
    {
        [_requestTarget performSelector: _requestSelector];
    }
    else
    {
        
        NSDate *requestTimestamp = [NSDate date];
        
        if (!_firstNotCompletedApplicationTimestamp)
        {
            _firstNotCompletedApplicationTimestamp = [requestTimestamp copy];
        }
        
        [_lastApplicationTimestamp release];
        _lastApplicationTimestamp = [requestTimestamp copy];

        if (!_requesting)
        {
            
            _requesting = YES;
                
            [NSTimer scheduledTimerWithTimeInterval: _minimumTimeInterval
                                       closureBlock:
             (^(NSTimer *timer)
              {

                  if (_poolEnabled)
                  {
                      
                      NSDate *now = [NSDate date];
                      if (([now timeIntervalSince1970] - [_firstNotCompletedApplicationTimestamp timeIntervalSince1970] > _maximumTimeInterval) ||
                          [requestTimestamp isEqualToDate: _lastApplicationTimestamp])
                      {
                          
                          _requesting = NO;

                          [_firstNotCompletedApplicationTimestamp release];
                          _firstNotCompletedApplicationTimestamp = nil;
                          
                          [_requestTarget performSelector: _requestSelector];

                      }
                      else
                      {
                          
                          [NSTimer scheduledTimerWithTimeInterval: _maximumTimeInterval - _minimumTimeInterval
                                                     closureBlock:
                           (^(NSTimer *timer)
                            {
                                
                                _requesting = NO;

                                [_firstNotCompletedApplicationTimestamp release];
                                _firstNotCompletedApplicationTimestamp = nil;
                                
                                [_requestTarget performSelector: _requestSelector];

                            })];
                          
                      }
                      
                  }

              })];
            
        }

    }
    
}

- (void)disablePool
{
    _poolEnabled = NO;
}

- (void)enablePool
{
    _poolEnabled = YES;
}

@end
