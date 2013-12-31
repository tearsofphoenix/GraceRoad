//
//  ERBlockOperation.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/30/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERBlockOperation.h"

@interface ERBlockOperation()
{
    @private EROperationBlock _block;
}

@end

@implementation ERBlockOperation

- (id)initWithBlock: (EROperationBlock)block
{
    
    self = [super init];
    if (self)
    {
        
        if (block)
        {
            self->_block = Block_copy(block);
        }
        
    }
    
    return self;
}

- (void)main
{
    
    if (self->_block)
    {
        
        EROperationBlock block = self->_block;
        
        block();
        
    }
    
}

- (void)dealloc
{
    
    if (self->_block)
    {
        
        Block_release(self->_block);
        
        self->_block = nil;
        
    }
    
    [super dealloc];
}

@end
