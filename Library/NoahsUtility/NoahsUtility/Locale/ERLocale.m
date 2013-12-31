//
//  ERLocale.m
//  NoahsLaboratory
//
//  Created by Minun Dragonation on 2/28/13.
//  Copyright (c) 2013 Minun Dragonation. All rights reserved.
//

//#import "ERLocale.h"

#import <NoahsUtility/NoahsUtility.h>

//#import "ERLocaleSettings.h"

//#import "NSString+NumberOfOccurrence.h"
//
//#import "NSString+RegularExpression.h"

@implementation ERLocale

- (id)initWithNSLocale: (NSLocale *)locale
           superlocale: (ERLocale *)superlocale
{
    
    self = [super init];
    if (self)
    {
        
        _locale = [locale retain];
        
        _superlocale = [superlocale retain];
        
        _translations = [[NSMutableDictionary alloc] init];
        
        _settings = [[NSMutableDictionary alloc] init];
        
        _pointerComparator = ERBlockCopy(^NSComparisonResult(id object, id object2, NSSet *usages)
                                         {
                                             
                                             if (object < object2)
                                             {
                                                 return NSOrderedAscending;
                                             }
                                             else if (object > object2)
                                             {
                                                 return NSOrderedDescending;
                                             }
                                             else
                                             {
                                                 
                                                 if (_superlocale)
                                                 {
                                                     return [_superlocale comparatorForUsages: usages](object, object2, usages);
                                                 }
                                                 else
                                                 {
                                                     return NSOrderedSame;
                                                 }
                                                 
                                             }
                                             
                                         });
        
        _numberComparator = ERBlockCopy(^NSComparisonResult(id object, id object2, NSSet *usages)
                                        {
                                            
                                            if ([object isKindOfClass: [NSNull class]])
                                            {
                                                object = nil;
                                            }
                                            
                                            if ([object isKindOfClass: [NSNull class]])
                                            {
                                                object2 = nil;
                                            }
                                            
                                            double doubleValue = [object doubleValue];
                                            double doubleValue2 = [object2 doubleValue];
                                            
                                            if (doubleValue < doubleValue2)
                                            {
                                                return NSOrderedAscending;
                                            }
                                            else if (doubleValue > doubleValue2)
                                            {
                                                return NSOrderedDescending;
                                            }
                                            else
                                            {
                                                
                                                if (_superlocale)
                                                {
                                                    return [_superlocale comparatorForUsages: usages](object, object2, usages);
                                                }
                                                else
                                                {
                                                    return NSOrderedSame;
                                                }
                                                
                                            }
                                            
                                        });
        
        _stringComparator = ERBlockCopy(^NSComparisonResult(id object, id object2, NSSet *usages)
                                        {
                                            
                                            if ([object isKindOfClass: [NSNull class]])
                                            {
                                                object = nil;
                                            }
                                            
                                            if ([object isKindOfClass: [NSNull class]])
                                            {
                                                object2 = nil;
                                            }
                                            
                                            if ([usages containsObject: ERLocaleServiceForStringOfLatinTransliterationUsage])
                                            {
                                                object = [object latinTransliterationForUsages: usages];
                                                object2 = [object2 latinTransliterationForUsages: usages];
                                            }

                                            if (!object)
                                            {
                                                
                                                if (!object2)
                                                {
                                                    return NSOrderedSame;
                                                }
                                                else
                                                {
                                                    return NSOrderedAscending;
                                                }
                                                
                                            }
                                            else if (!object2)
                                            {
                                                return NSOrderedDescending;
                                            }
                                            else
                                            {
                                                
                                                NSComparisonResult result = [object compare: object2
                                                                                    options: 0];
                                                if (result == NSOrderedSame)
                                                {
                                                    
                                                    if (_superlocale)
                                                    {
                                                        return [_superlocale comparatorForUsages: usages](object, object2, usages);
                                                    }
                                                    else
                                                    {
                                                        return NSOrderedSame;
                                                    }
                                                    
                                                }
                                                else
                                                {
                                                    return result;
                                                }
                                                
                                            }
                                            
                                        });
        
        _stringComparatorIgnoringCases = ERBlockCopy(^NSComparisonResult(id object, id object2, NSSet *usages)
                                                     {
                                                         
                                                         if ([object isKindOfClass: [NSNull class]])
                                                         {
                                                             object = nil;
                                                         }
                                                         
                                                         if ([object isKindOfClass: [NSNull class]])
                                                         {
                                                             object2 = nil;
                                                         }
                                                         
                                                         if ([usages containsObject: ERLocaleServiceForStringOfLatinTransliterationUsage])
                                                         {
                                                             object = [object latinTransliterationForUsages: usages];
                                                             object2 = [object2 latinTransliterationForUsages: usages];
                                                         }
                                                         
                                                         if (!object)
                                                         {
                                                             
                                                             if (!object2)
                                                             {
                                                                 return NSOrderedSame;
                                                             }
                                                             else
                                                             {
                                                                 return NSOrderedAscending;
                                                             }
                                                             
                                                         }
                                                         else if (!object2)
                                                         {
                                                             return NSOrderedDescending;
                                                         }
                                                         else
                                                         {
                                                             
                                                             NSComparisonResult result = [object compare: object2
                                                                                                 options: NSCaseInsensitiveSearch];
                                                             if (result == NSOrderedSame)
                                                             {
                                                                 
                                                                 if (_superlocale)
                                                                 {
                                                                     return [_superlocale comparatorForUsages: usages](object, object2, usages);
                                                                 }
                                                                 else
                                                                 {
                                                                     return NSOrderedSame;
                                                                 }
                                                                 
                                                             }
                                                             else
                                                             {
                                                                 return result;
                                                             }
                                                             
                                                         }
                                                         
                                                     });
        
    }
    
    return self;
}

