//
//  GRResourceInfoView.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRResourceInfoView.h"
#import "GRResourceKey.h"
#import "GRResourceManager.h"
#import "GRNibPackage.h"
#import "GRViewService.h"
#import "GRHTMLPackage.h"
#import "GRDataService.h"
#import "GRTheme.h"

#import <PDFReader/ReaderView.h>
#import <PDFReader/ReaderDocument.h>
#import <QuickLook/QuickLook.h>

@interface GRResourceInfoView ()<QLPreviewControllerDataSource, QLPreviewControllerDelegate>
{
    UIButton *_doneButton;
    QLPreviewController *_previewController;
}

@property (nonatomic, retain) UIButton *rightNavigationButton;

@property (nonatomic, retain) id<GRPackage> package;
@property (nonatomic, retain) UIView *packageView;

@end

@implementation GRResourceInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setHideTabbar: YES];
        [self setBackgroundColor: [UIColor whiteColor]];
        
        _doneButton = [[UIButton alloc] init];
        //[_doneButton setBackgroundColor: [UIColor colorWithRed:0.58 green:0.69 blue:0.84 alpha:1]];
        [_doneButton setBackgroundColor: [GRTheme blueColor]];
        [[_doneButton titleLabel] setFont: [UIFont systemFontOfSize: 14]];
        [_doneButton setTitle: @"完成"
                     forState: UIControlStateNormal];
        [_doneButton setTitleColor: [UIColor blackColor]
                          forState: UIControlStateNormal];
        [_doneButton addTarget: self
                        action: @selector(_handleDoneButtonTappedEvent:)
              forControlEvents: UIControlEventTouchUpInside];
        
        [self addSubview: _doneButton];
        
        _rightNavigationButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
        [_rightNavigationButton setBackgroundImage: [UIImage imageNamed: @"GRShareButton"]
                                          forState: UIControlStateNormal];
        [_rightNavigationButton addTarget: self
                                   action: @selector(_handleShareButtonTappedEvent:)
                         forControlEvents: UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"in func: %s", __func__);
    
    [_rightNavigationButton release];
    [_resourceInfo release];

    [_doneButton release];
    
    [_package release];
    [_packageView release];
    
    [_previewController release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    CGRect bounds = [self bounds];
    [_packageView setFrame: bounds];
    
    [self bringSubviewToFront: _doneButton];
    [_doneButton setFrame: CGRectMake(20, bounds.size.height - 60, bounds.size.width - 20 * 2, 40)];
}

- (void)setPackageView: (UIView *)packageView
{
    if (_packageView != packageView)
    {
        [_packageView removeFromSuperview];        
        _packageView = packageView;
        [self addSubview: _packageView];
        
        [_packageView setFrame: [self bounds]];
    }
}

- (void)_createPreviewControllerIfNeeded
{
    if (!_previewController)
    {
        _previewController = [[QLPreviewController alloc] init];
        [_previewController setDataSource: self];
        [_previewController setDelegate: self];
    }
}

- (void)setResourceInfo: (NSDictionary *)resourceInfo
{
    if (_resourceInfo != resourceInfo)
    {
        [_resourceInfo release];
        _resourceInfo = [resourceInfo retain];
        
        [self setTitle: _resourceInfo[GRResourceName]];
        
        NSString *path = [GRResourceManager pathWithSubPath: _resourceInfo[GRResourcePath]];
        NSString *resourceType = _resourceInfo[GRResourceTypeKey];
        
        if ([resourceType isEqualToString: GRResourceTypePDF] || [path hasSuffix: @".pdf"])
        {
            [self setPackage: nil];
            
            ReaderDocument *document = [[ReaderDocument alloc] initWithFilePath: path
                                                                       password: nil];
            
            ReaderView *view = [[ReaderView alloc] initWithDocument: document];
            
            [self setPackageView: view];
            
            [view release];
            [document release];
            
            [_doneButton setAlpha: 0];
            
        }else if([resourceType isEqualToString: GRResourceTypePPT]
                 || [resourceType isEqualToString: GRResourceTypeWord]
                 || [resourceType isEqualToString: GRResourceTypeExcel])
        {
            [self _createPreviewControllerIfNeeded];
            
            UIView *view = [_previewController view];
            [view setFrame: [self bounds]];
            
            [self addSubview: view];
            
//            [_previewController reloadData];
            
        }else
        {
            GRHTMLPackage *package = [[GRHTMLPackage alloc] initWithPath: path];
            
            NSDictionary *savedContext = ERSSC(GRDataServiceID,
                                               GRDataServiceLessonRecordForIDAction,
                                               @[ _resourceInfo[GRResourceID] ]);
            if (savedContext)
            {
                [package updateWithRecord: savedContext];
            }
            
            [self setPackage: package];
            [package release];
            
            [self setPackageView: [_package view]];
        }
    }
}

- (NSInteger)numberOfPreviewItemsInPreviewController: (QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController: (QLPreviewController *)controller
                     previewItemAtIndex: (NSInteger)index
{
    NSString *path = [GRResourceManager pathWithSubPath: _resourceInfo[GRResourcePath]];
    NSURL *fileURL = [NSURL fileURLWithPath: path];
    return fileURL;
}

- (void)_handleDoneButtonTappedEvent: (id)sender
{
    NSDictionary *lessonContext = [_package savedContext];
    
    NSLog(@"result: %@", lessonContext);
    
    ERSC(GRDataServiceID,
         GRDataServiceSaveLessonForIDAction,
         @[lessonContext, _resourceInfo[GRResourceID] ], nil);
    
    ERSC(GRViewServiceID, GRViewServicePopContentViewAction, nil, nil);
}

- (void)_handleShareButtonTappedEvent: (id)sender
{
    NSArray *sharedData = @[ _resourceInfo[GRResourceName] ];
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems: sharedData
                                                                                      applicationActivities: nil];
    
    UIViewController *rootViewController = ERSSC(GRViewServiceID, GRViewServiceRootViewControllerAction, nil);
    [rootViewController presentViewController: shareViewController
                                     animated: YES
                                   completion: nil];
    [shareViewController release];
}

@end
