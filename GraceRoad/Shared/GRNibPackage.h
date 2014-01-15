//
//  GRPackage.h
//  GraceRoad
//
//  Created by Mac003 on 14-1-15.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRPackage <NSObject>

- (id)initWithPath: (NSString *)bundlePath;

- (UIView *)view;

- (NSDictionary *)savedContext;

- (void)updateWithRecord: (NSDictionary *)savedRecord;

@end

@interface GRNibPackage : NSObject<GRPackage>

@end