- (NSString *)transformString: (NSString *)string
                        usage: (NSString *)usage
{
    
    if ([usage isEqualToString: ERLocaleServiceStringTransformForLowercases])
    {
        
        if ([string respondsToSelector: @selector(lowercaseStringWithLocale:)])
        {
            return [string lowercaseStringWithLocale: _locale];
        }
        else
        {
            return [string lowercaseString];
        }
        
    }
    else if ([usage isEqualToString: ERLocaleServiceStringTransformForUppercases])
    {

        if ([string respondsToSelector: @selector(uppercaseStringWithLocale:)])
        {
            return [string uppercaseStringWithLocale: _locale];
        }
        else
        {
            return [string uppercaseString];
        }
        
    }
    else
    {
        
        if (_superlocale)
        {
            return [_superlocale transformString: string
                                           usage: usage];
        }
        else
        {
            return string;
        }
        
    }
    
}

- (void)dealloc
{
    
    ERBlockRelease(_stringComparatorIgnoringCases);
    ERBlockRelease(_stringComparator);
    ERBlockRelease(_numberComparator);
    ERBlockRelease(_pointerComparator);
    
    [_translations release];
    
    [_superlocale release];
    
    [_locale release];
    
    [super dealloc];
}

- (NSLocale *)NSLocale
{
    return _locale;
}

- (NSString *)latinTransliteration: (NSString *)sourceText
{
    return [self latinTransliteration: sourceText
                               usages: nil];
}

- (NSString *)latinTransliteration: (NSString *)sourceText
                             usage: (NSString *)usage
{
    
    if (usage)
    {
        return [self latinTransliteration: sourceText
                                   usages: [NSSet setWithObject: usage]];
    }
    else
    {
        return [self latinTransliteration: sourceText
                                   usages: nil];
    }
    
}

- (NSString *)latinTransliteration: (NSString *)sourceText
                            usages: (NSSet *)usages
{
    
    if (_superlocale)
    {
        return [_superlocale latinTransliteration: sourceText
                                           usages: usages];
    }
    else
    {
        return sourceText;
    }
    
}

