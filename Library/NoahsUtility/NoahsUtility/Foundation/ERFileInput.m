//
//  ERFileInput.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/12/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERFileInput.h"

@interface ERFileInput()
{
    NSURL *_url;
}

@end

@implementation ERFileInput

- (id)initWithURL: (NSURL *)url
{
    
    self = [super init];
    if (self)
    {
        self->_url = [url retain];
    }
    
    return self;
}

- (void)dealloc
{
    
    [self->_url release];
    
    [super dealloc];
    
}

@synthesize URL = _url;

@end
