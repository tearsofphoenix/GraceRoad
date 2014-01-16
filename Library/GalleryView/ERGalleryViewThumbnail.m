//
//  ERGalleryViewThumbnail.m
//  NoahsScratch
//
//  Created by Minun Dragonation on 6/30/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERGalleryViewThumbnail.h"

#import <objc/runtime.h>

#import <NoahsUtility/NoahsUtility.h>

#import "ERGalleryView.h"

//#import "ERAlertView.h"

#import "UIView+FrameBeforeTransform.h"

char ERGalleryViewThumbnailGalleryViewKey;

@implementation ERGalleryViewThumbnail

@synthesize editing = _editing;

@synthesize selected = _selected;

@synthesize showingDeletingConfirmation = _showingDeleteConfirmation;

@synthesize contentView = _contentView;

@synthesize deleteButton = _deleteButton;

@synthesize backgroundView = _backgroundView;

@synthesize selectedBackgroundView = _selectedBackgroundView;

- (id)initWithFrame: (CGRect)frame
{
    
    self = [super initWithFrame: frame];
    if (self)
    {
        
        _contentView = [[UIView alloc] initWithFrame: [self bounds]];
        [_contentView setAutoresizingMask: (UIViewAutoresizingFlexibleHeight |
                                            UIViewAutoresizingFlexibleWidth)];
        
        [self addSubview: _contentView];
        
        [_contentView release];
        
        _deleteButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
        [_deleteButton setImage: [[NSBundle bundleForClass: [self class]] imageWithConditionalResourceName: @"GalleryViewDeleteButton.png"]
                       forState: UIControlStateNormal];
        
        [_deleteButton setAlpha: 0];
        [_deleteButton setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
        
        [self addSubview: _deleteButton];
        
        [_deleteButton release];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] init];
        
        [_deleteButton addGestureRecognizer: longPressRecognizer];
        
        [longPressRecognizer release];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                               action: @selector(deleteButtonTouchUpInsideRecognized:)];
        [_deleteButton addGestureRecognizer: tapGestureRecognizer];
        
        [tapGestureRecognizer release];
        
        _stateMask = ERGalleryViewThumbnailStateDefaultMask;
        
    }
    
    return self;
}

