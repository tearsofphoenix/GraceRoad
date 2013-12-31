//
//  ERLocale.h
//  NoahsLaboratory
//
//  Created by Minun Dragonation on 2/28/13.
//  Copyright (c) 2013 Minun Dragonation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <NoahsService/NoahsService.h>

@interface ERLocale: NSObject
{
    
    NSLocale *_locale;
    
    ERLocale *_superlocale;
    
    NSMutableDictionary *_settings;
    
    NSMutableDictionary *_translations;
    
    @protected ERLocaleComparator _pointerComparator;
    @protected ERLocaleComparator _numberComparator;
    @protected ERLocaleComparator _stringComparator;
    @protected ERLocaleComparator _stringComparatorIgnoringCases;
    
}

- (id)initWithNSLocale: (NSLocale *)locale
           superlocale: (ERLocale *)superlocale;

- (NSLocale *)NSLocale;

- (NSString *)transformString: (NSString *)string
                        usage: (NSString *)usage;

- (void)loadTranslationDictionary: (NSDictionary *)translationDictionary
                     forNamespace: (NSString *)translationNamespace
                    withThemeName: (NSString *)themeName;

- (id)translationForKey: (id)key
            inNamespace: (NSString *)translationNamespace
          withThemeName: (NSString *)themeName;

- (void)setTranslation: (id)translation
                forKey: (id)key
           inNamespace: (NSString *)translationNamespace
         withThemeName: (NSString *)themeName;

- (NSString *)latinTransliteration: (NSString *)sourceText;

- (NSString *)latinTransliteration: (NSString *)sourceText
                             usage: (NSString *)usage;

- (NSString *)latinTransliteration: (NSString *)sourceText
                            usages: (NSSet *)usages;

- (id)objectAtThemeSettingsCollectionPath: (NSString *)collectionPath;

- (id)objectAtNoThemeSettingsCollectionPath: (NSString *)collectionPath;

- (void)loadObjectSettings: (NSDictionary *)objectSettings
             withThemeName: (NSString *)themeName;

- (ERLocaleComparator)comparatorForUsage: (NSString *)usage;

- (ERLocaleComparator)comparatorForUsages: (NSSet *)usages;

- (NSString *)localeIdentifier;

- (NSString *)languageCode;

+ (ERLocale *)sharedLocale;

+ (ERLocale *)currentLocale;

- (NSString *)humanReadableDescriptionForDate: (NSDate *)date
                            usingAbbreviation: (BOOL)usingAbbreviation;

- (BOOL)couldTextBeRegardedAsName: (NSString *)name;

- (NSString *)nameCombinedFromFamilyName: (NSString *)familyName
                               givenName: (NSString *)givenName;

- (NSString *)familyNameFromCombinedName: (NSString *)name;
- (NSString *)givenNameFromCombinedName: (NSString *)name;

- (BOOL)couldTextBeRegardedAsFamilyName: (NSString *)familyName;
- (BOOL)couldTextBeRegardedAsGivenName: (NSString *)givenName;

@end
