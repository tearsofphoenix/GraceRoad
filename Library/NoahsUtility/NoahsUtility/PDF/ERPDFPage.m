//
//  ERPDFPage.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/19/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERPDFPage.h"

#import "NSDictionary+NSNull.h"

#import "ERPDFDocument.h"

#import "NSIndexPath+ERPDFDocument.h"

@implementation ERPDFPage

@synthesize CGPDFPage = _CGPDFPage;

- (id)initWithPDFDocument: (ERPDFDocument *)document
            pageIndexPath: (NSIndexPath *)indexPath
{
    
    self = [super init];
    if (self)
    {
        
        _CGPDFPage = CGPDFDocumentGetPage([document CGPDFDocument], [indexPath pageNumber]);
        
        CGPDFPageRetain(_CGPDFPage);
        
    }
    
    return self;
}

- (void)dealloc
{
    
    CGPDFPageRelease(_CGPDFPage);
    
    [super dealloc];
    
}

- (CGSize)pageSize
{
    
    CGPDFDictionaryRef pageDictionary = CGPDFPageGetDictionary(_CGPDFPage);
    
    CGRect pageRect = CGPDFPageGetBoxRect(_CGPDFPage, kCGPDFMediaBox);
    
    CGPDFInteger pageRotate = 0;

    CGPDFDictionaryGetInteger(pageDictionary, "Rotate", &pageRotate);
    
    if((pageRotate == 90) || (pageRotate == 270))
    {
        CGFloat temp = pageRect.size.width;
        pageRect.size.width = pageRect.size.height;
        pageRect.size.height = temp;
    }
    
    return pageRect.size;
}

- (UIImage *)contentImageWithPageScale: (CGFloat)pageScale
{
    
    CGSize pageSize = [self pageSize];
    
    pageSize = CGSizeMake(pageSize.width * pageScale, pageSize.height * pageScale);
    
    UIGraphicsBeginImageContextWithOptions(pageSize, YES, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0, 0, pageSize.width, pageSize.height));
    
    CGContextSaveGState(context);
    
    CGFloat pageRotation = [self pageRotation];
    
    if (pageRotation == 0)
    {
        CGContextTranslateCTM(context, 0.0, pageSize.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    else if (pageRotation == 90)
    {
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextRotateCTM(context, - M_PI / 2);
    }
    else if ((pageRotation == 180) || (pageRotation == -180))
    {
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, pageSize.width, 0);
        CGContextRotateCTM(context, M_PI / 2);
    }
    else if ((pageRotation == 270) || (pageRotation==-90))
    {
        CGContextTranslateCTM(context, pageSize.width, pageSize.height);
        CGContextRotateCTM(context, M_PI / 2);
        CGContextScaleCTM(context, -1.0, 1.0);
    }
	
    CGContextScaleCTM(context, pageScale, pageScale);
            
    CGContextDrawPDFPage(context, _CGPDFPage);

    CGContextRestoreGState(context);
    
    UIImage *contentImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return contentImage;
}

- (CGFloat)pageRotation
{
    
    CGPDFDictionaryRef pageDictionary = CGPDFPageGetDictionary(_CGPDFPage);
    
    CGPDFInteger pageRotate = 0;
    
    CGPDFDictionaryGetInteger(pageDictionary, "Rotate", &pageRotate);
    
    return pageRotate;
}

- (NSArray *)links
{
    
    CGPDFDictionaryRef pageDictionary = CGPDFPageGetDictionary(_CGPDFPage);
    
    CGPDFArrayRef annotations;
    if(!CGPDFDictionaryGetArray(pageDictionary, "Annots", &annotations))
    {
        return nil;
    }
    
    NSInteger numberOfAnnotations = CGPDFArrayGetCount(annotations);

    NSMutableArray *links = [NSMutableArray array];
    
    BOOL exceptionOccurred = NO;
    NSInteger looper = 0;
    while ((looper < numberOfAnnotations) && (!exceptionOccurred))
    {
        
        CGPDFObjectRef object;
        if(!CGPDFArrayGetObject(annotations, looper, &object))
        {
            exceptionOccurred = YES;
        }
        
        CGPDFDictionaryRef annotation;
        if (!exceptionOccurred)
        {
            if(!CGPDFObjectGetValue(object, kCGPDFObjectTypeDictionary, &annotation))
            {
                exceptionOccurred = YES;
            }
        }
        
        CGPDFDictionaryRef anchor;
        if (!exceptionOccurred)
        {
            if(!CGPDFDictionaryGetDictionary(annotation, "A", &anchor))
            {
                exceptionOccurred = YES;
            }
        }
        
        CGPDFStringRef URI;
        if (!exceptionOccurred)
        {
            if(!CGPDFDictionaryGetString(anchor, "URI", &URI))
            {
                exceptionOccurred = YES;
            }
        }
        
        CGPDFArrayRef rectArray = NULL;
        if (!exceptionOccurred)
        {
            if(!CGPDFDictionaryGetArray(annotation, "Rect", &rectArray))
            {
                exceptionOccurred = YES;
            }
        }
        
        CGPDFReal coordinates[4] = {0, 0, 0, 0};
        if (!exceptionOccurred)
        {
            
            NSInteger rectCoordinatesCount = CGPDFArrayGetCount(rectArray);
            
            NSInteger looper2 = 0;
            while ((looper2 < rectCoordinatesCount) && (!exceptionOccurred))
            {
                
                CGPDFObjectRef rectObject;
                if(!CGPDFArrayGetObject(rectArray, looper2, &rectObject))
                {
                    exceptionOccurred = YES;
                }
                
                CGPDFReal coordinate;
                if (!exceptionOccurred)
                {
                    
                    if(!CGPDFObjectGetValue(rectObject, kCGPDFObjectTypeReal, &coordinate))
                    {
                        exceptionOccurred = YES;
                    }
                    
                    if (!exceptionOccurred)
                    {
                        coordinates[looper2] = coordinate;
                    }
                    
                }
                
                ++looper2;
            }
            
        }
        
        NSString *URIString = nil;
        if (!exceptionOccurred)
        {
            URIString = [NSString stringWithCString: (char *)CGPDFStringGetBytePtr(URI)
                                           encoding: NSUTF8StringEncoding];
        }
        
        CGRect rect;
        if (!exceptionOccurred)
        {
            
            rect = CGRectMake(coordinates[0], coordinates[1], coordinates[2], coordinates[3]);

            CGPDFInteger pageRotate = 0;
            CGPDFDictionaryGetInteger(pageDictionary, "Rotate", &pageRotate);
            CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(_CGPDFPage, kCGPDFMediaBox));
            
            if((pageRotate == 90) || (pageRotate == 270))
            {
                CGFloat temp = pageRect.size.width;
                pageRect.size.width = pageRect.size.height;
                pageRect.size.height = temp;
            }
            
            rect.size.width -= rect.origin.x;
            rect.size.height -= rect.origin.y;
            
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, 0, pageRect.size.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
            rect = CGRectApplyAffineTransform(rect, transform);
        
        }
        
        if (!exceptionOccurred)
        {
            [links addObject: [NSDictionary dictionaryWithKeysAndObjectsOrNils:
                               ERPDFPageLinkTargetURL, [NSURL URLWithString: URIString],
                               ERPDFPageLinkRect, [NSValue valueWithCGRect: rect],
                               nil]];
        }
        
        ++looper;
    }
    
    if (!exceptionOccurred)
    {
        return links;
    }
    else
    {
        return nil;
    }
    
}

@end