- (ERLocaleComparator)comparatorForUsage: (NSString *)usage
{
    
    if (usage)
    {
        return [self comparatorForUsages: [NSSet setWithObject: usage]];
    }
    else
    {
        return [self comparatorForUsages: nil];
    }
    
}

- (ERLocaleComparator)comparatorForUsages: (NSSet *)usages
{
    
    if ([usages containsObject: ERLocaleServiceForNumberUsage])
    {
        return _numberComparator;
    }
    else if ([usages containsObject: ERLocaleServiceForStringIgnoringCasesUsage])
    {
        return _stringComparatorIgnoringCases;
    }
    else if ([usages containsObject: ERLocaleServiceForStringUsage])
    {
        return _stringComparator;
    }
    else
    {
        
        if (_superlocale)
        {
            return [_superlocale comparatorForUsages: usages];
        }
        else
        {
            return _pointerComparator;
        }
        
    }
    
}

- (void)loadTranslationDictionary: (NSDictionary *)translationDictionary
                     forNamespace: (NSString *)translationNamespace
                    withThemeName: (NSString *)themeName
{
    
    NSMutableDictionary *dictionary = [_translations objectOrNilForKey: themeName];
    if (!dictionary)
    {
        
        dictionary = [NSMutableDictionary dictionary];
        
        [_translations setObjectOrNil: dictionary
                               forKey: themeName];
        
    }
    
    NSMutableDictionary *dictionary2 = [dictionary objectOrNilForKey: translationNamespace];
    if (!dictionary2)
    {
        
        dictionary2 = [NSMutableDictionary dictionary];
        
        [dictionary setObjectOrNil: dictionary2
                            forKey: translationNamespace];
        
    }
    
    [dictionary2 addEntriesFromDictionary: translationDictionary];
    
}

- (id)translationForKey: (id)key
            inNamespace: (NSString *)translationNamespace
          withThemeName: (NSString *)themeName
{
    
    id translation = [[[_translations objectOrNilForKey: themeName] objectOrNilForKey: translationNamespace] objectOrNilForKey: key];
    if (!translation)
    {
        translation = [_superlocale translationForKey: key
                                          inNamespace: translationNamespace
                                        withThemeName: themeName];
    }
    
    return translation;
}

- (void)setTranslation: (id)translation
                forKey: (id)key
           inNamespace: (NSString *)translationNamespace
         withThemeName: (NSString *)themeName
{
    
    NSMutableDictionary *dictionary = [_translations objectOrNilForKey: themeName];
    if (!dictionary)
    {
        
        dictionary = [NSMutableDictionary dictionary];
        
        [_translations setObjectOrNil: dictionary
                               forKey: themeName];
        
    }
    
    NSMutableDictionary *dictionary2 = [dictionary objectOrNilForKey: translationNamespace];
    if (!dictionary2)
    {
        
        dictionary2 = [NSMutableDictionary dictionary];
        
        [dictionary setObjectOrNil: dictionary2
                            forKey: translationNamespace];
        
    }
    
    [dictionary2 setObject: translation
                    forKey: key];
    
}

- (NSString *)localeIdentifier
{
    return [_locale localeIdentifier];
}

- (NSString *)languageCode
{
    return [_locale objectForKey: NSLocaleLanguageCode];
}

static ERLocale *ERSharedLocale = nil;

+ (ERLocale *)sharedLocale
{
    
    if (!ERSharedLocale)
    {
        ERSharedLocale = [[ERLocale alloc] initWithNSLocale: nil
                                                superlocale: nil];
    }
    
    return ERSharedLocale;
}

+ (ERLocale *)currentLocale
{
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceCurrentLocaleAction,
                 nil);
}

