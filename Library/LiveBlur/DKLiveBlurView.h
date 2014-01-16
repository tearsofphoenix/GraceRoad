//
//  DKLiveBlurView.h
//  LiveBlur
//
//  Created by Dmitry Klimkin on 16/6/13.
//  Copyright (c) 2013 Dmitry Klimkin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDKBlurredBackgroundDefaultLevel 0.9f
#define kDKBlurredBackgroundDefaultGlassLevel 0.2f
#define kDKBlurredBackgroundDefaultGlassColor [UIColor whiteColor]

@interface DKLiveBlurView : UIImageView

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic) float initialBlurLevel;
@property (nonatomic) float initialGlassLevel;
@property (nonatomic) BOOL isGlassEffectOn;
@property (nonatomic, strong) UIColor *glassColor;

@property (nonatomic) CGFloat blurLevel;

@end
