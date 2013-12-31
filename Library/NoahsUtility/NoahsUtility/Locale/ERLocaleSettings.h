//
//  NSLocaleSettings.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/6/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ERLocale;

@interface ERLocaleSettings: NSObject
{
    NSString *_collectionPath;
}

- (id)initWithCollectionPath: (NSString *)collectionPath;

- (id)objectOrNilAtCollectionPath: (NSString *)collectionPath;

@end
