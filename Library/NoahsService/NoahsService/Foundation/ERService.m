//
//  ERService.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/2/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERService.h"

static NSOperationQueue *ERServiceQueue = nil;

static NSMutableDictionary *ERServiceClassDictionary = nil;

static NSMutableDictionary *ERServiceDictionary = nil;

@implementation ERService

+ (void)load
{
    ERServiceQueue = [[NSOperationQueue alloc] init];
}

+ (NSOperationQueue *)serviceQueue
{
    return ERServiceQueue;
}

- (id)init
{
    
    self = [super init];
    if (self)
    {
        _processors = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    
    [_processors release];
    
    [super dealloc];
    
}

+ (void)registerServiceClass: (Class)serviceClass
{
    
    if (!ERServiceClassDictionary)
    {
        ERServiceClassDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [ERServiceClassDictionary setObject: serviceClass 
                                 forKey: [serviceClass serviceIdentifier]];
    
}

+ (NSString *)serviceIdentifier
{
    return nil;
}

+ (ERService *)serviceWithIdentifier: (NSString *)serviceIdentifier
{
    
    ERService *service = [ERServiceDictionary objectForKey: serviceIdentifier];
    if (!service)
    {
        
        Class serviceClass = [ERServiceClassDictionary objectForKey: serviceIdentifier];
        if (serviceClass)
        {
            
            if (!ERServiceDictionary)
            {
                ERServiceDictionary = [[NSMutableDictionary alloc] init];
            }
            
            service = [[serviceClass alloc] init];
            
            [ERServiceDictionary setObject: service
                                    forKey: [serviceClass serviceIdentifier]];
            
            [service release];
            
        }
        
    }
    
    return service;
}

+ (void)            callback: (ERServiceCallback)callback
    forServiceWithIdentifier: (NSString *)serviceIdentifier
                   forAction: (NSString *)action
               withArguments: (NSArray *)arguments
{
    [[self serviceWithIdentifier: serviceIdentifier] callback: callback
                                                    forAction: action
                                                withArguments: arguments];
}

- (NSString *)serviceIdentifier
{
    return [[self class] serviceIdentifier];
}

- (void)registerProcessor: (ERServiceProcessor)processor
                forAction: (NSString *)action
{
    
    processor = Block_copy(processor);
    
    [_processors setObject: processor forKey: action];
    
    Block_release(processor);
    
}

- (void)callback: (ERServiceCallback)callback
       forAction: (NSString *)action
   withArguments: (NSArray *)arguments
{
    
    ERServiceProcessor processor = [_processors objectForKey: action];
    if (processor)
    {
        processor(arguments, callback);
    }
    else
    { 
        
        SEL selector = NSSelectorFromString(action);
        if ([self respondsToSelector: selector])
        {
            
            NSMethodSignature *signature = [self methodSignatureForSelector: selector];
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: signature];
            
            [invocation setTarget: self];
            [invocation setSelector: selector];
            
            NSInteger looper = 0;
            while (looper < [arguments count])
            {
                
                id argument = [arguments objectAtIndex: looper];
                if ([argument isKindOfClass: [NSNull class]])
                {
                    argument = nil;
                }
                
                [invocation setArgument: &argument
                                atIndex: looper + 2];
                
                ++looper;
            }
            
            NSException *outerException = nil;
            
            @try 
            {
                
                [invocation invoke];
                
                id result = nil;
                
                if ([signature methodReturnLength])
                {
                    [invocation getReturnValue: &result];
                }
                
                if (callback)
                {
                    
                    @try
                    {
                        callback(result, nil);
                    }
                    @catch (NSException *exception)
                    {
                        outerException = exception;
                    }
                    
                }

            }
            @catch (NSException *exception) 
            {

                if (callback)
                {
                    callback(nil, exception);
                }
                else
                {
                    @throw exception;
                }
                
            }
            
            if (outerException)
            {
                @throw outerException;
            }
            
        }
        else
        {
         
            NSException *exception = [NSException exceptionWithName: @"Action could not be processed" 
                                                             reason: [NSString stringWithFormat: 
                                                                      @"Action processor for \"%@\" not found for service \"%@\"", 
                                                                      action,
                                                                      [self serviceIdentifier]]
                                                           userInfo: nil];
            
            if (callback)
            {
                callback(nil, exception);
            }
            else 
            {
                @throw exception;
            }
            
        }
        
    }

}

@end
