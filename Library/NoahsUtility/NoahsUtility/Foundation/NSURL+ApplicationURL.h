//
//  NSURL+ApplicationURL.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 7/23/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ApplicationURL)

+ (NSURL *)applicationURLFor: (NSURL *)URL;

+ (NSURL *)URLForApplicationURL: (NSURL *)URL;

@end
