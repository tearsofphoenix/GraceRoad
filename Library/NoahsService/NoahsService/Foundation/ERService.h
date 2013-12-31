//
//  ERService.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/2/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ERServiceCallback)(id result, id exception);
typedef void (^ERServiceProcessor)(NSArray *arguments, ERServiceCallback callback);

@interface ERService: NSObject
{
    NSMutableDictionary *_processors;
}

+ (NSOperationQueue *)serviceQueue;

+ (void)registerServiceClass: (Class)serviceClass;

+ (NSString *)serviceIdentifier;

+ (ERService *)serviceWithIdentifier: (NSString *)serviceIdentifier;

+ (void)            callback: (ERServiceCallback)callback
    forServiceWithIdentifier: (NSString *)serviceIdentifier
                   forAction: (NSString *)action
               withArguments: (NSArray *)arguments;

- (NSString *)serviceIdentifier;

- (void)registerProcessor: (ERServiceProcessor)processor
                forAction: (NSString *)action;

- (void)callback: (ERServiceCallback)callback
       forAction: (NSString *)action
   withArguments: (NSArray *)argument;

@end

#define ERSPrepare(CALLBACK) \
do \
{ \
    if (CALLBACK) \
    { \
        CALLBACK = Block_copy(CALLBACK); \
    } \
} \
while(0)

#define ERSCallback(CALLBACK, RESULT, EXCEPTION) \
do \
{ \
\
    ERServiceCallback __ER_CALLBACK_A44E6C1E_EF13_4AF8_BE26_65D018E6BC9A__ = (CALLBACK); \
    if (__ER_CALLBACK_A44E6C1E_EF13_4AF8_BE26_65D018E6BC9A__) \
    { \
\
        __ER_CALLBACK_A44E6C1E_EF13_4AF8_BE26_65D018E6BC9A__((RESULT), (EXCEPTION)); \
\
        Block_release(__ER_CALLBACK_A44E6C1E_EF13_4AF8_BE26_65D018E6BC9A__); \
\
    } \
\
    return; \
} \
while (0)

#define ERSEnsureNoException(CALLBACK, EXCEPTION) \
do \
{ \
    id __ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__ = (EXCEPTION); \
    if (__ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__) \
    { \
\
        ERSCallback((CALLBACK), nil, __ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__); \
\
        return; \
    } \
} \
while (0)

#define ERSEnsureResultNotNilAndNoException(CALLBACK, RESULT, EXCEPTION) \
do \
{ \
\
    id __ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__ = (EXCEPTION); \
    if (__ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__) \
    { \
\
        ERSCallback((CALLBACK), nil, __ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__); \
\
        return; \
    } \
    else if (!RESULT) \
    { \
\
        ERSCallback((CALLBACK), nil, [ERServiceNilResultException exceptionWithName: @"Nil result received from service call" \
                                                                             reason: @"Result received from service callback is nil" \
                                                                           userInfo: nil]); \
\
        return; \
    } \
\
} \
while (0)

#define ERSEnsureResultNotNilAndNoExceptionWithNilExceptionClass(CALLBACK, RESULT, EXCEPTION, NIL_EXCEPTION_CLASS) \
do \
{ \
\
    id __ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__ = (EXCEPTION); \
    if (__ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__) \
    { \
\
        ERSCallback((CALLBACK), nil, __ER_EXCEPTION_829E16E3_B4B3_4650_B14B_DA4B35D286AA__); \
\
        return; \
    } \
    else if (!RESULT) \
    { \
\
        ERSCallback((CALLBACK), nil, [NIL_EXCEPTION_CLASS exceptionWithName: @"Nil result received from service call" \
                                                                     reason: @"Result received from service callback is nil" \
                                                                   userInfo: nil]); \
    \
    return; \
    } \
\
} \
while (0)

