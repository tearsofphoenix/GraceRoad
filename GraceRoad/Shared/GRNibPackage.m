//
//  GRPackage.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-15.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRNibPackage.h"

#define GRPackageScrollViewTag  1001

@interface GRNibPackage ()
{
    NSMutableDictionary *_inputContext;
}

@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSDictionary *viewConfiguration;

@end

@implementation GRNibPackage

- (id)initWithPath: (NSString *)bundlePath
{
    if ((self = [super init]))
    {
        NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];
        [bundle load];
        
        NSArray *views = [bundle loadNibNamed: @"view"
                                        owner: self
                                      options: nil];
        [self setView: views[0]];
        
        UIScrollView *scrollView = (id)[_view viewWithTag: GRPackageScrollViewTag];
        CGRect rect = [scrollView bounds];

        NSArray *subViews = [scrollView subviews];
        UIView *lastView = [subViews objectAtIndex: [subViews count] - 3];
        CGRect lastFrame = [lastView frame];
        
        [scrollView setContentSize: CGSizeMake(rect.size.width, lastFrame.origin.y + lastFrame.size.height)];
        
        
        NSString *path = [bundlePath stringByAppendingPathComponent: @"info.plist"];
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile: path];
        
        [self setViewConfiguration: info];
        
        _inputContext = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

static void _GRPackageGatherInput(UIView *view, NSDictionary  *viewConfiguration, NSMutableDictionary *result)
{
    Class swtichClass = [UISwitch class];

    for (UIView *vLooper in [view subviews])
    {
        id tagKey = @([vLooper tag]);
        
        NSDictionary *config = viewConfiguration[tagKey];
        if (config)
        {
            NSMutableDictionary *ctxLooper = [NSMutableDictionary dictionaryWithDictionary: config];
            if ([vLooper respondsToSelector: @selector(text)])
            {
                [ctxLooper setObject: [(id)vLooper text]
                              forKey: @"value"];
                
            }else if ([vLooper isKindOfClass: swtichClass])
            {
                UISwitch *switchView = (id)vLooper;
                
                [ctxLooper setObject: @([switchView isOn])
                              forKey: @"value"];
            }
            
            [result setObject: ctxLooper
                              forKey: tagKey];
        }
        
        @autoreleasepool
        {
            _GRPackageGatherInput(vLooper, viewConfiguration, result);
        }
    }
}

- (NSDictionary *)savedContext
{
    UIView *scrollView = [_view viewWithTag: GRPackageScrollViewTag];
    
    _GRPackageGatherInput(scrollView, _viewConfiguration, _inputContext);

    return _inputContext;
}

- (void)updateWithRecord: (NSDictionary *)savedRecord
{
    
}

@end