- (id)objectAtThemeSettingsCollectionPath: (NSString *)collectionPath
{
    
    NSString *themeName = ERSSC(ERLocaleServiceIdentifier, ERLocaleServiceCurrentThemeNameAction, nil);
    if (themeName)
    {
        
        NSDictionary *settings = [_settings objectOrNilForKey: themeName];
        
        id object = [settings objectOrNilAtCollectionPath: collectionPath];
        if ([object isKindOfClass: [NSDictionary class]])
        {
            return [[[ERLocaleSettings alloc] initWithCollectionPath: collectionPath] autorelease];
        }

        if (!object)
        {
            object = [_superlocale objectAtThemeSettingsCollectionPath: collectionPath];
        }

        return object;
            
    }
    else
    {
        return nil;
    }
    
}

- (id)objectAtNoThemeSettingsCollectionPath: (NSString *)collectionPath
{
    
    NSDictionary *settings = [_settings objectOrNilForKey: nil];
    
    id object = [settings objectOrNilAtCollectionPath: collectionPath];
    if ([object isKindOfClass: [NSDictionary class]])
    {
        return [[[ERLocaleSettings alloc] initWithCollectionPath: collectionPath] autorelease];
    }
    
    if (!object)
    {
        object = [_superlocale objectAtNoThemeSettingsCollectionPath: collectionPath];
    }

    return object;
    
}

- (void)loadObjectSettings: (NSDictionary *)objectSettings
             withThemeName: (NSString *)themeName
{
    
    NSMutableDictionary *settings = [_settings objectOrNilForKey: themeName];
    if (!settings)
    {
        
        settings = [NSMutableDictionary dictionary];
        
        [_settings setObjectOrNil: settings forKey: themeName];
        
    }
    
    for (NSString *collectionPath in objectSettings)
    {
        
        NSMutableDictionary *dictionary = settings;
        
        [dictionary setObjectOrNil: [objectSettings objectOrNilForKey: collectionPath]
                  atCollectionPath: collectionPath];
        
    }
    
    NSDictionary *fontsInstallation = [settings objectOrNilAtCollectionPath: @"com/eintsoft/gopher-wood/noahs-diplomat/fonts/installation"];
    for (NSString *fontName in fontsInstallation)
    {
        
        NSString *fontPath = [fontsInstallation objectOrNilForKey: fontName];
        if (fontPath)
        {
            ERSSC(ERLocaleServiceIdentifier,
                  ERLocaleServiceLoadFontAtFilePath_Action,
                  [NSArray arrayWithObject: fontPath]);
        }
        
    }

}

