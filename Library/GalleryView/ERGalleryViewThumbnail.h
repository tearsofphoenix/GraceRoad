//
//  ERGalleryViewThumbnail.h
//  NoahsScratch
//
//  Created by Minun Dragonation on 6/30/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

enum 
{
    ERGalleryViewThumbnailStateDefaultMask                     = 0,
    ERGalleryViewThumbnailStateShowingDeleteButtonMask         = 1 << 0
};

typedef NSInteger ERGalleryViewThumbnailStateMask;

@interface ERGalleryViewThumbnail: UIView
{
    
    UIButton *_deleteButton;
    
    ERGalleryViewThumbnailStateMask _stateMask;
    
    BOOL _touchingSelection;
    
    BOOL _selected;
    
    BOOL _showingDeleteConfirmation;
    
    UIView *_contentView;
    
    UIView *_backgroundView;
    
    UIView *_selectedBackgroundView;
    
}

@property (nonatomic, getter = isSelected) BOOL selected;

- (void)setSelected: (BOOL)selected 
           animated: (BOOL)animated;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;

@property (nonatomic, strong, readonly) UIButton *deleteButton;

- (void)deleteButtonTouchUpInsideRecognized: (UITapGestureRecognizer *)recognizer;

@property (nonatomic, getter = isEditing) BOOL editing;

- (void)setEditing: (BOOL)editing
          animated: (BOOL)animated;

@property (nonatomic, getter = isShowingDeletingConfirmation) BOOL showingDeletingConfirmation;

- (void)willTransitionToState: (ERGalleryViewThumbnailStateMask)stateMask;

- (void)didTransitionToState: (ERGalleryViewThumbnailStateMask)stateMask;

@end
