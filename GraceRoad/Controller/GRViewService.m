//
//  GRViewService.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-3.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRViewService.h"
#import "GRMainViewController.h"
#import "UIAlertView+BlockSupport.h"

#import <PDFReader/ReaderViewController.h>

@interface GRViewService ()<ReaderViewControllerDelegate>

@property (nonatomic, assign) GRMainViewController *rootViewController;

@end

@implementation GRViewService

+ (void)load
{
    [self registerServiceClass: self];
}

+ (NSString *)serviceIdentifier
{
    return GRViewServiceID;
}

- (void)registerRootViewController: (GRMainViewController *)rootViewController
{
    _rootViewController = rootViewController;
}

- (void)pushContentView: (GRContentView *)contentView
{
    [_rootViewController pushContentView: contentView];
}

- (void)popContentView
{
    [_rootViewController popLastContentView];
}

- (void)showLoadingIndicator
{
    [_rootViewController showLoadingIndicator];
}

- (void)hideLoadingIndicator
{
    [_rootViewController hideLoadingIndicator];
}

- (void)showDailyScripture: (NSDictionary *)scripture
{
    [[UIAlertView alertWithTitle: @"每日读经"
                         message: [NSString stringWithFormat: @"%@\n%@\n%@",
                                   scripture[@"address"],
                                   scripture[@"zh_TW"],
                                   scripture[@"en"]]
               cancelButtonTitle: @"确定"
               otherButtonTitles: nil
                        callback: nil] show];
}

- (void)viewPDFAtPath: (NSString *)path
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath: path
                                                           password: phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument: document];
        
		[readerViewController setDelegate: self]; // Set the ReaderViewController delegate to self
        
		[readerViewController setModalTransitionStyle: UIModalTransitionStyleCrossDissolve];
		[readerViewController setModalPresentationStyle: UIModalPresentationFullScreen];
        
		[_rootViewController presentViewController: readerViewController
                                          animated: YES
                                        completion: nil];
        [readerViewController release];
	}
}

- (void)dismissReaderViewController: (ReaderViewController *)viewController
{
    [_rootViewController dismissViewControllerAnimated: YES
                                            completion: nil];
}

@end