#define ERSAssert(CONDITION, CALLBACK, EXCEPTION, FORMAT, ...) \
do \
{ \
\
    if (!(CONDITION)) \
    { \
\
        NSString *__ER_TEXT_C6FC2DFB_0CBC_401C_AE58_BFA7ABDAADC7__ = [NSString stringWithFormat: (FORMAT), ##__VA_ARGS__]; \
\
        id __ER_EXCEPTION_FAB195CC_7A9A_4E33_87DB_DDD680AF7DB0__ = (EXCEPTION); \
        if (__ER_EXCEPTION_FAB195CC_7A9A_4E33_87DB_DDD680AF7DB0__) \
        { \
            ERSCallback((CALLBACK), nil, __ER_EXCEPTION_FAB195CC_7A9A_4E33_87DB_DDD680AF7DB0__); \
        } \
        else \
        { \
            ERSCallback((CALLBACK), nil, [NSException exceptionWithName: @"Service assertion failure" \
                                                                 reason: __ER_TEXT_C6FC2DFB_0CBC_401C_AE58_BFA7ABDAADC7__ \
                                                               userInfo: nil]); \
        } \
\
    } \
\
} \
while (0)

#define ERSLAssert(CONDITION, CALLBACK, EXCEPTION, FORMAT, ...) ERSDLAssert((CONDITION), (CALLBACK), (EXCEPTION), ERLogServiceStandardDomain, (FORMAT), ##__VA_ARGS__)

#define ERSDLAssert(CONDITION, CALLBACK, EXCEPTION, DOMAIN, FORMAT, ...) \
do \
{ \
\
    if (!(CONDITION)) \
    { \
\
        NSString *__ER_TEXT_C6FC2DFB_0CBC_401C_AE58_BFA7ABDAADC7__ = [NSString stringWithFormat: (FORMAT), ##__VA_ARGS__]; \
\
        ERDReport((DOMAIN), @"%@", __ER_TEXT_C6FC2DFB_0CBC_401C_AE58_BFA7ABDAADC7__);\
\
        id __ER_EXCEPTION_FAB195CC_7A9A_4E33_87DB_DDD680AF7DB0__ = (EXCEPTION); \
        if (__ER_EXCEPTION_FAB195CC_7A9A_4E33_87DB_DDD680AF7DB0__) \
        { \
            ERSCallback((CALLBACK), nil, __ER_EXCEPTION_FAB195CC_7A9A_4E33_87DB_DDD680AF7DB0__); \
        } \
        else \
        { \
            ERSCallback((CALLBACK), nil, [NSException exceptionWithName: @"Service assertion failure" \
                                                                 reason: __ER_TEXT_C6FC2DFB_0CBC_401C_AE58_BFA7ABDAADC7__ \
                                                               userInfo: nil]); \
        } \
\
    } \
\
} \
while (0)

static inline void ERSC(NSString *serviceIdentifier,
                        NSString *action,
                        NSArray *arguments,
                        ERServiceCallback callback)
{
    [ERService          callback: callback
        forServiceWithIdentifier: serviceIdentifier
                       forAction: action
                   withArguments: arguments];
}

static inline id ERSSC(NSString *serviceIdentifier,
                       NSString *action,
                       NSArray *arguments)
{
    
    __block BOOL callbacked = NO;
    
    __block id resultCallbacked = nil;
    __block id exceptionCallbacked = nil;
    
    if ([ERService serviceWithIdentifier: serviceIdentifier])
    {
        
        [ERService          callback: (^(id result, id exception)
                                       {
                                           
                                           resultCallbacked = result;
                                           
                                           [resultCallbacked retain];
                                           
                                           exceptionCallbacked = exception;
                                           
                                           [exceptionCallbacked retain];
                                           
                                           callbacked = YES;
                                           
                                       })
            forServiceWithIdentifier: serviceIdentifier
                           forAction: action
                       withArguments: arguments];
        
        while (!callbacked)
        {
            @autoreleasepool
            {
                [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.001]];
            }
        }
        
        [resultCallbacked autorelease];
        [exceptionCallbacked autorelease];
        
        if (exceptionCallbacked)
        {
            @throw exceptionCallbacked;
        }
        else
        {
            return resultCallbacked;
        }
        
    }
    else
    {
        return nil;
    }
    
}

static inline id ERSTC(NSString *serviceIdentifier,
                       NSString *action,
                       NSArray *arguments)
{

    __block BOOL callbacked = NO;

    __block id resultCallbacked = nil;
    __block id exceptionCallbacked = nil;

    [ERService          callback: (^(id result, id exception)
                                   {

                                       if (!callbacked)
                                       {
                                           
                                           resultCallbacked = result;

                                           [resultCallbacked retain];

                                           exceptionCallbacked = exception;

                                           [exceptionCallbacked retain];

                                           callbacked = YES;

                                       }

                                   })
        forServiceWithIdentifier: serviceIdentifier
                       forAction: action
                   withArguments: arguments];

    if (callbacked)
    {

        [resultCallbacked autorelease];
        [exceptionCallbacked autorelease];

        if (exceptionCallbacked)
        {
            @throw exceptionCallbacked;
        }
        else
        {
            return resultCallbacked;
        }

    }
    else
    {

        callbacked = YES;
        
        return nil;
    }

}

static inline void ERSQ(NSString *serviceIdentifier,
                        NSString *action,
                        NSArray *arguments,
                        ERServiceCallback callback)
{
    
    if (callback)
    {
        callback = Block_copy(callback);
    }
    
    [[ERService serviceQueue] addOperationWithBlock:
     (^(void)
      {
          
          [ERService          callback: callback
              forServiceWithIdentifier: serviceIdentifier
                             forAction: action
                         withArguments: arguments];
          
          if (callback)
          {
              Block_release(callback);
          }
          
      })];
    
}

static inline id ERSSQ(NSString *serviceIdentifier,
                       NSString *action,
                       NSArray *arguments)
{
    
    __block BOOL callbacked = NO;
    
    __block id resultCallbacked = nil;
    __block id exceptionCallbacked = nil;
    
    ERServiceCallback callback = (^(id result, id exception)
                                  {
                                      
                                      resultCallbacked = result;
                                      
                                      [resultCallbacked retain];
                                      
                                      exceptionCallbacked = exception;
                                      
                                      [exceptionCallbacked retain];
                                      
                                      callbacked = YES;
                                      
                                  });
    
    callback = Block_copy(callback);
    
    [[ERService serviceQueue] addOperationWithBlock:
     (^(void)
      {
          
          [ERService          callback: callback
              forServiceWithIdentifier: serviceIdentifier
                             forAction: action
                         withArguments: arguments];
          
          Block_release(callback);
          
      })];
    
    while (!callbacked)
    {
        @autoreleasepool
        {
            [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.001]];
        }
    }
    
    [resultCallbacked autorelease];
    [exceptionCallbacked autorelease];
    
    if (exceptionCallbacked)
    {
        @throw exceptionCallbacked;
    }
    else
    {
        return resultCallbacked;
    }
    
}

static inline void ERSM(NSString *serviceIdentifier,
                        NSString *action,
                        NSArray *arguments,
                        ERServiceCallback callback)
{
    
    if (callback)
    {
        callback = Block_copy(callback);
    }
    
    [[ERService serviceQueue] addOperationWithBlock:
     (^(void)
      {
          
          [ERService          callback: (^(id result, id exception)
                                         {
                                             
                                             [[NSOperationQueue mainQueue] addOperationWithBlock:
                                              (^(void)
                                               {
                                                   
                                                   if (callback)
                                                   {
                                                       
                                                       callback(result, exception);
                                                   
                                                       Block_release(callback);
                                                       
                                                   }
                                                   
                                               })];
                                             
                                         })
              forServiceWithIdentifier: serviceIdentifier
                             forAction: action
                         withArguments: arguments];
          
      })];
    
}
