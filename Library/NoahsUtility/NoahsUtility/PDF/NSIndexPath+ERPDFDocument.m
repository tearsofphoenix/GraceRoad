//
//  NSIndexPath+ERPDFDocument.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/19/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSIndexPath+ERPDFDocument.h"

@implementation NSIndexPath(ERPDFDocument)

+ (NSIndexPath *)indexPathForPageIndex: (NSUInteger)pageIndex
                             inSection: (NSUInteger)sectionIndex
{
    
    NSUInteger indexes[2] = {sectionIndex, pageIndex};
    
    return [NSIndexPath indexPathWithIndexes: indexes
                                      length: 2];
    
}

+ (NSIndexPath *)indexPathForPageNumber: (NSUInteger)pageNumber
                              inSection: (NSUInteger)sectionIndex
{
    
    NSUInteger indexes[2] = {sectionIndex, pageNumber - 1};
    
    return [NSIndexPath indexPathWithIndexes: indexes
                                      length: 2];
    
}

- (NSUInteger)pageIndex
{
    return [self indexAtPosition: 1];
}

- (NSUInteger)pageNumber
{
    return [self indexAtPosition: 1] + 1;
}

@end
