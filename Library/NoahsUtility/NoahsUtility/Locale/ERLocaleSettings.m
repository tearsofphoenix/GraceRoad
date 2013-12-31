//
//  ERLocaleSettings.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/6/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERLocaleSettings.h"

#import "ERLocale.h"

@implementation ERLocaleSettings

- (id)initWithCollectionPath: (NSString *)collectionPath
{
    
    self = [super init];
    if (self)
    {
        _collectionPath = [collectionPath copy];
    }
    
    return self;
}

- (void)dealloc
{
    
    [_collectionPath release];
    
    [super dealloc];
}

- (id)objectForKey: (id)key
{
    return [self objectOrNilAtCollectionPath: key];
}

- (id)objectOrNilAtCollectionPath: (NSString *)collectionPath
{
    
    if ([collectionPath length] > 0)
    {
        
        NSString *finalCollectionPath = collectionPath;
        if (_collectionPath)
        {
            finalCollectionPath = [_collectionPath stringByAppendingPathComponent: collectionPath];
        }
        
        NSArray *locales = ERSSC(ERLocaleServiceIdentifier, ERLocaleServicePreferredLocalesAction, nil);
        
        for (ERLocale *locale in locales)
        {
            
            id object = [locale objectAtThemeSettingsCollectionPath: finalCollectionPath];
            if (object)
            {
                return object;
            }
            
        }
        
        id object = [[ERLocale sharedLocale] objectAtThemeSettingsCollectionPath: finalCollectionPath];
        if (object)
        {
            return object;
        }
        
        for (ERLocale *locale in locales)
        {
            
            id object = [locale objectAtNoThemeSettingsCollectionPath: finalCollectionPath];
            if (object)
            {
                return object;
            }
            
        }
        
        return [[ERLocale sharedLocale] objectAtNoThemeSettingsCollectionPath: finalCollectionPath];
        
    }
    else
    {
        return self;
    }
    
}

@end
