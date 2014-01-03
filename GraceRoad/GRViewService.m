//
//  GRViewService.m
//  GraceRoad
//
//  Created by Mac003 on 14-1-3.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRViewService.h"
#import "GRMainViewController.h"

@interface GRViewService ()

@property (nonatomic, assign) GRMainViewController *rootViewController;

@end

@implementation GRViewService

+ (void)load
{
    [self registerServiceClass: self];
}

+ (NSString *)serviceIdentifier
{
    return GRViewServiceID;
}

- (void)registerRootViewController: (GRMainViewController *)rootViewController
{
    _rootViewController = rootViewController;
}

- (void)pushContentView: (GRContentView *)contentView
{
    [_rootViewController pushContentView: contentView];
}

- (void)popContentView
{
    [_rootViewController popLastContentView];
}

@end
