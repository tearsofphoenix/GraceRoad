//
//  GRHTMLPackage.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-15.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRHTMLPackage.h"

@interface GRHTMLPackage ()<UIWebViewDelegate>
{
    UIWebView *_view;
    NSArray *_viewConfiguration;
    NSMutableDictionary *_inputContext;
}

@property (nonatomic, retain) NSDictionary *cachedUpdateContext;

@end

@implementation GRHTMLPackage

- (id)initWithPath: (NSString *)bundlePath
{
    if ((self = [super init]))
    {
        _view = [[UIWebView alloc] init];
        [_view setDelegate: self];
        
        _inputContext = [[NSMutableDictionary alloc] init];
        
        NSString *htmlPath = [bundlePath stringByAppendingPathComponent: @"view.html"];
        NSString *htmlString = [NSString stringWithContentsOfFile: htmlPath
                                                         encoding: NSUTF8StringEncoding
                                                            error: NULL];
        [_view loadHTMLString: htmlString
                      baseURL: nil];
        
        NSString *path = [bundlePath stringByAppendingPathComponent: @"info.plist"];
        _viewConfiguration = [NSArray arrayWithContentsOfFile: path];
    }
    
    return self;
}

- (UIView *)view
{
    return _view;
}

- (NSDictionary *)savedContext
{
    for (NSDictionary *iLooper in _viewConfiguration)
    {
        @autoreleasepool
        {
            NSString *elementID = iLooper[@"id"];
            NSString *classType = iLooper[@"class"];
            
            NSString *jsScript = nil;
            
            if ([classType isEqualToString: @"text"])
            {
                jsScript = [NSString stringWithFormat: @"document.getElementById('%@').value;", elementID];
                
            }else if ([classType isEqualToString: @"choose"])
            {
                jsScript = [NSString stringWithFormat: @"document.getElementById('%@').checked;", elementID];
            }else
            {
                continue;
            }
            
            NSString *value = [_view stringByEvaluatingJavaScriptFromString: jsScript];
            if (value)
            {
                [_inputContext setObject: (@{
                                             @"value" : value,
                                             @"class" : classType,
                                             })
                                  forKey: elementID];
            }
        }
    }
    
    return _inputContext;
}

- (void)_directUpdateWithRecord: (NSDictionary *)savedRecord
{
    [savedRecord enumerateKeysAndObjectsUsingBlock: (^(NSString *elementID, NSDictionary *obj, BOOL *stop)
                                                     {
                                                         @autoreleasepool
                                                         {
                                                             NSString *classType = obj[@"class"];
                                                             NSString *value = obj[@"value"];
                                                             NSString *jsScript = nil;
                                                             
                                                             if ([classType isEqualToString: @"text"])
                                                             {
                                                                 jsScript = [NSString stringWithFormat: @"document.getElementById('%@').value='%@';", elementID, value];
                                                                 
                                                             }else if ([classType isEqualToString: @"choose"])
                                                             {
                                                                 jsScript = [NSString stringWithFormat: @"document.getElementById('%@').checked=%@;", elementID, value];
                                                             }
                                                             
                                                             if (jsScript)
                                                             {
//                                                                 NSLog(@"f: %@", [_view stringByEvaluatingJavaScriptFromString:
//                                                                 [NSString stringWithFormat: @"document.getElementById('%@').innerHTML", elementID]]);
                                                                 
                                                                 [_view stringByEvaluatingJavaScriptFromString: jsScript];
                                                             }
                                                         }
                                                     })];
}

- (void)updateWithRecord: (NSDictionary *)savedRecord
{
    [self setCachedUpdateContext: savedRecord];
}

- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    if (_cachedUpdateContext)
    {
        [self _directUpdateWithRecord: _cachedUpdateContext];
        [self setCachedUpdateContext: nil];
    }
}

@end
