//
//  ERPDFDocument.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/19/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERPDFDocument.h"

#import "ERPDFPage.h"

#import "NSURL+ApplicationURL.h"

@implementation ERPDFDocument

@synthesize CGPDFDocument = _CGPDFDocument;

- (id)initWithFilePath: (NSString *)filePath
{
    return [self initWithURL: [NSURL fileURLWithPath: filePath]];
}

- (id)initWithURL: (NSURL *)URL
{
    
    self = [super init];
    if (self)
    {
        
        URL = [NSURL URLForApplicationURL: URL];
        
        _CGPDFDocument = CGPDFDocumentCreateWithURL((CFURLRef)URL);
        
        _URL = URL;
        
        [_URL retain];
        
    }
    
    return self;
}

- (void)dealloc
{
    
    [_URL release];
    
    CGPDFDocumentRelease(_CGPDFDocument);
    
    [super dealloc];
    
}
- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfPagesInSectionAtIndex: (NSInteger)section
{
    return CGPDFDocumentGetNumberOfPages(_CGPDFDocument);
}

- (NSString *)nameOfSectionAtIndex: (NSInteger)section
{
    return @"Contents";
}

- (NSInteger)sectionIndexForName: (NSString *)name
{
    return 0;
}

- (ERPDFPage *)pageAtIndexPath: (NSIndexPath *)indexPath
{
    return [[[ERPDFPage alloc] initWithPDFDocument: self
                                     pageIndexPath: indexPath] autorelease];
}

@end
