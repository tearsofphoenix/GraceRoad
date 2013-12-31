//
//  NSIndexPath+ERPDFDocument.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/19/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (ERPDFDocument)

+ (NSIndexPath *)indexPathForPageIndex: (NSUInteger)pageIndex
                             inSection: (NSUInteger)sectionIndex;

+ (NSIndexPath *)indexPathForPageNumber: (NSUInteger)pageNumber
                              inSection: (NSUInteger)sectionIndex;

- (NSUInteger)pageIndex;

- (NSUInteger)pageNumber;

@end
