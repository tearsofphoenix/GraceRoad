//
//  NSString+EditingMatch.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/25/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NSString+EditingMatch.h"

#import <NoahsService/NoahsService.h>

#import "NSString+LatinTransliteration.h"

@implementation NSString (EditingMatch)

- (BOOL)couldMatch: (NSString *)editingString
       replacement: (NSString *)replacement
       withinRange: (NSRange)editingRange
{
    
    BOOL found = NO;
    
    NSString *text = [editingString stringByReplacingCharactersInRange: editingRange withString: replacement];
    
    NSInteger looper = editingRange.location;
    while ((looper > 0) && (!found))
    {
        --looper;
        
        unichar character = [text characterAtIndex: looper];
        
        BOOL isDigit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember: character];
        BOOL isUppercaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember: character];
        BOOL isLowercaseLetter =[[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember: character];
        BOOL isDecomposableCharacter = [[NSCharacterSet decomposableCharacterSet] characterIsMember: character];
        BOOL isWhitespace = [[NSCharacterSet whitespaceCharacterSet] characterIsMember: character];
        if (!(isDigit || isUppercaseLetter || isLowercaseLetter || isDecomposableCharacter || isWhitespace))
        {
            found = YES;
        }
        
    }
    
    NSRange newRange = NSMakeRange(0, editingRange.location + [replacement length]);
    if (found)
    {
        newRange = NSMakeRange(looper + 1, editingRange.location + [replacement length] - looper - 1);
    }
    
    editingString = text;
    replacement = [text substringWithRange: newRange];
    editingRange = newRange;
    
    editingString = [editingString stringByReplacingOccurrencesOfString: @"\\s"
                                                             withString: @" "
                                                                options: NSRegularExpressionSearch
                                                                  range: NSMakeRange(0, [editingString length])];
    
    replacement = [replacement stringByReplacingOccurrencesOfString: @"\\s"
                                                         withString: @" "
                                                            options: NSRegularExpressionSearch
                                                              range: NSMakeRange(0, [replacement length])];
    
    BOOL couldContinue = YES;
    
    NSRange replacingRange = NSMakeRange(0, [self length]);
    
    if (editingRange.location > 0)
    {
        
        NSString *left = [editingString substringToIndex: editingRange.location];
        NSRange leftRange = [self rangeOfString: left];
        if (leftRange.location == NSNotFound)
        {
            couldContinue = NO;
        }
        
        replacingRange = NSMakeRange(leftRange.location + leftRange.length,
                                     [self length] - leftRange.location - leftRange.length);
        
        if (couldContinue)
        {
            
            if (editingRange.location + editingRange.length < [editingString length])
            {
                
                NSString *right = [editingString substringFromIndex: editingRange.location + editingRange.length];
                NSRange rightRange = [self rangeOfString: right];
                
                if (rightRange.location == NSNotFound)
                {
                    couldContinue = NO;
                }
                
                replacingRange = NSMakeRange(leftRange.location + leftRange.length,
                                             rightRange.location - leftRange.location - leftRange.length);
                
            }
            
        }
        
    }
    else
    {
        
        if (editingRange.location + editingRange.length < [editingString length])
        {
            
            NSString *right = [editingString substringFromIndex: editingRange.location + editingRange.length];
            NSRange rightRange = [self rangeOfString: right];
            
            if (rightRange.location == NSNotFound)
            {
                couldContinue = NO;
            }
            
            replacingRange = NSMakeRange(0, rightRange.location);
            
        }
        
    }
    
    if (couldContinue)
    {
        
        if ([replacement length] > 0)
        {
            
            if (replacingRange.length > 0)
            {
                
                NSString *replacing = [self substringWithRange: replacingRange];
                replacing = [[replacing stringByReplacingOccurrencesOfString: @"[\\s]+"
                                                                  withString: @" "
                                                                     options: NSRegularExpressionSearch
                                                                       range: NSMakeRange(0, [replacing length])] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *latinReplacing = [replacing latinTransliterationForUsages: [NSSet setWithObjects:
                                                                                      ERLocaleServiceForStringOfNoLatinIntonationUsage,
                                                                                      ERLocaleServiceForStringIgnoringCasesUsage,
                                                                                      nil]];
                latinReplacing = [[latinReplacing stringByReplacingOccurrencesOfString: @"[\\s]+"
                                                                            withString: @" "
                                                                               options: NSRegularExpressionSearch
                                                                                 range: NSMakeRange(0, [latinReplacing length])] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if (([replacing rangeOfString: replacement options: NSCaseInsensitiveSearch].location == 0) ||
                    ([latinReplacing rangeOfString: replacement options: NSCaseInsensitiveSearch].location == 0))
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
                
            }
            else if (replacingRange.length == 0)
            {
                
                if ([replacement length] == 0)
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
                
            }
            else
            {
                return NO;
            }
            
        }
        else
        {
            return YES;
        }
        
    }
    else
    {
        return NO;
    }
    
}

@end