- (NSString *)humanReadableDescriptionForDate: (NSDate *)date
                            usingAbbreviation: (BOOL)usingAbbreviation
{
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSTimeInterval nowTimeInterval = [now timeIntervalSince1970];
    
    NSTimeInterval difference = fabs(timeInterval - nowTimeInterval);
    if (difference < 60)
    {
        
        if (timeInterval < nowTimeInterval)
        {
            return @"just now";
        }
        else
        {
            
            if (usingAbbreviation)
            {
                return @"in 1 min";
            }
            else
            {
                return @"in 1 minute";
            }
            
        }
        
    }
    else if (difference < 45 * 60)
    {
        
        if (usingAbbreviation)
        {
            
            if (timeInterval < nowTimeInterval)
            {
                return [NSString stringWithFormat: @"%d mins ago", (int)ceil(difference / 60)];
            }
            else
            {
                return [NSString stringWithFormat: @"in %d mins", (int)ceil(difference / 60)];
            }
            
        }
        else
        {
            
            if (timeInterval < nowTimeInterval)
            {
                return [NSString stringWithFormat: @"%d minutes ago", (int)ceil(difference / 60)];
            }
            else
            {
                return [NSString stringWithFormat: @"in %d minutes", (int)ceil(difference / 60)];
            }
            
        }
        
    }
    else if (difference < 1.2 * 60 * 60)
    {
        
        if (usingAbbreviation)
        {
            
            if (timeInterval < nowTimeInterval)
            {
                return [NSString stringWithFormat: @"an hr ago"];
            }
            else
            {
                return [NSString stringWithFormat: @"in an hr"];
            }

        }
        else
        {
            
            if (timeInterval < nowTimeInterval)
            {
                return [NSString stringWithFormat: @"1 hour ago"];
            }
            else
            {
                return [NSString stringWithFormat: @"in 1 hour"];
            }
            
        }
        
    }
    else if (difference < 3 * 60 * 60)
    {
        
        if (usingAbbreviation)
        {
            
            if (timeInterval < nowTimeInterval)
            {
                return [NSString stringWithFormat: @"%d hrs ago", (int)ceil(difference / 60 / 60)];
            }
            else
            {
                return [NSString stringWithFormat: @"in %d hrs", (int)ceil(difference / 60 / 60)];
            }
            
        }
        else
        {
            
            if (timeInterval < nowTimeInterval)
            {
                return [NSString stringWithFormat: @"%d hours ago", (int)ceil(difference / 60 / 60)];
            }
            else
            {
                return [NSString stringWithFormat: @"in %d hours", (int)ceil(difference / 60 / 60)];
            }
            
        }
        
    }
    else if ([now isTheSameDayAs: date])
    {
        return [date stringWithFormat: @"HH':'mm"];
    }
    else if (([[now previousDate] isTheSameDayAs: date]) && (!usingAbbreviation))
    {
        if (([date hour] == 0) && ([date minute] == 0) && ([date second] == 0))
        {
            return @"yesterday";
        }
        else
        {
            return [date stringWithFormat: @"'yesterday 'HH':'mm"];
        }
    }
    else if (([[now nextDate] isTheSameDayAs: date]) && (!usingAbbreviation))
    {
        if (([date hour] == 0) && ([date minute] == 0) && ([date second] == 0))
        {
            return @"tomorrow";
        }
        else
        {
            return [date stringWithFormat: @"'tomorrow 'HH':'mm"];
        }
    }
    else if ([now year] == [date year])
    {
        if (([date hour] == 0) && ([date minute] == 0) && ([date second] == 0))
        {
            return [date stringWithFormat: @"M'-'d"];
        }
        else
        {
            return [date stringWithFormat: @"M'-'d' 'HH':'mm"];
        }
    }
    else
    {
        
        if (usingAbbreviation)
        {
            return [date stringWithFormat: @"yy'-'M'-'d"];
        }
        else
        {
            return [date stringWithFormat: @"yyyy'-'M'-'d"];
        }
        
    }
    
}

- (BOOL)couldTextBeRegardedAsName: (NSString *)name
{
    return ([name matchesRegularExpression: @"^[a-zA-Z]+ [a-zA-Z]+$"]);
}

- (NSString *)nameCombinedFromFamilyName: (NSString *)familyName
                               givenName: (NSString *)givenName
{
    return [[[givenName stringByAppendingString: @" "] stringByAppendingString: familyName] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)familyNameFromCombinedName: (NSString *)name
{
    
    NSUInteger location = [name rangeOfString: @" "].location;
    if (location != NSNotFound)
    {
        return [name substringFromIndex: [name rangeOfString: @" "].location + 1];
    }
    else
    {
        return name;
    }
    
}

- (NSString *)givenNameFromCombinedName: (NSString *)name
{
    
    NSUInteger location = [name rangeOfString: @" "].location;
    if (location != NSNotFound)
    {
        return [name substringToIndex: [name rangeOfString: @" "].location];
    }
    else
    {
        return @"";
    }
    
}

- (BOOL)couldTextBeRegardedAsFamilyName: (NSString *)familyName
{
    return ([familyName matchesRegularExpression: @"^[a-zA-Z]+$"]);
}

- (BOOL)couldTextBeRegardedAsGivenName: (NSString *)givenName
{
    return ([givenName matchesRegularExpression: @"^[a-zA-Z]+$"]);
}

@end
