//
//  LocaleService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#define ERLocaleServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.locale"

#define ERLocaleServiceComparatorForUsages_Action @"comparatorForUsages:"
#define ERLocaleServiceCurrentLocaleAction @"currentLocale"
#define ERLocaleServiceCurrentNSLocaleAction @"currentNSLocale"
#define ERLocaleServiceLatinTransliteration_Action @"latinTransliteration:"
#define ERLocaleServiceLatinTransliteration_Usage_Action @"latinTransliteration:usage:"
#define ERLocaleServiceLatinTransliteration_Usages_Action @"latinTransliteration:usages:"
#define ERLocaleServiceTransformString_Usage_Action @"transformString:usage:"
#define ERLocaleServicePreferredLocalesAction @"preferredLocales"
#define ERLocaleServiceCurrentThemeNameAction @"currentThemeName"
#define ERLocaleServiceSetCurrentThemeName_Action @"setCurrentThemeName:"
#define ERLocaleServiceTranslationForKey_InNamespace_Action @"translationForKey:inNamespace:"
#define ERLocaleServiceLoadBundleTranslationDictionaryFromBundle_ResourcePath_Action @"loadBundleTranslationDictionaryFromBundle:resourcePath:"
#define ERLocaleServiceLoadTranslationDictionaryFromBundle_ResourcePath_TranslationNamespace_Action @"loadTranslationDictionaryFromBundle:resourcePath:translationNamespace:"
#define ERLocaleServicePrepareForLocalizableStringsInBundle_Action @"prepareForLocalizableStringsInBundle:"
#define ERLocaleServiceLocaleSettingsAtCollectionPath_Action @"localeSettingsAtCollectionPath:"
#define ERLocaleServiceLoadLocaleSettingsAtResourcePath_InBundle_Action @"loadLocaleSettingsAtResourcePath:inBundle:"
#define ERLocaleServiceFontsForUsage_Size_Action @"fontsForUsage:size:"
#define ERLocaleServiceFontForUsage_Size_Action @"fontForUsage:size:"
#define ERLocaleServiceHumanReadableDescriptionForDate_UsingAbbreviation_Action @"humanReadableDescriptionForDate:usingAbbreviation:"
#define ERLocaleServiceLoadFontAtFilePath_Action @"loadFontAtFilePath:"
#define ERLocaleServiceCouldTextBeRegardedAsName_Action @"couldTextBeRegardedAsName:"
#define ERLocaleServiceNameCombinedFromFamilyName_GivenName_Action @"nameCombinedFromFamilyName:givenName:"
#define ERLocaleServiceFamilyNameFromCombinedName_Action @"familyNameFromCombinedName:"
#define ERLocaleServiceGivenNameFromCombinedName_Action @"givenNameFromCombinedName:"

#define ERLocaleServiceForNumberUsage @"com.eintsoft.gopher-wood.noahs-service.locale.usage.for-number"
#define ERLocaleServiceForStringUsage @"com.eintsoft.gopher-wood.noahs-service.locale.usage.for-string"
#define ERLocaleServiceForStringIgnoringCasesUsage @"com.eintsoft.gopher-wood.noahs-service.locale.usage.for-string.ignoring-cases"
#define ERLocaleServiceForStringOfFamilyNameUsage @"com.eintsoft.gopher-wood.noahs-service.locale.usage.for-string.family-name"
#define ERLocaleServiceForStringOfLatinTransliterationUsage @"com.eintsoft.gopher-wood.noahs-service.locale.usage,for-string.latin-transliteration"
#define ERLocaleServiceForStringOfSectionHeaderUsage @"com.eintsoft.gopher-wood.noahs-service.locale.usage.for-string.section-header"
#define ERLocaleServiceForStringOfNoLatinIntonationUsage @"com.eintsoft.gopher-wood.noahs-service.locale.usage.for-string.no-latin-intonation"

#define ERLocaleServiceStringTransformForLowercases @"com.eintsoft.gopher-wood.noahs-service.locale.string.transform.lower-cases"
#define ERLocaleServiceStringTransformForUppercases @"com.eintsoft.gopher-wood.noahs-service.locale.string.transform.upper-cases"

#define ERL(KEY) (ERLB((KEY), [NSBundle bundleForClass: [self class]]))

#define ERLC(KEY, COMMENTS) (ERL(KEY))

typedef NSComparisonResult (^ERLocaleComparator)(id object, id object2, NSSet *usages);

static inline id ERLN(id key, NSString *translationNamespace)
{
    
    if (!key)
    {
        key = [NSNull null];
    }
    
    id finalNamespace = translationNamespace;
    if (!finalNamespace)
    {
        finalNamespace = [NSNull null];
    }
    
    return ERSSC(ERLocaleServiceIdentifier,
                 ERLocaleServiceTranslationForKey_InNamespace_Action,
                 [NSArray arrayWithObjects: key, finalNamespace, nil]);
}

static inline id ERLB(id key, NSBundle *bundle)
{
    
    ERSSC(ERLocaleServiceIdentifier,
          ERLocaleServicePrepareForLocalizableStringsInBundle_Action,
          [NSArray arrayWithObject: bundle]);
    
    return ERLN(key, [bundle bundleIdentifier]);
}
