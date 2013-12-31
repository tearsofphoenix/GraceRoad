//
//  ERPDFPage.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/19/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

#import <UIKit/UIKit.h>

#define ERPDFPageLinkTargetURL @"linkTargetURL"
#define ERPDFPageLinkRect @"linkRect"

@class ERPDFDocument;

@interface ERPDFPage: NSObject
{
    CGPDFPageRef _CGPDFPage;
}

- (id)initWithPDFDocument: (ERPDFDocument *)document
            pageIndexPath: (NSIndexPath *)indexPath;

@property (nonatomic, readonly) CGPDFPageRef CGPDFPage;

- (CGFloat)pageRotation;

- (CGSize)pageSize;

- (UIImage *)contentImageWithPageScale: (CGFloat)pageScale;

- (NSArray *)links;

@end
