//
//  GRMainViewController.h
//  GraceRoad
//
//  Created by Mac003 on 13-12-27.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRContentView;

@interface GRMainViewController : UIViewController

@property (nonatomic) NSInteger currentIndex;

- (void)pushContentView: (UIView<GRContentView> *)contentView;

- (void)popLastContentView;

@end
