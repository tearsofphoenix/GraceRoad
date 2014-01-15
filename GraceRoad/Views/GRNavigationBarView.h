//
//  GRNavigationBarView.h
//  GraceRoad
//
//  Created by Lei on 13-12-28.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRContentView.h"

@interface GRNavigationBarView : UIView<GRContentViewDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIButton *rightNavigationButton;

- (UIButton *)leftNavigationButton;

@end