- (void)setBackgroundView: (UIView *)backgroundView
{
    
    [_backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
    
    [backgroundView setFrameBeforeTransform: [self bounds]];
    [backgroundView setAutoresizingMask: (UIViewAutoresizingFlexibleHeight |
                                          UIViewAutoresizingFlexibleWidth)];
    
    [self insertSubview: backgroundView
           belowSubview: _contentView];
    
    if (_selected)
    {
        [_backgroundView setAlpha: 0];
    }
    else
    {
        [_backgroundView setAlpha: 1];
    }
    
}

- (void)setSelectedBackgroundView: (UIView *)selectedBackgroundView
{
    
    [_selectedBackgroundView removeFromSuperview];
    
    _selectedBackgroundView = selectedBackgroundView;
    
    [selectedBackgroundView setFrameBeforeTransform: [self bounds]];
    [selectedBackgroundView setAutoresizingMask: (UIViewAutoresizingFlexibleHeight |
                                                  UIViewAutoresizingFlexibleWidth)];
    
    [self insertSubview: selectedBackgroundView
           belowSubview: _contentView];
    
    if (_selected)
    {
        [_selectedBackgroundView setAlpha: 1];
    }
    else
    {
        [_selectedBackgroundView setAlpha: 0];
    }
    
}

- (void)deleteButtonTouchUpInsideRecognized: (UITapGestureRecognizer *)recognizer
{
    
    ERGalleryView *galleryView = objc_getAssociatedObject(self, &ERGalleryViewThumbnailGalleryViewKey);
    
    CGRect frame = [self frame];
    
    NSIndexPath *indexPath = [galleryView indexPathForThumbnailAtPoint: CGPointMake(frame.origin.x + frame.size.width / 2, 
                                                                                    frame.origin.y + frame.size.height / 2)];
    
    if (([[galleryView dataSource] respondsToSelector: @selector(galleryView:canEditThumbnailAtIndexPath:)]) && 
        ([[galleryView dataSource] galleryView: galleryView
                   canEditThumbnailAtIndexPath: indexPath]))
    {
        
        if ([self isShowingDeletingConfirmation])
        {
            
            NSString *message = @"Are your sure to delete this thumbnail?";
            if ([[galleryView delegate] respondsToSelector: @selector(galleryView:titleForDeleteConfirmationButtonForThumbnailAtIndexPath:)])
            {
                message = [[galleryView delegate] galleryView: galleryView
      titleForDeleteConfirmationButtonForThumbnailAtIndexPath: indexPath];
            }
            
//            [ERAlertView showWithTitle: @"Deleting Confirmation"
//                               message: message
//                              callback: (^(NSInteger buttonIndex, NSArray *inputs) 
//                                         {
//                                             
//                                             switch (buttonIndex)
//                                             {
//                                                     
//                                                 case 0:
//                                                 {
//                                                     
//                                                     if ([[galleryView dataSource] respondsToSelector: @selector(galleryView:commitEditingStyle:forThumbnailAtIndexPath:)])
//                                                     {
//                                                         [[galleryView dataSource] galleryView: galleryView 
//                                                                            commitEditingStyle: ERGalleryViewThumbnailEditingStyleDelete
//                                                                       forThumbnailAtIndexPath: indexPath];
//                                                     }
//                                                     
//                                                     [galleryView beginUpdates];
//                                                     
//                                                     [galleryView deleteThumbnailsAtIndexPaths: [NSArray arrayWithObject: indexPath]
//                                                                        withThumbnailAnimation: ERGalleryViewThumbnailAnimationAutomatic];
//                                                     
//                                                     [galleryView endUpdates];
//                                                     
//                                                     break;
//                                                 }
//                                                     
//                                                 default:
//                                                 {
//                                                     break;
//                                                 }
//                                                     
//                                             }
//                                             
//                                         })
//                          buttonTitles: @"Yes", @"No", nil];
            
        }
        else
        {
            
            if ([[galleryView dataSource] respondsToSelector: @selector(galleryView:commitEditingStyle:forThumbnailAtIndexPath:)])
            {
                [[galleryView dataSource] galleryView: galleryView 
                                   commitEditingStyle: ERGalleryViewThumbnailEditingStyleDelete
                              forThumbnailAtIndexPath: indexPath];
            }
            
            [galleryView beginUpdates];
            
            [galleryView deleteThumbnailsAtIndexPaths: [NSArray arrayWithObject: indexPath]
                               withThumbnailAnimation: ERGalleryViewThumbnailAnimationAutomatic];
            
            [galleryView endUpdates];
            
        }
        
    }
    
}

- (void)setEditing: (BOOL)editing
{
    [self setEditing: editing 
            animated: NO];
}

- (void)setEditing: (BOOL)editing 
          animated: (BOOL)animated
{
    
    _editing = editing;
    
    if (_editing)
    {
        
        if (_stateMask & ERGalleryViewThumbnailStateShowingDeleteButtonMask)
        {
            
            if (animated)
            {
                [UIView animateWithDuration: 0.3
                                 animations: (^(void)
                                              {
                                                  [_deleteButton setAlpha: 1];
                                                  [_deleteButton setTransform: CGAffineTransformIdentity];
                                              })];
            }
            else
            {
                [_deleteButton setAlpha: 1];
                [_deleteButton setTransform: CGAffineTransformIdentity];
            }
            
        }
        else
        {
            
            if (animated)
            {
                [UIView animateWithDuration: 0.3
                                 animations: (^(void)
                                              {
                                                  [_deleteButton setAlpha: 0];
                                                  [_deleteButton setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                              })];
            }
            else
            {
                [_deleteButton setAlpha: 0];
                [_deleteButton setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
            }
        }
        
    }
    else
    {
        
        if (animated)
        {
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              [_deleteButton setAlpha: 0];
                                              [_deleteButton setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                          })];
        }
        else
        {
            [_deleteButton setAlpha: 0];
            [_deleteButton setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
        }
        
    }
    
}

- (void)setSelected: (BOOL)selected
{
    [self setSelected: selected
             animated: NO];
}

- (void)setSelected: (BOOL)selected 
           animated: (BOOL)animated
{
    
    if (!_touchingSelection)
    {
        _selected = selected;
    }
    
    if (animated)
    {
        
        if (selected || _selected)
        {
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              [_backgroundView setAlpha: 0];
                                              [_selectedBackgroundView setAlpha: 1];
                                              
                                          })];
        }
        else
        {
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              [_backgroundView setAlpha: 1];
                                              [_selectedBackgroundView setAlpha: 0];
                                              
                                          })];
        }
        
    }
    else
    {
        
        if (selected || _selected)
        {
            [_backgroundView setAlpha: 0];
            [_selectedBackgroundView setAlpha: 1];
        }
        else
        {
            [_backgroundView setAlpha: 1];
            [_selectedBackgroundView setAlpha: 0];
        }
        
    }
    
}

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
    
    [super touchesBegan: touches withEvent: event];
    
    if ([touches count] == 1)
    {
        
        _touchingSelection = YES;
        
        [self setSelected: YES animated: NO];
        
        _touchingSelection = NO;
        
    }
    
}

- (void)touchesCancelled: (NSSet *)touches withEvent: (UIEvent *)event
{
    
    [super touchesCancelled: touches withEvent: event];
    
    if ([touches count] == 1)
    {
        
        _touchingSelection = YES;
        
        [self setSelected: NO animated: NO];
        
        _touchingSelection = NO;
        
    }
    
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
{
    
    [super touchesEnded: touches withEvent: event];
    
    if ([touches count] == 1)
    {
        
        _touchingSelection = YES;
        
        [self setSelected: NO animated: NO];
        
        _touchingSelection = NO;
        
    }
    
}

- (void)touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    
    [super touchesMoved: touches withEvent: event];
    
    _touchingSelection = YES;
    
    [self setSelected: NO animated: NO];
    
    _touchingSelection = NO;
    
}

- (void)willTransitionToState: (ERGalleryViewThumbnailStateMask)stateMask
{
    ;
}

- (void)didTransitionToState: (ERGalleryViewThumbnailStateMask)stateMask
{
    
    _stateMask = stateMask;
    
    if (_editing)
    {
        if (stateMask & ERGalleryViewThumbnailStateShowingDeleteButtonMask)
        {
            [_deleteButton setAlpha: 1];
        }
        else
        {
            [_deleteButton setAlpha: 0];
        }
    }
    
}

@end
