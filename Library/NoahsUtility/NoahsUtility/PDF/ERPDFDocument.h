//
//  ERPDFDocument.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/19/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

@class ERPDFPage;

@interface ERPDFDocument: NSObject
{
    
    CGPDFDocumentRef _CGPDFDocument;
    
    NSURL *_URL;
    
}

- (id)initWithFilePath: (NSString *)filePath;

- (id)initWithURL: (NSURL *)URL;

@property (nonatomic, readonly) CGPDFDocumentRef CGPDFDocument;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfPagesInSectionAtIndex: (NSInteger)section;

- (NSString *)nameOfSectionAtIndex: (NSInteger)section;

- (NSInteger)sectionIndexForName: (NSString *)name;

- (ERPDFPage *)pageAtIndexPath: (NSIndexPath *)indexPath;

@end
