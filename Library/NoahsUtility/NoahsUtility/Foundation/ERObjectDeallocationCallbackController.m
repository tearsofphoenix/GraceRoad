//
//  ERObjectDeallocationCallbackController.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/27/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERObjectDeallocationCallbackController.h"

@implementation ERObjectDeallocationCallbackController

- (id)   initWithSubject: (id)subject
    deallocationCallback: (ERObjectDeallocationCallback)callback
                  handle: (ERUUID *)handle;
{
    
    self = [super init];
    if (self)
    {
        
        _subject = subject;
        
        if (callback)
        {
            _callback = Block_copy(callback);
        }
        
        _handle = handle;
        
        [_handle retain];
        
    }
    
    return self;
}

- (void)clearCallback
{
    
    Block_release(_callback);
    
    _callback = nil;
    
}

- (void)dealloc
{
 
    if (_callback)
    {
        
        _callback(_subject, _handle);
        
        Block_release(_callback);
        
    }
    
    [_handle release];
    
    [super dealloc];
    
}

@end
