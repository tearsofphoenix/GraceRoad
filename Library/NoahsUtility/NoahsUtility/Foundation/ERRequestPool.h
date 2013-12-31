//
//  ERRequestPool.h
//  DoctorsLink
//
//  Created by Minun Dragonation on 3/22/13.
//  Copyright (c) 2013 Minun Dragonation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ERRequestPool: NSObject
{
    
    NSDate *_lastApplicationTimestamp;
    NSDate *_firstNotCompletedApplicationTimestamp;
    
    NSTimeInterval _minimumTimeInterval;
    NSTimeInterval _maximumTimeInterval;
    
    SEL _requestSelector;
    id _requestTarget;
    
    BOOL _poolEnabled;

    BOOL _requesting;
    
}

- (id)initWithRequestTarget: (id)requestTarget
                   selector: (SEL)requestSelector;

- (id)initWithRequestTarget: (id)requestTarget
                   selector: (SEL)requestSelector
        minimumTimeInterval: (NSTimeInterval)minimumTimeInterval;

- (id)initWithRequestTarget: (id)requestTarget
                   selector: (SEL)requestSelector
        minimumTimeInterval: (NSTimeInterval)minimumTimeInterval
        maximumTimeInterval: (NSTimeInterval)maximumTimeInterval;

- (void)applyForRequest;

- (void)disablePool;

- (void)enablePool;

@end
