//
//  GRMainViewController.h
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRContentView;

@interface GRMainViewController : UIViewController

@property (nonatomic) NSInteger currentIndex;

- (void)pushContentView: (GRContentView *)contentView;

- (void)popLastContentView;

@end
