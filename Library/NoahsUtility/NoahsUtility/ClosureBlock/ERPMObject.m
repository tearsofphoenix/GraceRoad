//
//  ERPM.c
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/12/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERPM.h"

@interface ERPMObject: NSObject
{
    ERBlockAction _action;
}

@end

@implementation ERPMObject

- (id)initWithBlockAction: (ERBlockAction)action
{
    
    self = [super init];
    if (self)
    {
        _action = Block_copy(action);
    }
    
    return self;
}

- (void)dealloc
{
    
    Block_release(_action);
    
    [super dealloc];
}

- (void)doAction
{
    _action();
}

@end

void ERPM(ERBlockAction action)
{
    
    if ([NSThread currentThread] != [NSThread mainThread])
    {

        ERPMObject *object = [[ERPMObject alloc] initWithBlockAction: action];
        
        [object performSelectorOnMainThread: @selector(doAction) withObject: nil waitUntilDone: YES];
        
        [object release];
        
    }
    else
    {
        action();
    }
    
}

void ERPPM(ERBlockAction action)
{
    
    if ([NSThread currentThread] != [NSThread mainThread])
    {
        
        ERPMObject *object = [[ERPMObject alloc] initWithBlockAction: action];
        
        [object performSelectorOnMainThread: @selector(doAction) withObject: nil waitUntilDone: NO];
        
        [object release];
        
    }
    else
    {
        action();
    }
    
}
