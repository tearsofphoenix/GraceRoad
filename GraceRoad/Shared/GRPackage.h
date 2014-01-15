//
//  GRPackage.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-15.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRPackage : NSObject

- (id)initWithPath: (NSString *)bundlePath;

- (UIView *)view;

- (NSDictionary *)savedContext;

@end
