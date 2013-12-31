//
//  ERFileInput.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/12/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ERFileInput : NSObject

@property (nonatomic, strong) NSURL *URL;

- (id)initWithURL: (NSURL *)url;

@end
