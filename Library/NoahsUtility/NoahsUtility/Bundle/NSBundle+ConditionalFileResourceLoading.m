//
//  NSBundle+ConditionalFileResourceLoading.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/7/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <NoahsUtility/NoahsUtility.h>

#import <NoahsService/NoahsService.h>

#import <objc/runtime.h>


static inline id ERBlock(id block)
{
    
    if (block)
    {
        
        id copiedBlock = Block_copy(block);
        
        return [copiedBlock autorelease];
        
    }
    else
    {
        return nil;
    }
    
}

#define ERUtilityCacheDomain @"com.eintsoft.gopher-wood.noahs-utility.cache.domain"

#define ERUtilityBundleResourcePathCacheHandle @"com.eintsoft.gopher-wood.noahs-utility.bundle.resource-path.cache.handle"
#define ERUtilityBundleImageCacheHandle @"com.eintsoft.gopher-wood.noahs-utility.bundle.image.cache.handle"
#define ERUtilityBundleFilePathsCacheHandle @"com.eintsoft.gopher-wood.noahs-utility.bundle.file-paths.cache.handle"

#define ERUtilityBundleResourcePathCacheBundlePathKey @"path"
#define ERUtilityBundleResourcePathCacheLocaleKey @"locale"
#define ERUtilityBundleResourcePathCacheResourceNameKey @"name"

static char ERBundleResourcePathsKey;

static char ERBundleResourcePathKey;

static char ERBundlePathKey;

