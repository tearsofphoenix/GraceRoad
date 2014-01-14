//
//  GRContentView.h
//  GraceRoad
//
//  Created by Lei on 13-12-28.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRContentView;

@protocol GRContentViewDelegate <NSObject>

- (void)needUpdateContentView: (id<GRContentView>)contentView;

@end

@protocol GRContentView <NSObject>

- (NSString *)title;

- (id<GRContentViewDelegate>)delegate;

- (void)willSwitchIn;

- (void)didSwitchOut;

@optional

- (UIButton *)rightNavigationButton;

@end

@interface GRContentView : UIView<GRContentView>

@property (nonatomic, assign) id<GRContentViewDelegate> delegate;

@property (nonatomic, retain) NSString *title;

@property (nonatomic) BOOL hideTabbar;

@end