NSString *ERBundleResourcePath(NSBundle *bundle)
{
    
    NSString *resourcePath = objc_getAssociatedObject(bundle, &ERBundleResourcePathKey);
    if (!resourcePath)
    {
        
        resourcePath = [bundle resourcePath];
        
        objc_setAssociatedObject(bundle, &ERBundleResourcePathKey, resourcePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return resourcePath;
}

NSString *ERBundlePath(NSBundle *bundle)
{
    
    NSString *bundlePath = objc_getAssociatedObject(bundle, &ERBundlePathKey);
    if (!bundlePath)
    {
        
        bundlePath = [bundle bundlePath];
        
        objc_setAssociatedObject(bundle, &ERBundlePathKey, bundlePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return bundlePath;
}

@implementation NSBundle (ConditionalFileResourceLoading)

- (BOOL)resourceFileExists: (NSString *)filePath
{
    
    NSSet *filePaths = objc_getAssociatedObject(self, &ERBundleResourcePathsKey);
    if (!filePaths)
    {
        
        NSMutableSet *set = [NSMutableSet set];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        for (NSString *filePath in [fileManager enumeratorAtPath: ERBundleResourcePath(self)])
        {
            [set addObject: filePath];
        }
        
        filePaths = [NSSet setWithSet: set];
        
        objc_setAssociatedObject(self, &ERBundleResourcePathsKey, filePaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return [filePaths containsObject: filePath];
}

- (NSString *)filePathForConditionalResourceName: (NSString *)name
{
    
    NSString *themeName = ERSSC(ERLocaleServiceIdentifier, ERLocaleServiceCurrentThemeNameAction, nil);
    
    NSString *filePath = nil;
    if (themeName)
    {
        
        NSString *resourceName = [[name stringByDeletingPathExtension] stringByAppendingFormat: @"[%@]", themeName];
        
        NSString *resourceExtension = [name pathExtension];

        filePath = [self filePathForConditionalNoThemeResourceName: [resourceName stringByAppendingPathExtension: resourceExtension]];
        
    }
    
    if (!filePath)
    {
        filePath = [self filePathForConditionalNoThemeResourceName: name];
    }
    
    return filePath;
}

- (NSString *)filePathForConditionalNoThemeResourceName: (NSString *)name
{
    
    NSString *path = nil;
    
    NSArray *preferredLocales = ERSSC(ERLocaleServiceIdentifier,
                                      ERLocaleServicePreferredLocalesAction,
                                      nil);
    for (ERLocale *locale in preferredLocales)
    {
        
        path = [self filePathForConditionalNoThemeResourceName: name
                                                        locale: locale];
        if (path)
        {
            return path;
        }
        
    }
    
    return [self filePathForConditionalNoThemeResourceName: name
                                                    locale: nil];
}

- (NSURL *)URLForConditionalResourceName: (NSString *)name
{
    
    NSString *path = [self filePathForConditionalResourceName: name];
    if (path)
    {
        return [NSURL fileURLWithPath: path];
    }
    else
    {
        return nil;
    }
    
}

- (UIImage *)imageWithConditionalResourceName: (NSString *)name
{
    
    NSString *themeName = ERSSC(ERLocaleServiceIdentifier, ERLocaleServiceCurrentThemeNameAction, nil);
    
    UIImage *image = nil;
    if (themeName)
    {
        
        NSString *resourceName = [[name stringByDeletingPathExtension] stringByAppendingFormat: @"[%@]", themeName];
        
        NSString *resourceExtension = [name pathExtension];
        
        image = [self imageWithConditionalNoThemeResourceName: [resourceName stringByAppendingPathExtension: resourceExtension]];
        
    }
    
    if (!image)
    {
        image = [self imageWithConditionalNoThemeResourceName: name];
    }
    
    return image;
}

- (UIImage *)imageWithConditionalNoThemeResourceName: (NSString *)name
{
    
    UIImage *image = nil;
    
    NSArray *preferredLocales = ERSSC(ERLocaleServiceIdentifier,
                                      ERLocaleServicePreferredLocalesAction,
                                      nil);
    for (ERLocale *locale in preferredLocales)
    {
        
        image = [self imageWithConditionalNoThemeResourceName: name
                                                       locale: locale];
        if (image)
        {
            return image;
        }
        
    }
    
    return [self imageWithConditionalNoThemeResourceName: name
                                                  locale: nil];
    
}

- (NSString *)filePathForConditionalResourceName: (NSString *)name
                                          locale: (ERLocale *)locale
{
    
    NSString *themeName = ERSSC(ERLocaleServiceIdentifier, ERLocaleServiceCurrentThemeNameAction, nil);
    
    NSString *filePath = nil;
    if (themeName)
    {
        
        NSString *resourceName = [[name stringByDeletingPathExtension] stringByAppendingFormat: @"[%@]", themeName];
        
        NSString *resourceExtension = [name pathExtension];
        
        filePath = [self filePathForConditionalNoThemeResourceName: [resourceName stringByAppendingPathExtension: resourceExtension]
                                                            locale: locale];
        
    }
    
    if (!filePath)
    {
        filePath = [self filePathForConditionalNoThemeResourceName: name
                                                            locale: locale];
    }
    
    return filePath;
}

- (NSString *)filePathForConditionalThemeResourceName: (NSString *)name
                                               locale: (ERLocale *)locale
{
    
    NSString *themeName = ERSSC(ERLocaleServiceIdentifier, ERLocaleServiceCurrentThemeNameAction, nil);
    
    if (themeName)
    {
        
        NSString *resourceName = [[name stringByDeletingPathExtension] stringByAppendingFormat: @"[%@]", themeName];
        
        NSString *resourceExtension = [name pathExtension];
        
        return [self filePathForConditionalNoThemeResourceName: [resourceName stringByAppendingPathExtension: resourceExtension]
                                                        locale: locale];
        
    }
    else
    {
        return nil;
    }
    
}

static NSArray *ERUtilityBundleFileSuffixOrder = nil;

- (NSString *)filePathForConditionalNoThemeResourceName: (NSString *)name
                                                 locale: (ERLocale *)locale
{
    
    NSString *filePath = nil;
    
    filePath = ERSSC(ERCacheServiceIdentifier,
                     ERCacheServiceObjectForKey_Handle_InDomain_ExpirationDate_Scope_Recreation_Serialisation_Action,
                     [NSArray arrayWithCount: 7
                               objectsOrNils:
                      [NSString descriptionForOrderedObjects:
                       ERBundlePath(self) ?: [NSNull null],
                       name ?: [NSNull null],
                       [locale localeIdentifier] ?: [NSNull null],
                       nil]
                      /*
                      [NSString descriptionForKeysAndObjectsOrNils:
                       ERUtilityBundleResourcePathCacheBundlePathKey, ERBundlePath(self),
                       ERUtilityBundleResourcePathCacheResourceNameKey, name,
                       ERUtilityBundleResourcePathCacheLocaleKey, [locale localeIdentifier],
                       nil]*/,
                      ERUtilityBundleResourcePathCacheHandle,
                      ERUtilityCacheDomain,
                      nil,
                      ERCacheServiceScopeTemporary,
                      ERBlock(^(id oldObject, NSData *serialisedData)
                              {
                                  
                                  NSString *resourcePath = @"";
                                  
                                  if (locale && [locale localeIdentifier])
                                  {
                                      resourcePath = [resourcePath stringByAppendingPathComponent: [[locale localeIdentifier] stringByAppendingPathExtension: @"lproj"]];
                                  }
                                  
                                  if (!ERUtilityBundleFileSuffixOrder)
                                  {
                                      
                                      NSMutableArray *order = [NSMutableArray array];
                                      
                                      NSString *model = nil;
                                      NSString *model2 = nil;
                                      
                                      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                      {
                                          model = @"~ipad";
                                      }
                                      else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                                      {
                                          
                                          model = @"~iphone";
                                          
                                          if ([UIScreen mainScreen].bounds.size.height != 480)
                                          {
                                              model2 = @"~iphone5";
                                          }
                                          
                                      }
                                      
                                      if ([[UIScreen mainScreen] scale] == 2)
                                      {

                                          if (model2)
                                          {
                                              [order addObject: [@"@2x" stringByAppendingString: model2]];
                                          }

                                          if (model2)
                                          {
                                              [order addObject: model2];
                                          }

                                          if (model)
                                          {
                                              [order addObject: [@"@2x" stringByAppendingString: model]];
                                          }

                                          if (model)
                                          {
                                              [order addObject: model];
                                          }

                                          [order addObject: @"@2x"];

                                      }
                                      else
                                      {

                                          if (model2)
                                          {
                                              [order addObject: model2];
                                          }

                                          if (model2)
                                          {
                                              [order addObject: [@"@2x" stringByAppendingString: model2]];
                                          }

                                          if (model)
                                          {
                                              [order addObject: model];
                                          }

                                          if (model)
                                          {
                                              [order addObject: [@"@2x" stringByAppendingString: model]];
                                          }

                                          [order addObject: @""];
                                          
                                          [order addObject: @"@2x"];

                                      }
                                      
                                      ERUtilityBundleFileSuffixOrder = [[NSArray alloc] initWithArray: order];
                                  }
                                  
                                  NSString *resourceName = [name stringByDeletingPathExtension];
                                  NSString *resourceExtension = [name pathExtension];
                                  
                                  NSString *filePath = nil;
                                  for (NSString *suffix in ERUtilityBundleFileSuffixOrder)
                                  {
                                      
                                      filePath = [[resourcePath stringByAppendingPathComponent: [resourceName stringByAppendingString: suffix]] stringByAppendingPathExtension: resourceExtension];
                                      
                                      if ([self resourceFileExists: filePath])
                                      {
                                          return [ERBundleResourcePath(self) stringByAppendingPathComponent: filePath];
                                      }
                                      
                                  }
                                  
                                  filePath = [resourcePath stringByAppendingPathComponent: [resourceName stringByAppendingPathExtension: resourceExtension]];
                                  if ([self resourceFileExists: filePath])
                                  {
                                      return [ERBundleResourcePath(self) stringByAppendingPathComponent: filePath];
                                  }
                                  else
                                  {
                                      return (NSString *)nil;
                                  }
                                  
                              }),
                      nil
                      ]);
    
    return filePath;
    
}

- (NSURL *)URLForConditionalResourceName: (NSString *)name
                                  locale: (ERLocale *)locale
{
    
    NSString *path = [self filePathForConditionalResourceName: name
                                                       locale: locale];
    if (path)
    {
        return [NSURL fileURLWithPath: path];
    }
    else
    {
        return nil;
    }
    
}

- (NSURL *)URLForConditionalThemeResourceName: (NSString *)name
                                       locale: (ERLocale *)locale
{
    
    NSString *path = [self filePathForConditionalThemeResourceName: name
                                                            locale: locale];
    if (path)
    {
        return [NSURL fileURLWithPath: path];
    }
    else
    {
        return nil;
    }
    
}

- (NSURL *)URLForConditionalNoThemeResourceName: (NSString *)name
                                         locale: (ERLocale *)locale
{
    
    NSString *path = [self filePathForConditionalNoThemeResourceName: name
                                                              locale: locale];
    if (path)
    {
        return [NSURL fileURLWithPath: path];
    }
    else
    {
        return nil;
    }
    
}

- (UIImage *)imageWithConditionalNoThemeResourceName: (NSString *)name
                                              locale: (ERLocale *)locale
{
    
    UIImage *image = nil;
    
    image = ERSSC(ERCacheServiceIdentifier,
                  ERCacheServiceObjectForKey_Handle_InDomain_ExpirationDate_Scope_Recreation_Serialisation_Action,
                  [NSArray arrayWithCount: 7
                            objectsOrNils:
                   [NSString descriptionForOrderedObjects:
                    ERBundlePath(self) ?: [NSNull null],
                    name ?: [NSNull null],
                    [locale localeIdentifier] ?: [NSNull null],
                    nil]
                   /*
                   [NSString descriptionForKeysAndObjectsOrNils:
                    ERUtilityBundleResourcePathCacheBundlePathKey, ERBundlePath(self),
                    ERUtilityBundleResourcePathCacheLocaleKey, [locale localeIdentifier],
                    ERUtilityBundleResourcePathCacheResourceNameKey, name,
                    nil]*/,
                   ERUtilityBundleImageCacheHandle,
                   ERUtilityCacheDomain,
                   nil,
                   ERCacheServiceScopeTemporary,
                   ERBlock(^(id oldObject, NSData *serialisedData)
                           {
                               
                               NSString *filePath = [self filePathForConditionalNoThemeResourceName: name
                                                                                             locale: locale];
                               if (filePath)
                               {
                                   
                                   UIImage *image = nil;
                                   
                                   NSData *data = [NSData dataWithContentsOfFile: filePath];
                                   
                                   UIImage *notScaledImage = [UIImage imageWithData: data];
                                   
                                   if ([[filePath lastPathComponent] rangeOfString: @"@2x"].location != NSNotFound)
                                   {
                                       image = [UIImage imageWithCGImage: [notScaledImage CGImage]
                                                                   scale: 2.0
                                                             orientation: [notScaledImage imageOrientation]];
                                   }
                                   else
                                   {
                                       image = notScaledImage;
                                   }
                                   
                                   return image;
                                   
                               }
                               else
                               {
                                   return (UIImage *)nil;
                               }
                               
                           }),
                   nil]);
    
    return image;
    
}

@end
