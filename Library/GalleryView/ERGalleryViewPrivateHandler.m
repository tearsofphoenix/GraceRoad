//
//  ERGalleryViewPrivateHandler.m
//  NoahsScratch
//
//  Created by Minun Dragonation on 7/2/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERGalleryViewPrivateHandler.h"

#import <objc/runtime.h>

#import <NoahsUtility/NoahsUtility.h>

#import "ERGalleryViewDelegate.h"

#import "ERGalleryViewThumbnail.h"

#import "NSIndexPath+ERGalleryView.h"

#import "UIView+FrameAdjustment.h"
#import "UIView+CenterAdjustment.h"

#define ERGalleryViewScrollingStep 7

#define ERGalleryViewContentSizeStep 5

#define ERGalleryViewAnimationDuration 0.3

static char ERGalleryViewThumbnailInitialCenterKey;

static char ERGalleryViewThumbnailLastFixedKey;

@implementation ERGalleryViewPrivateHandler

@synthesize allowsSelection = _allowsSelection;

@synthesize allowsReordering = _allowsReordering;

@synthesize allowsMultipleSelection = _allowsMultipleSelection;

@synthesize allowsSelectionDuringEditing = _allowsSelectionDuringEditing;

@synthesize allowsReorderingDuringEditing = _allowsReorderingDuringEditing;

@synthesize allowsMultipleSelectionDuringEditing = _allowsMultipleSelectionDuringEditing;

- (id)  initWithGalleryView: (ERGalleryView *)galleryView
                 thumbnails: (NSMutableDictionary *)thumbnails
                  selection: (NSMutableArray *)selection
       panGestureRecognizer: (UIPanGestureRecognizer *)panGestureRecognizer
 longPressGestureRecognizer: (UILongPressGestureRecognizer *)longPressGestureRecognizer
       tapGestureRecognizer: (UITapGestureRecognizer *)tapGestureRecognizer
                   arranger: (ERGalleryViewArranger)arranger
           draggingPosition: (CGPoint *)draggingPosition
         draggingIndexPaths: (NSMutableArray *)draggingIndexPaths
    draggingTargetIndexPath: (NSIndexPath **)draggingTargetIndexPath
{
    
    self = [super init];
    if (self)
    {
        
        _needRearrangement = YES;
        
        _galleryView = galleryView;
        
        _separatorView = [[UIView alloc] init];
        
        [_galleryView addSubview: _separatorView];
        
        [_separatorView release];
        
        _thumbnails = thumbnails;
        
        _selection = selection;
        
        _panGestureRecognizer = panGestureRecognizer;
        
        _longPressGestureRecognizer = longPressGestureRecognizer;
        
        _tapGestureRecognizer = tapGestureRecognizer;
        
        _arranger = Block_copy(arranger);
        
        _draggingPosition = draggingPosition;
        
        _draggingIndexPaths = draggingIndexPaths;
        
        _draggingTargetIndexPath = draggingTargetIndexPath;
        
        _thumbnailLayouts = [[NSMutableDictionary alloc] init];
        
        _preservedThumbnailIndexPaths = [[NSMutableDictionary alloc] init];
        
        _selfManagedIndexPaths = [[NSMutableArray alloc] init];
        
        _animationIndexPaths = [[NSMutableArray alloc] init];
        
        _allowsSelection = YES;
        
        _allowsReordering = NO;
        
        _allowsMultipleSelection = NO;
        
        _allowsSelectionDuringEditing = NO;
        
        _allowsReorderingDuringEditing = YES;
        
        _allowsMultipleSelectionDuringEditing = NO;
        
    }
    
    return self;
}

- (void)dealloc
{
    
    [_targetContentSizeFinishTime release];
    
    [_animationIndexPaths release];
    
    [_selfManagedIndexPaths release];
    
    [_preservedThumbnailIndexPaths release];
    
    [_thumbnailLayouts release];
    
    Block_release(_arranger);
    
    [super dealloc];
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
    
    [self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                         draggingPlaceable: NO];
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewDidScroll:)])
    {
        [delegate scrollViewDidScroll: scrollView];
    }
    
}

- (void)scrollViewDidZoom: (UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewDidZoom:)])
    {
        [delegate scrollViewDidZoom: scrollView];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewWillBeginDragging:)])
    {
        [delegate scrollViewWillBeginDragging: scrollView];
    }
    
}

- (void)scrollViewWillEndDragging: (UIScrollView *)scrollView
                     withVelocity: (CGPoint)velocity
              targetContentOffset: (inout CGPoint *)targetContentOffset
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [delegate scrollViewWillEndDragging: scrollView
                               withVelocity: velocity
                        targetContentOffset: targetContentOffset];
    }
    
}

- (void)scrollViewDidEndDragging: (UIScrollView *)scrollView
                  willDecelerate: (BOOL)decelerate
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [delegate scrollViewDidEndDragging: scrollView willDecelerate: decelerate];
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewWillBeginDecelerating:)])
    {
        [delegate scrollViewWillBeginDecelerating: scrollView];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewDidEndDecelerating:)])
    {
        [delegate scrollViewDidEndDecelerating: scrollView];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewDidEndScrollingAnimation:)])
    {
        [delegate scrollViewDidEndScrollingAnimation: scrollView];
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(viewForZoomingInScrollView:)])
    {
        return [delegate viewForZoomingInScrollView: scrollView];
    }
    else
    {
        return nil;
    }
    
}

- (void)scrollViewWillBeginZooming: (UIScrollView *)scrollView
                          withView: (UIView *)view
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewWillBeginZooming:withView:)])
    {
        [delegate scrollViewWillBeginZooming: scrollView withView: view];
    }
    
}

- (void)scrollViewDidEndZooming: (UIScrollView *)scrollView
                       withView: (UIView *)view
                        atScale: (float)scale
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewDidEndZooming:withView:atScale:)])
    {
        [delegate scrollViewDidEndZooming: scrollView
                                 withView: view
                                  atScale: scale];
    }
    
}

- (BOOL)scrollViewShouldScrollToTop: (UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewShouldScrollToTop:)])
    {
        return [delegate scrollViewShouldScrollToTop: scrollView];
    }
    else
    {
        return NO;
    }
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    
    id<ERGalleryViewDelegate> delegate = [_galleryView delegate];
    if ([delegate respondsToSelector: @selector(scrollViewDidScrollToTop:)])
    {
        [delegate scrollViewDidScrollToTop: scrollView];
    }
    
}

- (void)requireFullRearrangement
{
    _needRearrangement = YES;
}

- (NSIndexPath *)indexPathForThumbnailAtPoint: (CGPoint)location
{
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        if ([indexPath length] == 2)
        {
            
            NSInteger section = [indexPath section];
            NSInteger thumbnail = [indexPath thumbnail];
            if (thumbnail != [_galleryView numberOfThumbnailsInSectionAtIndex: section])
            {
                
                CGRect rect = [[_thumbnailLayouts objectForKey: indexPath] CGRectValue];
                if (CGRectContainsPoint(rect, location))
                {
                    return indexPath;
                }
                
            }
            
        }
        
    }
    
    return nil;
    
}

- (NSArray *)indexPathsForThumbnailInRect: (CGRect)rect
{
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        if ([indexPath length] == 2)
        {
            
            NSInteger section = [indexPath section];
            NSInteger thumbnail = [indexPath thumbnail];
            if (thumbnail != [_galleryView numberOfThumbnailsInSectionAtIndex: section])
            {
                
                CGRect thumbnailRect = [[_thumbnailLayouts objectForKey: indexPath] CGRectValue];
                if (CGRectContainsRect(thumbnailRect, rect))
                {
                    [indexPaths addObject: indexPath];
                }
                
            }
            
        }
        
    }
    
    return [NSArray arrayWithArray: indexPaths];
    
}

- (CGRect)rectForSection: (NSInteger)section
{
    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        if (([indexPath length] == 2) && ([indexPath indexAtPosition: 0] == section))
        {
            
            if (rect.size.width * rect.size.height == 0)
            {
                rect = [[_thumbnailLayouts objectForKey: indexPath] CGRectValue];
            }
            else
            {
                rect = CGRectUnion(rect, [[_thumbnailLayouts objectForKey: indexPath] CGRectValue]);
            }
            
        }
        
    }
    
    CGFloat weight = [_galleryView weightForHeaderOfSection: section];
    
    switch ([_galleryView arrangementDirection])
    {
            
        case ERGalleryViewArrangementDirectionHorizontal:
        {
            
            rect = CGRectMake(rect.origin.x - weight, rect.origin.y, rect.size.width + weight, rect.size.height);
            
            break;
        }
            
        case ERGalleryViewArrangementDirectionVertical:
        {
            
            rect = CGRectMake(rect.origin.x, rect.origin.y - weight, rect.size.width, rect.size.height + weight);
            
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
    return rect;
}

- (CGRect)rectForThumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    return [[_thumbnailLayouts objectForKey: indexPath] CGRectValue];
}

- (CGRect)rectForHeaderInSection: (NSInteger)section
{
    return [[_thumbnailLayouts objectForKey: [NSIndexPath indexPathWithIndex: section]] CGRectValue];
}

- (CGRect)rectForFooterInSection: (NSInteger)section
{
    return [[_thumbnailLayouts objectForKey: [NSIndexPath indexPathForThumbnail: [_galleryView numberOfThumbnailsInSectionAtIndex: section]
                                                                      inSection: section]] CGRectValue];
}

- (void)rearrangeThumbnailsWithAnimation: (ERGalleryViewThumbnailAnimation)animation
                       draggingPlaceable: (BOOL)draggingPlaceable
{
    
    CGRect bounds = [_galleryView bounds];
    
    UIView *backgroundView = [_galleryView backgroundView];
    [backgroundView setFrame: bounds];
    
    UIView *galleryHeaderView = [_galleryView galleryHeaderView];
    CGRect newFrame;
    switch ([_galleryView arrangementDirection])
    {
            
        case ERGalleryViewArrangementDirectionHorizontal:
        {
            
            newFrame = CGRectMake(0, 0, [_galleryView galleryHeaderViewWeight], bounds.size.height);
            
            break;
        }
            
        case ERGalleryViewArrangementDirectionVertical:
        {
            
            newFrame = CGRectMake(0, 0, bounds.size.width, [_galleryView galleryHeaderViewWeight]);
            
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
    CGRect frame = [galleryHeaderView frame];
    if (!CGRectEqualToRect(frame, newFrame))
    {
        
        switch (animation)
        {
            case ERGalleryViewThumbnailAnimationNone:
            {
                
                [galleryHeaderView setFrame: newFrame];
                
                break;
            }
                
            case ERGalleryViewThumbnailAnimationFade:
            case ERGalleryViewThumbnailAnimationZoom:
            case ERGalleryViewThumbnailAnimationAutomatic:
            {
                
                [UIView animateWithDuration: 0.3
                                 animations: (^(void)
                                              {
                                                  [galleryHeaderView setFrame: newFrame];
                                              })];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    CGSize contentSize = [_galleryView contentSize];
    
    if (_needRearrangement)
    {
        
        _needRearrangement = NO;
        
        __block NSMutableArray *keysToRemove = [NSMutableArray arrayWithArray: [_thumbnails allKeys]];
        
        contentSize = _arranger(_galleryView,
                                draggingPlaceable,
                                (^(NSIndexPath *indexPath, CGRect frame, BOOL fixed)
                                 {
                                     
                                     if (![_selfManagedIndexPaths containsObject: indexPath])
                                     {
                                         
                                         NSValue *valueOldFrame = [_thumbnailLayouts objectForKey: indexPath];
                                         
                                         BOOL lastFixed = NO;
                                         if (valueOldFrame)
                                         {
                                             lastFixed = [objc_getAssociatedObject(valueOldFrame, &ERGalleryViewThumbnailLastFixedKey) boolValue];
                                         }
                                         
                                         CGRect oldFrame = [valueOldFrame CGRectValue];
                                         
                                         NSValue *valueFrame = [NSValue valueWithCGRect: frame];
                                         
                                         objc_setAssociatedObject(valueFrame,
                                                                  &ERGalleryViewThumbnailLastFixedKey,
                                                                  [NSNumber numberWithBool: fixed],
                                                                  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                                         
                                         [_thumbnailLayouts setObject: valueFrame
                                                               forKey: indexPath];
                                         
                                         if (CGRectIntersectsRect(bounds, frame))
                                         {
                                             
                                             [keysToRemove removeObject: indexPath];
                                             
                                             if ([indexPath length] == 1)
                                             {
                                                 
                                                 UIView *sectionHeaderView = [_galleryView headerViewForSection: [indexPath indexAtPosition: 0]];
                                                 if (sectionHeaderView)
                                                 {
                                                     
                                                     if (![sectionHeaderView superview])
                                                     {
                                                         
                                                         [_galleryView insertSubview: sectionHeaderView
                                                                        aboveSubview: _separatorView];
                                                         
                                                         if (valueOldFrame && (!CGRectEqualToRect(oldFrame, frame)) && (!fixed) && (!lastFixed))
                                                         {
                                                             
                                                             [sectionHeaderView setFrame: oldFrame];
                                                             
                                                             switch (animation)
                                                             {
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationNone:
                                                                 {
                                                                     
                                                                     [sectionHeaderView setFrame: frame];
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationFade:
                                                                 case ERGalleryViewThumbnailAnimationZoom:
                                                                 case ERGalleryViewThumbnailAnimationAutomatic:
                                                                 default:
                                                                 {
                                                                     
                                                                     [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                      animations: (^(void)
                                                                                                   {
                                                                                                       [sectionHeaderView setFrame: frame];
                                                                                                   })];
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                             }
                                                             
                                                         }
                                                         else
                                                         {
                                                             [sectionHeaderView setFrame: frame];
                                                         }
                                                         
                                                     }
                                                     else
                                                     {
                                                         
                                                         if ((!valueOldFrame) ||
                                                             (!CGRectEqualToRect(oldFrame, frame)))
                                                         {
                                                             
                                                             if (fixed || lastFixed)
                                                             {
                                                                 if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                 {
                                                                     [sectionHeaderView setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                       frame.origin.y + frame.size.height / 2)];
                                                                 }
                                                                 else
                                                                 {
                                                                     [sectionHeaderView setFrame: frame];
                                                                 }
                                                             }
                                                             else
                                                             {
                                                                 
                                                                 switch (animation)
                                                                 {
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationNone:
                                                                     {
                                                                         
                                                                         if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                         {
                                                                             [sectionHeaderView setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                               frame.origin.y + frame.size.height / 2)];
                                                                         }
                                                                         else
                                                                         {
                                                                             [sectionHeaderView setFrame: frame];
                                                                         }
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationFade:
                                                                     case ERGalleryViewThumbnailAnimationZoom:
                                                                     case ERGalleryViewThumbnailAnimationAutomatic:
                                                                     default:
                                                                     {
                                                                         
                                                                         [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                          animations: (^(void)
                                                                                                       {
                                                                                                           
                                                                                                           if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                                                           {
                                                                                                               [sectionHeaderView setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                                                                 frame.origin.y + frame.size.height / 2)];
                                                                                                           }
                                                                                                           else
                                                                                                           {
                                                                                                               [sectionHeaderView setFrame: frame];
                                                                                                           }
                                                                                                           
                                                                                                       })];
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                 }
                                                                 
                                                             }
                                                             
                                                         }
                                                         
                                                     }
                                                     
                                                 }
                                                 
                                             }
                                             else if ([indexPath length] == 2)
                                             {
                                                 
                                                 if ([indexPath thumbnail] == [_galleryView numberOfThumbnailsInSectionAtIndex: [indexPath indexAtPosition: 0]])
                                                 {
                                                     
                                                     UIView *sectionFooterView = [_galleryView footerViewForSection: [indexPath indexAtPosition: 0]];
                                                     if (sectionFooterView)
                                                     {
                                                         
                                                         if (![sectionFooterView superview])
                                                         {
                                                             
                                                             [_galleryView insertSubview: sectionFooterView
                                                                            aboveSubview: _separatorView];
                                                             
                                                             if (valueOldFrame && (!CGRectEqualToRect(oldFrame, frame)))
                                                             {
                                                                 
                                                                 [sectionFooterView setFrame: oldFrame];
                                                                 
                                                                 switch (animation)
                                                                 {
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationNone:
                                                                     {
                                                                         
                                                                         [sectionFooterView setFrame: frame];
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationFade:
                                                                     case ERGalleryViewThumbnailAnimationZoom:
                                                                     case ERGalleryViewThumbnailAnimationAutomatic:
                                                                     default:
                                                                     {
                                                                         
                                                                         [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                          animations: (^(void)
                                                                                                       {
                                                                                                           [sectionFooterView setFrame: frame];
                                                                                                       })];
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                 }
                                                                 
                                                             }
                                                             else
                                                             {
                                                                 [sectionFooterView setFrame: frame];
                                                             }
                                                             
                                                         }
                                                         else
                                                         {
                                                             
                                                             if ((!valueOldFrame) ||
                                                                 (!CGRectEqualToRect(oldFrame, frame)))
                                                             {
                                                                 
                                                                 switch (animation)
                                                                 {
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationNone:
                                                                     {
                                                                         
                                                                         if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                         {
                                                                             [sectionFooterView setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                               frame.origin.y + frame.size.height / 2)];
                                                                         }
                                                                         else
                                                                         {
                                                                             [sectionFooterView setFrame: frame];
                                                                         }
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationFade:
                                                                     case ERGalleryViewThumbnailAnimationZoom:
                                                                     case ERGalleryViewThumbnailAnimationAutomatic:
                                                                     default:
                                                                     {
                                                                         
                                                                         [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                          animations: (^(void)
                                                                                                       {
                                                                                                           
                                                                                                           if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                                                           {
                                                                                                               [sectionFooterView setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                                                                 frame.origin.y + frame.size.height / 2)];
                                                                                                           }
                                                                                                           else
                                                                                                           {
                                                                                                               [sectionFooterView setFrame: frame];
                                                                                                           }
                                                                                                           
                                                                                                       })];
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                 }
                                                                 
                                                             }
                                                             
                                                         }
                                                         
                                                     }
                                                     
                                                 }
                                                 else
                                                 {
                                                     
                                                     ERGalleryViewThumbnail *thumbnail = [_galleryView thumbnailAtIndexPath: indexPath];
                                                     if (thumbnail)
                                                     {
                                                         
                                                         if (![thumbnail superview])
                                                         {
                                                             
                                                             if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willDisplayThumbnail:forThumbnailAtIndexPath:)])
                                                             {
                                                                 [[_galleryView delegate] galleryView: _galleryView
                                                                                 willDisplayThumbnail: thumbnail
                                                                              forThumbnailAtIndexPath: indexPath];
                                                             }
                                                             
                                                             [thumbnail setAlpha: 1];
                                                             [thumbnail setTransform: CGAffineTransformIdentity];
                                                             
                                                             [_galleryView insertSubview: thumbnail
                                                                            belowSubview: _separatorView];
                                                             
                                                             if (valueOldFrame && (!CGRectEqualToRect(oldFrame, frame)))
                                                             {
                                                                 [thumbnail setFrame: oldFrame];
                                                             }
                                                             else
                                                             {
                                                                 [thumbnail setFrame: frame];
                                                             }
                                                             
                                                             switch (animation)
                                                             {
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationFade:
                                                                 {
                                                                     
                                                                     if ([_animationIndexPaths containsObject: indexPath])
                                                                     {
                                                                         [thumbnail setAlpha: 0];
                                                                     }
                                                                     
                                                                     [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                      animations: (^(void)
                                                                                                   {
                                                                                                       
                                                                                                       if ([_animationIndexPaths containsObject: indexPath])
                                                                                                       {
                                                                                                           [thumbnail setAlpha: 1];
                                                                                                       }
                                                                                                       
                                                                                                       [thumbnail setFrame: frame];
                                                                                                       
                                                                                                   })];
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationZoom:
                                                                 {
                                                                     
                                                                     if ([_animationIndexPaths containsObject: indexPath])
                                                                     {
                                                                         [thumbnail setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                                                     }
                                                                     
                                                                     [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                      animations: (^(void)
                                                                                                   {
                                                                                                       
                                                                                                       if ([_animationIndexPaths containsObject: indexPath])
                                                                                                       {
                                                                                                           [thumbnail setTransform: CGAffineTransformIdentity];
                                                                                                       }
                                                                                                       
                                                                                                       [thumbnail setFrame: frame];
                                                                                                       
                                                                                                   })];
                                                                     
                                                                     break;
                                                                     
                                                                 }
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationAutomatic:
                                                                 {
                                                                     
                                                                     if ([_animationIndexPaths containsObject: indexPath])
                                                                     {
                                                                         [thumbnail setAlpha: 0];
                                                                         [thumbnail setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                                                     }
                                                                     
                                                                     [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                      animations: (^(void)
                                                                                                   {
                                                                                                       
                                                                                                       if ([_animationIndexPaths containsObject: indexPath])
                                                                                                       {
                                                                                                           [thumbnail setTransform: CGAffineTransformIdentity];
                                                                                                           [thumbnail setAlpha: 1];
                                                                                                       }
                                                                                                       
                                                                                                       [thumbnail setFrame: frame];
                                                                                                       
                                                                                                   })];
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationNone:
                                                                 default:
                                                                 {
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                             }
                                                             
                                                         }
                                                         else
                                                         {
                                                             
                                                             if ((!valueOldFrame) ||
                                                                 (!CGRectEqualToRect(oldFrame, frame)))
                                                             {
                                                                 
                                                                 switch (animation)
                                                                 {
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationNone:
                                                                     {
                                                                         
                                                                         if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                         {
                                                                             [thumbnail setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                       frame.origin.y + frame.size.height / 2)];
                                                                         }
                                                                         else
                                                                         {
                                                                             [thumbnail setFrame: frame];
                                                                         }
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                     case ERGalleryViewThumbnailAnimationFade:
                                                                     case ERGalleryViewThumbnailAnimationZoom:
                                                                     case ERGalleryViewThumbnailAnimationAutomatic:
                                                                     default:
                                                                     {
                                                                         
                                                                         [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                          animations: (^(void)
                                                                                                       {
                                                                                                           
                                                                                                           if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                                                           {
                                                                                                               [thumbnail setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                                                         frame.origin.y + frame.size.height / 2)];
                                                                                                           }
                                                                                                           else
                                                                                                           {
                                                                                                               [thumbnail setFrame: frame];
                                                                                                           }
                                                                                                           
                                                                                                       })];
                                                                         
                                                                         break;
                                                                     }
                                                                         
                                                                 }
                                                                 
                                                             }
                                                             
                                                         }
                                                         
                                                     }
                                                     
                                                 }
                                                 
                                             }
                                             
                                         }
                                         else
                                         {
                                             
                                             if (valueOldFrame ||
                                                 (CGRectIntersectsRect(oldFrame, bounds)))
                                             {
                                                 
                                                 if ([indexPath length] == 1)
                                                 {
                                                     
                                                     UIView *sectionHeaderView = [_thumbnails objectForKey: indexPath];//[_galleryView headerViewForSection: [indexPath indexAtPosition: 0]];
                                                     if (sectionHeaderView && [sectionHeaderView superview] && (!fixed))
                                                     {
                                                         
                                                         switch (animation)
                                                         {
                                                                 
                                                             case ERGalleryViewThumbnailAnimationNone:
                                                             {
                                                                 break;
                                                             }
                                                                 
                                                             case ERGalleryViewThumbnailAnimationFade:
                                                             case ERGalleryViewThumbnailAnimationZoom:
                                                             case ERGalleryViewThumbnailAnimationAutomatic:
                                                             default:
                                                             {
                                                                 
                                                                 [_preservedThumbnailIndexPaths setObject: [NSNumber numberWithInteger: [[_preservedThumbnailIndexPaths objectForKey: indexPath] integerValue] + 1]
                                                                                                   forKey: indexPath];
                                                                 
                                                                 NSIndexPath *preservedIndexPath = [indexPath retain];
                                                                 
                                                                 [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                  animations: (^(void)
                                                                                               {
                                                                                                   
                                                                                                   if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                                                   {
                                                                                                       [sectionHeaderView setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                                                         frame.origin.y + frame.size.height / 2)];
                                                                                                   }
                                                                                                   else
                                                                                                   {
                                                                                                       [sectionHeaderView setFrame: frame];
                                                                                                   }
                                                                                                   
                                                                                               })
                                                                                  completion: (^(BOOL finished)
                                                                                               {
                                                                                                   
                                                                                                   [_preservedThumbnailIndexPaths setObject: [NSNumber numberWithInteger: [[_preservedThumbnailIndexPaths objectForKey: preservedIndexPath] integerValue] - 1]
                                                                                                                                     forKey: preservedIndexPath];
                                                                                                   
                                                                                                   [preservedIndexPath release];
                                                                                                   
                                                                                               })];
                                                                 
                                                                 break;
                                                             }
                                                                 
                                                         }
                                                         
                                                     }
                                                     
                                                 }
                                                 else if ([indexPath length] == 2)
                                                 {
                                                     
                                                     if ([indexPath thumbnail] == [_galleryView numberOfThumbnailsInSectionAtIndex: [indexPath indexAtPosition: 0]])
                                                     {
                                                         
                                                         UIView *sectionFooterView = [_thumbnails objectForKey: indexPath];//[_galleryView footerViewForSection: [indexPath indexAtPosition: 0]];
                                                         if (sectionFooterView && [sectionFooterView superview])
                                                         {
                                                             
                                                             switch (animation)
                                                             {
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationNone:
                                                                 {
                                                                     break;
                                                                 }
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationFade:
                                                                 case ERGalleryViewThumbnailAnimationZoom:
                                                                 case ERGalleryViewThumbnailAnimationAutomatic:
                                                                 default:
                                                                 {
                                                                     
                                                                     [_preservedThumbnailIndexPaths setObject: [NSNumber numberWithInteger: [[_preservedThumbnailIndexPaths objectForKey: indexPath] integerValue] + 1]
                                                                                                       forKey: indexPath];
                                                                     
                                                                     NSIndexPath *preservedIndexPath = [indexPath retain];
                                                                     
                                                                     [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                      animations: (^(void)
                                                                                                   {
                                                                                                       
                                                                                                       if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                                                       {
                                                                                                           [sectionFooterView setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                                                             frame.origin.y + frame.size.height / 2)];
                                                                                                       }
                                                                                                       else
                                                                                                       {
                                                                                                           [sectionFooterView setFrame: frame];
                                                                                                       }
                                                                                                       
                                                                                                   })
                                                                                      completion: (^(BOOL finished)
                                                                                                   {
                                                                                                       
                                                                                                       [_preservedThumbnailIndexPaths setObject: [NSNumber numberWithInteger: [[_preservedThumbnailIndexPaths objectForKey: preservedIndexPath] integerValue] - 1]
                                                                                                                                         forKey: preservedIndexPath];
                                                                                                       
                                                                                                       [preservedIndexPath release];
                                                                                                       
                                                                                                   })];
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                             }
                                                             
                                                         }
                                                         
                                                     }
                                                     else
                                                     {
                                                         
                                                         ERGalleryViewThumbnail *thumbnail = [_thumbnails objectForKey: indexPath];//[_galleryView thumbnailAtIndexPath: indexPath];
                                                         if (thumbnail && [thumbnail superview])
                                                         {
                                                             
                                                             switch (animation)
                                                             {
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationNone:
                                                                 {
                                                                     break;
                                                                 }
                                                                     
                                                                 case ERGalleryViewThumbnailAnimationFade:
                                                                 case ERGalleryViewThumbnailAnimationZoom:
                                                                 case ERGalleryViewThumbnailAnimationAutomatic:
                                                                 default:
                                                                 {
                                                                     
                                                                     [_preservedThumbnailIndexPaths setObject: [NSNumber numberWithInteger: [[_preservedThumbnailIndexPaths objectForKey: indexPath] integerValue] + 1]
                                                                                                       forKey: indexPath];
                                                                     
                                                                     NSIndexPath *preservedIndexPath = [indexPath retain];
                                                                     
                                                                     [UIView animateWithDuration: ERGalleryViewAnimationDuration
                                                                                      animations: (^(void)
                                                                                                   {
                                                                                                       
                                                                                                       if (CGSizeEqualToSize(oldFrame.size, frame.size))
                                                                                                       {
                                                                                                           [thumbnail setAdjustedCenter: CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                                                     frame.origin.y + frame.size.height / 2)];
                                                                                                       }
                                                                                                       else
                                                                                                       {
                                                                                                           [thumbnail setFrame: frame];
                                                                                                       }
                                                                                                       
                                                                                                   })
                                                                                      completion: (^(BOOL finished)
                                                                                                   {
                                                                                                       
                                                                                                       [_preservedThumbnailIndexPaths setObject: [NSNumber numberWithInteger: [[_preservedThumbnailIndexPaths objectForKey: preservedIndexPath] integerValue] - 1]
                                                                                                                                         forKey: preservedIndexPath];
                                                                                                       
                                                                                                       [preservedIndexPath release];
                                                                                                       
                                                                                                   })];
                                                                     
                                                                     break;
                                                                 }
                                                                     
                                                             }
                                                             
                                                         }
                                                         
                                                     }
                                                     
                                                 }
                                                 
                                             }
                                             
                                         }
                                         
                                     }
                                     
                                 }));
        
        [keysToRemove removeObjectsInArray: _draggingIndexPaths];
        
        NSMutableArray *keysToPreserve = [NSMutableArray array];
        
        for (NSIndexPath *key in keysToRemove)
        {
            
            if ([[_preservedThumbnailIndexPaths objectForKey: key] integerValue] <= 0)
            {
                [[_thumbnails objectForKey: key] removeFromSuperview];
            }
            else
            {
                [keysToPreserve addObject: key];
            }
            
        }
        
        [keysToRemove removeObjectsInArray: keysToPreserve];
        
        [_thumbnails removeObjectsForKeys: keysToRemove];
        
        _targetContentSize = contentSize;
        
        [_targetContentSizeFinishTime release];
        
        _targetContentSizeFinishTime = [[NSDate dateWithTimeIntervalSince1970: 0.3] retain];
        
        if (animation == ERGalleryViewThumbnailAnimationNone)
        {
            [_galleryView setContentSize: contentSize];
        }
        else
        {
            
            if (!_contentSizingTimer)
            {
                _contentSizingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.025
                                                                       target: self
                                                                     selector: @selector(tryToResizeForGalleryView:)
                                                                     userInfo: nil
                                                                      repeats: YES];
            }
            
        }
        
    }
    else
    {
        
        NSInteger sectionCount = [_galleryView numberOfSections];
        NSInteger sectionIndex = 0;
        while (sectionIndex < sectionCount)
        {
            
            BOOL hasFirstThumbnail = NO;
            CGRect firstThumbnailFrame = CGRectMake(0, 0, 0, 0);
            
            NSInteger thumbnailCount = [_galleryView numberOfThumbnailsInSectionAtIndex: sectionIndex];
            NSInteger thumbnailIndex = 0;
            while (thumbnailIndex < thumbnailCount)
            {
                
                NSIndexPath *key = [NSIndexPath indexPathForThumbnail: thumbnailIndex
                                                            inSection: sectionIndex];
                
                CGRect frame = [[_thumbnailLayouts objectForKey: key] CGRectValue];
                if (thumbnailIndex == 0)
                {
                    hasFirstThumbnail = YES;
                    firstThumbnailFrame = frame;
                }
                
                ERGalleryViewThumbnail *thumbnail = [_thumbnails objectForKey: key];
                
                if (CGRectIntersectsRect(frame, bounds))
                {
                    
                    if (!thumbnail)
                    {
                        thumbnail = [_galleryView thumbnailAtIndexPath: key];
                    }
                    
                    if (![thumbnail superview])
                    {
                        
                        if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willDisplayThumbnail:forThumbnailAtIndexPath:)])
                        {
                            [[_galleryView delegate] galleryView: _galleryView
                                            willDisplayThumbnail: thumbnail
                                         forThumbnailAtIndexPath: key];
                        }
                        
                        [thumbnail setAlpha: 1];
                        [thumbnail setTransform: CGAffineTransformIdentity];
                        
                        [_galleryView insertSubview: thumbnail
                                       belowSubview: _separatorView];
                        
                        [thumbnail setFrame: frame];
                        
                    }
                    
                }
                else
                {
                    
                    if (thumbnail)
                    {
                        
                        [thumbnail removeFromSuperview];
                        
                        [_thumbnails removeObjectForKey: key];
                        
                    }
                    
                }
                
                ++thumbnailIndex;
            }
            
            NSIndexPath *footerKey = [NSIndexPath indexPathForThumbnail: [_galleryView numberOfThumbnailsInSectionAtIndex: sectionIndex]
                                                              inSection: sectionIndex];
            
            CGRect footerFrame = [[_thumbnailLayouts objectForKey: footerKey] CGRectValue];
            
            UIView *footerView = [_thumbnails objectForKey: footerKey];
            if (CGRectIntersectsRect(footerFrame, bounds))
            {
                
                if (!footerView)
                {
                    footerView = [_galleryView footerViewForSection: sectionIndex];
                }
                
                if (![footerView superview])
                {
                    
                    [_galleryView insertSubview: footerView
                                   aboveSubview: _separatorView];
                    
                    [footerView setFrame: footerFrame];
                    
                }
                
            }
            else
            {
                
                if (footerView)
                {
                    
                    [footerView removeFromSuperview];
                    
                    [_thumbnails removeObjectForKey: footerKey];
                    
                }
                
            }
            
            NSIndexPath *headerKey = [NSIndexPath indexPathWithIndex: sectionIndex];
            
            CGRect headerFrame = [[_thumbnailLayouts objectForKey: headerKey] CGRectValue];
            
            CGFloat headerWeight = [_galleryView weightForHeaderOfSection: sectionIndex];
            
            BOOL fixed = NO;
            
            if (hasFirstThumbnail)
            {
                
                switch ([_galleryView arrangementDirection])
                {
                        
                    case ERGalleryViewArrangementDirectionHorizontal:
                    {
                        
                        if (([_galleryView style] == ERGalleryViewStylePlain) &&
                            (firstThumbnailFrame.origin.x - headerWeight < bounds.origin.x) &&
                            (footerFrame.origin.x > bounds.origin.x))
                        {
                            
                            headerFrame.origin.x = footerFrame.origin.x - headerWeight;
                            if (headerFrame.origin.x >  bounds.origin.x)
                            {
                                headerFrame.origin.x = bounds.origin.x;
                            }
                            
                            fixed = YES;
                            
                        }
                        else
                        {
                            headerFrame.origin.y = firstThumbnailFrame.origin.y - headerWeight;
                        }
                        
                        break;
                    }
                        
                    case ERGalleryViewArrangementDirectionVertical:
                    {
                        
                        if (([_galleryView style] == ERGalleryViewStylePlain) &&
                            (firstThumbnailFrame.origin.y - headerWeight < bounds.origin.y) &&
                            (footerFrame.origin.y > bounds.origin.y))
                        {
                            
                            headerFrame.origin.y = footerFrame.origin.y - headerWeight;
                            if (headerFrame.origin.y >  bounds.origin.y)
                            {
                                headerFrame.origin.y = bounds.origin.y;
                            }
                            
                            fixed = YES;
                            
                        }
                        else
                        {
                            headerFrame.origin.y = firstThumbnailFrame.origin.y - headerWeight;
                        }
                        
                        break;
                    }
                        
                    default:
                    {
                        break;
                    }
                        
                }
                
            }
            
            UIView *headerView = [_thumbnails objectForKey: headerKey];
            
            NSValue *valueFrame = [NSValue valueWithCGRect: headerFrame];
            
            objc_setAssociatedObject(valueFrame,
                                     &ERGalleryViewThumbnailLastFixedKey,
                                     [NSNumber numberWithBool: fixed],
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            [_thumbnailLayouts setObject: valueFrame forKey: headerKey];
            
            if (CGRectIntersectsRect(headerFrame, bounds))
            {
                
                if (!headerView)
                {
                    headerView = [_galleryView headerViewForSection: sectionIndex];
                }
                
                if (![headerView superview])
                {
                    
                    [_galleryView insertSubview: headerView
                                   aboveSubview: _separatorView];
                    
                }
                
                [headerView setFrame: headerFrame];
                
            }
            else
            {
                
                if (headerView)
                {
                    
                    [headerView removeFromSuperview];
                    
                    [_thumbnails removeObjectForKey: headerKey];
                    
                }
                
            }
            
            ++sectionIndex;
        }
        
    }
    
    UIView *galleryFooterView = [_galleryView galleryFooterView];
    switch ([_galleryView arrangementDirection])
    {
            
        case ERGalleryViewArrangementDirectionHorizontal:
        {
            
            newFrame = CGRectMake(contentSize.width - [_galleryView galleryHeaderViewWeight],
                                  0,
                                  [_galleryView galleryHeaderViewWeight],
                                  bounds.size.height);
            
            break;
        }
            
        case ERGalleryViewArrangementDirectionVertical:
        {
            
            newFrame = CGRectMake(0,
                                  contentSize.height - [_galleryView galleryHeaderViewWeight],
                                  bounds.size.width,
                                  [_galleryView galleryHeaderViewWeight]);
            
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
    frame = [galleryFooterView frame];
    if (!CGRectEqualToRect(frame, newFrame))
    {
        
        switch (animation)
        {
            case ERGalleryViewThumbnailAnimationNone:
            {
                
                [galleryFooterView setFrame: newFrame];
                
                break;
            }
                
            case ERGalleryViewThumbnailAnimationFade:
            case ERGalleryViewThumbnailAnimationZoom:
            case ERGalleryViewThumbnailAnimationAutomatic:
            {
                
                [UIView animateWithDuration: 0.3
                                 animations: (^(void)
                                              {
                                                  [galleryFooterView setFrame: newFrame];
                                              })];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
}

- (void)tryToResizeForGalleryView: (NSTimer *)timer
{
    
    /*
    CGSize contentSize = [_galleryView contentSize];
    
    if (CGSizeEqualToSize(contentSize, _targetContentSize))
    {
        
        [_contentSizingTimer invalidate];
        
        _contentSizingTimer = nil;
        
    }
    else
    {
        
        CGFloat width = contentSize.width;
        CGFloat height = contentSize.height;
        if (width < _targetContentSize.width)
        {
            
            width += ERGalleryViewContentSizeStep;
            
            if (width > _targetContentSize.width)
            {
                width = _targetContentSize.width;
            }
            
        }
        else if (width > _targetContentSize.width)
        {
            
            width -= ERGalleryViewContentSizeStep;
            
            if (width < _targetContentSize.width)
            {
                width = _targetContentSize.width;
            }
            
        }
        
        if (height < _targetContentSize.height)
        {
            
            height += ERGalleryViewContentSizeStep;
            
            if (height > _targetContentSize.height)
            {
                height = _targetContentSize.height;
            }
            
        }
        else if (height > _targetContentSize.height)
        {
            
            height -= ERGalleryViewContentSizeStep;
            
            if (height < _targetContentSize.height)
            {
                height = _targetContentSize.height;
            }
            
        }
        
        [_galleryView setContentSize: CGSizeMake(width, height)];
        
    }
    */
    
    CGSize contentSize = [_galleryView contentSize];
    
    if (CGSizeEqualToSize(contentSize, _targetContentSize))
    {
        
        [_contentSizingTimer invalidate];
        
        _contentSizingTimer = nil;
        
    }
    else
    {
        
        NSDate *now = [NSDate date];
        
        if ([_targetContentSizeFinishTime timeIntervalSince1970] < [now timeIntervalSince1970])
        {
            [_galleryView setContentSize: _targetContentSize];
        }
        else
        {
            
            NSTimeInterval difference = [now timeIntervalSince1970] - [_targetContentSizeFinishTime timeIntervalSince1970];
            if (difference > 0)
            {
                
                CGFloat width = contentSize.width;
                CGFloat height = contentSize.height;
                
                width += (_targetContentSize.width - contentSize.width) / difference / 50;
                
                height += (_targetContentSize.height - contentSize.height) / difference / 50;
                
                [_galleryView setContentSize: CGSizeMake(width, height)];
                
            }
        
        }
        
    }
    
}

- (void)tryToScrollForDraggingActivatedBy: (NSTimer *)timer
{
    
    if ([_draggingIndexPaths count])
    {
        
        switch ([_galleryView arrangementDirection])
        {
                
            case ERGalleryViewArrangementDirectionHorizontal:
            {
                
                CGSize size = [_galleryView sizeForThumbnailAtIndexPath: [_draggingIndexPaths objectAtIndex: 0]];
                
                CGRect bounds = [_galleryView bounds];
                CGSize contentSize = [_galleryView contentSize];
                CGPoint contentOffset = [_galleryView contentOffset];
                
                if (contentSize.width > bounds.size.width)
                {
                    
                    if ((_draggingPosition->x - contentOffset.x < size.width / 2) &&
                        ([_galleryView contentOffset].x > 0))
                    {
                        
                        CGFloat targetOffset = contentOffset.x - ERGalleryViewScrollingStep;
                        
                        _draggingPosition->x -= ERGalleryViewScrollingStep;
                        
                        if (targetOffset < 0)
                        {
                            
                            _draggingPosition->x += -targetOffset;
                            
                            targetOffset = 0;
                            
                        }
                        
                        [_galleryView setContentOffset: CGPointMake(targetOffset, 0)];
                        
                    }
                    
                    if ((_draggingPosition->x - contentOffset.x - size.width / 2 >= bounds.size.width - size.width / 2) &&
                        ([_galleryView contentOffset].x < [_galleryView contentSize].width - bounds.size.width))
                    {
                        
                        CGFloat targetOffset = contentOffset.x + ERGalleryViewScrollingStep;
                        
                        _draggingPosition->x += ERGalleryViewScrollingStep;
                        
                        if (targetOffset > contentSize.width - bounds.size.width)
                        {
                            
                            _draggingPosition->x -= targetOffset - contentSize.width + bounds.size.width;
                            
                            targetOffset = contentSize.width - bounds.size.width;
                            
                        }
                        
                        [_galleryView setContentOffset: CGPointMake(targetOffset, 0)];
                        
                    }
                    
                }
                
                break;
            }
                
            case ERGalleryViewArrangementDirectionVertical:
            {
                
                CGSize size = [_galleryView sizeForThumbnailAtIndexPath: [_draggingIndexPaths objectAtIndex: 0]];
                
                CGRect bounds = [_galleryView bounds];
                CGSize contentSize = [_galleryView contentSize];
                CGPoint contentOffset = [_galleryView contentOffset];
                
                if (contentSize.height > bounds.size.height)
                {
                    
                    if ((_draggingPosition->y - contentOffset.y < size.height / 2) &&
                        ([_galleryView contentOffset].y > 0))
                    {
                        
                        CGFloat targetOffset = contentOffset.y - ERGalleryViewScrollingStep;
                        
                        _draggingPosition->y -= ERGalleryViewScrollingStep;
                        
                        if (targetOffset < 0)
                        {
                            
                            _draggingPosition->y += -targetOffset;
                            
                            targetOffset = 0;
                            
                        }
                        
                        [_galleryView setContentOffset: CGPointMake(0, targetOffset)];
                        
                    }
                    
                    if ((_draggingPosition->y - contentOffset.y >= bounds.size.height - size.height / 2) &&
                        ([_galleryView contentOffset].y < [_galleryView contentSize].height - bounds.size.height))
                    {
                        
                        CGFloat targetOffset = contentOffset.y + ERGalleryViewScrollingStep;
                        
                        _draggingPosition->y += ERGalleryViewScrollingStep;
                        
                        if (targetOffset > contentSize.height - bounds.size.height)
                        {
                            
                            _draggingPosition->y -= targetOffset - contentSize.height + bounds.size.height;
                            
                            targetOffset = contentSize.height - bounds.size.height;
                            
                        }
                        
                        [_galleryView setContentOffset: CGPointMake(0, targetOffset)];
                        
                    }
                    
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
}

- (void)panGestureRecognizedBy: (UIPanGestureRecognizer *)recognizer
{
    
    switch ([recognizer state])
    {
            
        case UIGestureRecognizerStateBegan:
        {
            
            if ([_draggingIndexPaths count])
            {
                
                if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willBeginDraggingThumbnailsAtIndexPaths:)])
                {
                    [[_galleryView delegate]        galleryView: _galleryView
                        willBeginDraggingThumbnailsAtIndexPaths: _draggingIndexPaths];
                }
                
                for (NSIndexPath *indexPath in _draggingIndexPaths)
                {
                    
                    ERGalleryViewThumbnail *thumbnail = [_galleryView thumbnailAtIndexPath: indexPath];
                    
                    NSValue *initialCenter = [NSValue valueWithCGPoint: [thumbnail center]];
                    
                    *_draggingPosition = [_galleryView convertPoint: [initialCenter CGPointValue]
                                                           fromView: [_galleryView superview]];
                    
                    objc_setAssociatedObject(thumbnail,
                                             &ERGalleryViewThumbnailInitialCenterKey,
                                             initialCenter,
                                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    
                }
                
                if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:didBeginDraggingThumbnailsAtIndexPaths:)])
                {
                    [[_galleryView delegate]       galleryView: _galleryView
                        didBeginDraggingThumbnailsAtIndexPaths: _draggingIndexPaths];
                }
                
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            
            if ([_draggingIndexPaths count])
            {
                
                for (NSIndexPath *indexPath in _draggingIndexPaths)
                {
                    
                    ERGalleryViewThumbnail *thumbnail = [_galleryView thumbnailAtIndexPath: indexPath];
                    
                    CGPoint initialCenter = [objc_getAssociatedObject(thumbnail, &ERGalleryViewThumbnailInitialCenterKey) CGPointValue];
                    
                    CGPoint translation = [recognizer translationInView: [_galleryView superview]];
                    
                    CGPoint newCenter = CGPointMake(translation.x + initialCenter.x,
                                                    translation.y + initialCenter.y);
                    
                    *_draggingPosition = [_galleryView convertPoint: newCenter
                                                           fromView: [_galleryView superview]];
                    
                    [thumbnail setAdjustedCenter: newCenter];
                    
                }
                
                BOOL draggingPlaceable = NO;
                if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:dragThumbnailsAtIndexPaths:toLocation:)])
                {
                    draggingPlaceable = [[_galleryView delegate] galleryView: _galleryView
                                                  dragThumbnailsAtIndexPaths: _draggingIndexPaths
                                                                  toLocation: *_draggingPosition];
                }
                
                _needRearrangement = YES;
                
                [self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                                     draggingPlaceable: draggingPlaceable];
                
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            
            if ([_draggingIndexPaths count])
            {
                
                for (NSIndexPath *indexPath in _draggingIndexPaths)
                {
                    
                    ERGalleryViewThumbnail *thumbnail = [_galleryView thumbnailAtIndexPath: indexPath];
                    
                    objc_setAssociatedObject(thumbnail,
                                             &ERGalleryViewThumbnailInitialCenterKey,
                                             nil,
                                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    
                }
                
            }
            
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
}

- (void)longPressGestureRecognizedBy: (UILongPressGestureRecognizer *)recognizer
{
    
    BOOL finishedSucceeded = NO;
    
    switch ([recognizer state])
    {
            
        case UIGestureRecognizerStateBegan:
        {
            
            NSIndexPath *indexPath = [_galleryView indexPathForThumbnailAtPoint: [recognizer locationInView: _galleryView]];
            
            if (indexPath)
            {
                
                [_draggingIndexPaths addObject: indexPath];
                
                ERGalleryViewThumbnail *thumbnail = [_galleryView thumbnailAtIndexPath: indexPath];
                [thumbnail setFrame: [[_galleryView superview] convertRect: [thumbnail frame]
                                                                          fromView: _galleryView]];
                [thumbnail removeFromSuperview];
                
                [[_galleryView superview] insertSubview: thumbnail
                                           aboveSubview: _galleryView];
                
                [UIView animateWithDuration: 0.3
                                 animations: (^(void)
                                              {
                                                  
                                                  [thumbnail setTransform: CGAffineTransformMakeScale(1.2, 1.2)];
                                                  [thumbnail setAlpha: 0.8];
                                                  
                                              })];
                
                *_draggingPosition = [_galleryView convertPoint: [thumbnail center]
                                                       fromView: [_galleryView superview]];
                
                [self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                                     draggingPlaceable: NO];
                
                [self startScrollingTimer];
                
                [*_draggingTargetIndexPath release];
                
                *_draggingTargetIndexPath = nil;
                
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            
            if ([_draggingIndexPaths count])
            {
                finishedSucceeded = YES;
            }
            
        }
            
        case UIGestureRecognizerStateCancelled:
        {
            
            if ([_draggingIndexPaths count])
            {
                
                [self stopScrollingTimer];
                
                [_selfManagedIndexPaths removeAllObjects];
                
                [_selfManagedIndexPaths addObjectsFromArray: _draggingIndexPaths];
                
                [UIView animateWithDuration: 0.3
                                 animations: (^(void)
                                              {
                                                  
                                                  for (NSIndexPath *indexPath in _draggingIndexPaths)
                                                  {
                                                      
                                                      ERGalleryViewThumbnail *thumbnail = [_thumbnails objectForKey: indexPath];
                                                      
                                                      [thumbnail setTransform: CGAffineTransformIdentity];
                                                      [thumbnail setAlpha: 1];
                                                      
                                                  }
                                                  
                                              })
                                 completion: (^(BOOL finished)
                                              {
                                                  
                                                  for (NSIndexPath *indexPath in _selfManagedIndexPaths)
                                                  {
                                                      
                                                      ERGalleryViewThumbnail *thumbnail = [_thumbnails objectForKey: indexPath];
                                                      
                                                      CGRect frame = [[_galleryView superview] convertRect: [thumbnail frame]
                                                                                                    toView: _galleryView];
                                                      [thumbnail setFrame: frame];
                                                      
                                                      [thumbnail removeFromSuperview];
                                                      
                                                      [_galleryView insertSubview: thumbnail belowSubview: _separatorView];
                                                      
                                                      [_thumbnailLayouts setObject: [NSValue valueWithCGRect: frame]
                                                                            forKey: indexPath];
                                                      
                                                  }
                                                  
                                                  [_selfManagedIndexPaths removeAllObjects];
                                                  
                                                  _needRearrangement = YES;
                                                  
                                                  [self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                                                                       draggingPlaceable: NO];
                                                  
                                              })];
                
                if (finishedSucceeded)
                {
                    
                    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:couldThumbnailsAtIndexPaths:beDraggedOnLocation:)] &&
                        [[_galleryView delegate] galleryView: _galleryView
                                 couldThumbnailsAtIndexPaths: _draggingIndexPaths
                                         beDraggedOnLocation: *_draggingPosition])
                    {
                        
                        if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willEndDraggingForThumbnailsAtIndexPaths:location:)])
                        {
                            [[_galleryView delegate]           galleryView: _galleryView
                                  willEndDraggingForThumbnailsAtIndexPaths: _draggingIndexPaths
                                                                  location: *_draggingPosition];
                        }
                        
                        [_galleryView beginUpdates];
                        
                        [_galleryView deleteThumbnailsAtIndexPaths: _draggingIndexPaths
                                            withThumbnailAnimation: ERGalleryViewThumbnailAnimationAutomatic];
                        
                        [_galleryView endUpdates];
                        
                        if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:didEndDraggingForThumbnailsAtIndexPaths:location:)])
                        {
                            [[_galleryView delegate]          galleryView: _galleryView
                                  didEndDraggingForThumbnailsAtIndexPaths: _draggingIndexPaths
                                                                 location: *_draggingPosition];
                        }
                        
                    }
                    else if (*_draggingTargetIndexPath)
                    {
                        
                        if ((![[_galleryView dataSource] respondsToSelector: @selector(galleryView:canMoveThumbnailsAtIndexPaths:)]) ||
                            [[_galleryView dataSource] galleryView: _galleryView canMoveThumbnailsAtIndexPaths: _draggingIndexPaths])
                        {
                            
                            NSMutableDictionary *indexPathsSettings = [NSMutableDictionary dictionary];
                            
                            for (NSIndexPath *indexPath in _draggingIndexPaths)
                            {
                                
                                NSMutableArray *indexes = [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]];
                                if (!indexes)
                                {
                                    
                                    indexes = [NSMutableArray array];
                                    
                                    [indexPathsSettings setObject: indexes
                                                           forKey: [NSNumber numberWithInteger: [indexPath section]]];
                                    
                                }
                                
                                [indexes addObject: [NSNumber numberWithInteger: [indexPath thumbnail]]];
                                
                            }
                            
                            NSMutableDictionary *thumbnails = [NSMutableDictionary dictionary];
                            for (NSIndexPath *indexPath in _thumbnails)
                            {
                                
                                switch ([indexPath length])
                                {
                                        
                                    case 1:
                                    {
                                        
                                        [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                                       forKey: indexPath];
                                        
                                        break;
                                    }
                                        
                                    case 2:
                                    {
                                        
                                        if ([_draggingIndexPaths containsObject: indexPath])
                                        {
                                            [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                                           forKey: [NSIndexPath indexPathForThumbnail: [*_draggingTargetIndexPath thumbnail] + [_draggingIndexPaths indexOfObject: indexPath]
                                                                                            inSection: [*_draggingTargetIndexPath section]]];
                                        }
                                        else
                                        {
                                            
                                            NSInteger correctThumbnailIndex = [indexPath thumbnail];
                                            
                                            for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                                            {
                                                if ([number integerValue] < [indexPath thumbnail])
                                                {
                                                    --correctThumbnailIndex;
                                                }
                                            }
                                            
                                            if (([indexPath section] == [*_draggingTargetIndexPath section]) &&
                                                (correctThumbnailIndex >= [*_draggingTargetIndexPath thumbnail]))
                                            {
                                                correctThumbnailIndex += [_draggingIndexPaths count];
                                            }
                                            
                                            [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                                           forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                            inSection: [indexPath section]]];
                                            
                                        }
                                        
                                        break;
                                    }
                                        
                                    default:
                                    {
                                        break;
                                    }
                                        
                                }
                                
                            }
                            
                            [_thumbnails removeAllObjects];
                            [_thumbnails addEntriesFromDictionary: thumbnails];
                            
                            NSMutableDictionary *thumbnailLayouts = [NSMutableDictionary dictionary];
                            for (NSIndexPath *indexPath in _thumbnailLayouts)
                            {
                                
                                switch ([indexPath length])
                                {
                                        
                                    case 1:
                                    {
                                        
                                        [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                                             forKey: indexPath];
                                        
                                        break;
                                    }
                                        
                                    case 2:
                                    {
                                        
                                        if ([_draggingIndexPaths containsObject: indexPath])
                                        {
                                            [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                                                 forKey: [NSIndexPath indexPathForThumbnail: [*_draggingTargetIndexPath thumbnail] + [_draggingIndexPaths indexOfObject: indexPath]
                                                                                                  inSection: [*_draggingTargetIndexPath section]]];
                                        }
                                        else
                                        {
                                            
                                            NSInteger correctThumbnailIndex = [indexPath thumbnail];
                                            
                                            for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                                            {
                                                if ([number integerValue] < [indexPath thumbnail])
                                                {
                                                    --correctThumbnailIndex;
                                                }
                                            }
                                            
                                            if (([indexPath section] == [*_draggingTargetIndexPath section]) &&
                                                (correctThumbnailIndex >= [*_draggingTargetIndexPath thumbnail]))
                                            {
                                                correctThumbnailIndex += [_draggingIndexPaths count];
                                            }
                                            
                                            [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                                                 forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                                  inSection: [indexPath section]]];
                                            
                                        }
                                        
                                        break;
                                    }
                                        
                                    default:
                                    {
                                        break;
                                    }
                                        
                                }
                                
                            }
                            
                            [_thumbnailLayouts removeAllObjects];
                            [_thumbnailLayouts addEntriesFromDictionary: thumbnailLayouts];
                            
                            NSMutableDictionary *preservedThumbnailIndexPaths = [NSMutableDictionary dictionary];
                            for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
                            {
                                
                                switch ([indexPath length])
                                {
                                        
                                    case 1:
                                    {
                                        
                                        [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                                         forKey: indexPath];
                                        
                                        break;
                                    }
                                        
                                    case 2:
                                    {
                                        
                                        if ([_draggingIndexPaths containsObject: indexPath])
                                        {
                                            [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                                             forKey: [NSIndexPath indexPathForThumbnail: [*_draggingTargetIndexPath thumbnail] + [_draggingIndexPaths indexOfObject: indexPath]
                                                                                                              inSection: [*_draggingTargetIndexPath section]]];
                                        }
                                        else
                                        {
                                            
                                            NSInteger correctThumbnailIndex = [indexPath thumbnail];
                                            
                                            for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                                            {
                                                if ([number integerValue] < [indexPath thumbnail])
                                                {
                                                    --correctThumbnailIndex;
                                                }
                                            }
                                            
                                            if (([indexPath section] == [*_draggingTargetIndexPath section]) &&
                                                (correctThumbnailIndex >= [*_draggingTargetIndexPath thumbnail]))
                                            {
                                                correctThumbnailIndex += [_draggingIndexPaths count];
                                            }
                                            
                                            [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                                             forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                                              inSection: [indexPath section]]];
                                            
                                        }
                                        
                                        break;
                                    }
                                        
                                    default:
                                    {
                                        break;
                                    }
                                        
                                }
                                
                            }
                            
                            [_preservedThumbnailIndexPaths removeAllObjects];
                            [_preservedThumbnailIndexPaths addEntriesFromDictionary: preservedThumbnailIndexPaths];
                            
                            NSMutableArray *selfManagedIndexPaths = [NSMutableArray array];
                            for (NSIndexPath *indexPath in _selfManagedIndexPaths)
                            {
                                
                                switch ([indexPath length])
                                {
                                        
                                    case 1:
                                    {
                                        
                                        [selfManagedIndexPaths addObject: indexPath];
                                        
                                        break;
                                    }
                                        
                                    case 2:
                                    {
                                        
                                        if ([_draggingIndexPaths containsObject: indexPath])
                                        {
                                            [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: [*_draggingTargetIndexPath thumbnail] + [_draggingIndexPaths indexOfObject: indexPath]
                                                                                                       inSection: [*_draggingTargetIndexPath section]]];
                                        }
                                        else
                                        {
                                            
                                            NSInteger correctThumbnailIndex = [indexPath thumbnail];
                                            
                                            for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                                            {
                                                if ([number integerValue] < [indexPath thumbnail])
                                                {
                                                    --correctThumbnailIndex;
                                                }
                                            }
                                            
                                            if (([indexPath section] == [*_draggingTargetIndexPath section]) &&
                                                (correctThumbnailIndex >= [*_draggingTargetIndexPath thumbnail]))
                                            {
                                                correctThumbnailIndex += [_draggingIndexPaths count];
                                            }
                                            
                                            [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                                       inSection: [indexPath section]]];
                                            
                                        }
                                        
                                        break;
                                    }
                                        
                                    default:
                                    {
                                        break;
                                    }
                                        
                                }
                                
                            }
                            
                            [_selfManagedIndexPaths removeAllObjects];
                            
                            [_selfManagedIndexPaths addObjectsFromArray: selfManagedIndexPaths];
                            
                            NSMutableArray *selection = [NSMutableArray array];
                            for (NSIndexPath *indexPath in _selection)
                            {
                                
                                switch ([indexPath length])
                                {
                                        
                                    case 1:
                                    {
                                        
                                        [selection addObject: indexPath];
                                        
                                        break;
                                    }
                                        
                                    case 2:
                                    {
                                        
                                        if ([_draggingIndexPaths containsObject: indexPath])
                                        {
                                            [selection addObject: [NSIndexPath indexPathForThumbnail: [*_draggingTargetIndexPath thumbnail] + [_draggingIndexPaths indexOfObject: indexPath]
                                                                                           inSection: [*_draggingTargetIndexPath section]]];
                                        }
                                        else
                                        {
                                            
                                            NSInteger correctThumbnailIndex = [indexPath thumbnail];
                                            
                                            for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                                            {
                                                if ([number integerValue] < [indexPath thumbnail])
                                                {
                                                    --correctThumbnailIndex;
                                                }
                                            }
                                            
                                            if (([indexPath section] == [*_draggingTargetIndexPath section]) &&
                                                (correctThumbnailIndex >= [*_draggingTargetIndexPath thumbnail]))
                                            {
                                                correctThumbnailIndex += [_draggingIndexPaths count];
                                            }
                                            
                                            [selection addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                           inSection: [indexPath section]]];
                                            
                                        }
                                        
                                        break;
                                    }
                                        
                                    default:
                                    {
                                        break;
                                    }
                                        
                                }
                                
                            }
                            
                            [_selection removeAllObjects];
                            
                            [_selection addObjectsFromArray: selection];
                            
                            if ([[_galleryView dataSource] respondsToSelector: @selector(galleryView:moveThumbnailsAtIndexPaths:toIndexPath:)])
                            {
                                [[_galleryView dataSource] galleryView: _galleryView
                                            moveThumbnailsAtIndexPaths: _draggingIndexPaths
                                                           toIndexPath: *_draggingTargetIndexPath];
                            }
                            
                        }
                        
                    }
                    
                }
                
                [*_draggingTargetIndexPath release];
                
                *_draggingTargetIndexPath = nil;
                
                [_draggingIndexPaths removeAllObjects];
                
                if (!finishedSucceeded)
                {
                    [self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                                         draggingPlaceable: NO];
                }
                
            }
            
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
}

- (void)tapGestureRecognizedBy: (UITapGestureRecognizer *)recognizer
{
    
    switch ([recognizer state])
    {
            
        case UIGestureRecognizerStateBegan:
        {
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            
            NSIndexPath *indexPath = [_galleryView indexPathForThumbnailAtPoint: [recognizer locationInView: _galleryView]];
            
            if (([indexPath length] == 2) &&
                ([indexPath thumbnail] != [_galleryView numberOfThumbnailsInSectionAtIndex: [indexPath section]]))
            {
                
                if ([_galleryView editing])
                {
                    
                    if (_allowsSelectionDuringEditing)
                    {
                        
                        if (_allowsMultipleSelectionDuringEditing)
                        {
                            [self toggleThumbnailInSelectionAtIndexPath: indexPath
                                                               animated: YES
                                                         scrollPosition: ERGalleryViewScrollPositionNone];
                        }
                        else
                        {
                            [self selectThumbnailAtIndexPath: indexPath
                                                    animated: YES
                                              scrollPosition: ERGalleryViewScrollPositionNone];
                        }
                        
                    }
                    
                }
                else
                {
                    
                    if (_allowsSelection)
                    {
                        
                        if (_allowsMultipleSelection)
                        {
                            [self toggleThumbnailInSelectionAtIndexPath: indexPath
                                                               animated: YES
                                                         scrollPosition: ERGalleryViewScrollPositionNone];
                        }
                        else
                        {
                            [self selectThumbnailAtIndexPath: indexPath
                                                    animated: YES
                                              scrollPosition: ERGalleryViewScrollPositionNone];
                        }
                        
                    }
                    
                }
                
            }
            else
            {
                
                if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:didTapEmptyArea:)])
                {
                    [[_galleryView delegate] galleryView: _galleryView
                                         didTapEmptyArea: recognizer];
                }
                
            }
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        {
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([[touch view] isKindOfClass: [UIControl class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}

- (BOOL)                             gestureRecognizer: (UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer *)otherGestureRecognizer
{
    
    if (gestureRecognizer == _panGestureRecognizer)
    {
        
        if (otherGestureRecognizer == _longPressGestureRecognizer)
        {
            return YES;
        }
        else if (otherGestureRecognizer == [_galleryView panGestureRecognizer])
        {
            return YES;
        }
        else
        {
            return YES;
        }
        
    }
    else if (gestureRecognizer == _longPressGestureRecognizer)
    {
        
        if (otherGestureRecognizer == [_galleryView panGestureRecognizer])
        {
            return NO;
        }
        else if (otherGestureRecognizer == _panGestureRecognizer)
        {
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    else if (gestureRecognizer == _tapGestureRecognizer)
    {
        return NO;
    }
    else
    {
        return NO;
    }
    
}

- (NSIndexPath *)indexPathForSelectedThumbnail
{
    
    if ([_selection count])
    {
        return [_selection objectAtIndex: 0];
    }
    else
    {
        return nil;
    }
    
}

- (NSArray *)indexPathsForSelectedThumbnails
{
    return _selection;
}

- (void)selectThumbnailAtIndexPath: (NSIndexPath *)indexPath
                          animated: (BOOL)animated
                    scrollPosition: (ERGalleryViewScrollPosition)scrollPosition
{
    
    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willSelectThumbnailAtIndexPath:)])
    {
        [[_galleryView delegate] galleryView: _galleryView
              willSelectThumbnailAtIndexPath: indexPath];
    }
    
    if (![_selection containsObject: indexPath])
    {
        
        BOOL allowsMultipleSelection = _allowsMultipleSelection;
        if ([_galleryView editing])
        {
            allowsMultipleSelection = _allowsMultipleSelectionDuringEditing;
        }
        
        if (!allowsMultipleSelection)
        {
            
            for (NSIndexPath *indexPath in _selection)
            {
                
                if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willDeselectThumbnailAtIndexPath:)])
                {
                    [[_galleryView delegate] galleryView: _galleryView
                        willDeselectThumbnailAtIndexPath: indexPath];
                }
                
                [[_thumbnails objectForKey: indexPath] setSelected: NO
                                                          animated: animated];
                
                if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:didDeselectThumbnailAtIndexPath:)])
                {
                    [[_galleryView delegate] galleryView: _galleryView
                         didDeselectThumbnailAtIndexPath: indexPath];
                }
                
            }
            
            [_selection removeAllObjects];
            
        }
        
        [_selection addObject: indexPath];
        
        [[_thumbnails objectForKey: indexPath] setSelected: YES
                                                  animated: animated];
        
    }
    
    [_galleryView scrollToThumbnailAtIndexPath: indexPath
                              atScrollPosition: scrollPosition
                                      animated: animated];
    
    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:didSelectThumbnailAtIndexPath:)])
    {
        [[_galleryView delegate] galleryView: _galleryView
               didSelectThumbnailAtIndexPath: indexPath];
    }
    
    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:selectionChanged:)])
    {
        [[_galleryView delegate] galleryView: _galleryView
                            selectionChanged: _selection];
    }
    
}

- (void)deselectThumbnailAtIndexPath: (NSIndexPath *)indexPath
                            animated: (BOOL)animated
{
    
    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willDeselectThumbnailAtIndexPath:)])
    {
        [[_galleryView delegate] galleryView: _galleryView
            willDeselectThumbnailAtIndexPath: indexPath];
    }
    
    if ([_selection containsObject: indexPath])
    {
        
        [_selection removeObject: indexPath];
        
        [[_thumbnails objectForKey: indexPath] setSelected: NO
                                                  animated: animated];
        
    }
    
    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:didDeselectThumbnailAtIndexPath:)])
    {
        [[_galleryView delegate] galleryView: _galleryView
             didDeselectThumbnailAtIndexPath: indexPath];
    }
    
    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:selectionChanged:)])
    {
        [[_galleryView delegate] galleryView: _galleryView
                            selectionChanged: _selection];
    }
    
}

- (void)toggleThumbnailInSelectionAtIndexPath: (NSIndexPath *)indexPath
                                     animated: (BOOL)animated
                               scrollPosition: (ERGalleryViewScrollPosition)scrollPosition
{
    
    if ([_selection containsObject: indexPath])
    {
        [self deselectThumbnailAtIndexPath: indexPath
                                  animated: animated];
    }
    else
    {
        [self selectThumbnailAtIndexPath: indexPath
                                animated: animated
                          scrollPosition: scrollPosition];
    }
    
}

- (void)clearSelection
{
    
    for (NSIndexPath *indexPath in _selection)
    {
        
        if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:willDeselectThumbnailAtIndexPath:)])
        {
            [[_galleryView delegate] galleryView: _galleryView
                willDeselectThumbnailAtIndexPath: indexPath];
        }
        
        [[_thumbnails objectForKey: indexPath] setSelected: NO];
        
        if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:didDeselectThumbnailAtIndexPath:)])
        {
            [[_galleryView delegate] galleryView: _galleryView
                 didDeselectThumbnailAtIndexPath: indexPath];
        }
        
    }
    
    [_selection removeAllObjects];
    
    if ([[_galleryView delegate] respondsToSelector: @selector(galleryView:selectionChanged:)])
    {
        [[_galleryView delegate] galleryView: _galleryView
                            selectionChanged: _selection];
    }
    
}

- (void)beginUpdates
{
    [_animationIndexPaths removeAllObjects];
}

- (void)endUpdates
{
    
    [self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                         draggingPlaceable: NO];
    
    [_animationIndexPaths removeAllObjects];
    
}

- (void)insertThumbnailsAtIndexPaths: (NSArray *)indexPaths
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    
    NSMutableDictionary *indexPathsSettings = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        
        NSMutableArray *indexes = [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]];
        if (!indexes)
        {
            
            indexes = [NSMutableArray array];
            
            [indexPathsSettings setObject: indexes
                                   forKey: [NSNumber numberWithInteger: [indexPath section]]];
            
        }
        
        [indexes addObject: [NSNumber numberWithInteger: [indexPath thumbnail]]];
        
    }
    
    for (NSNumber *number in indexPathsSettings)
    {
        [[indexPathsSettings objectForKey: number] sortUsingComparator: (^NSComparisonResult(id object, id object2)
                                                                         {
                                                                             
                                                                             NSInteger value = [object integerValue];
                                                                             NSInteger value2 = [object integerValue];
                                                                             
                                                                             if (value < value2)
                                                                             {
                                                                                 return NSOrderedAscending;
                                                                             }
                                                                             else if (value > value2)
                                                                             {
                                                                                 return NSOrderedDescending;
                                                                             }
                                                                             else
                                                                             {
                                                                                 return NSOrderedSame;
                                                                             }
                                                                             
                                                                         })];
    }
    
    NSMutableDictionary *thumbnails = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] <= [indexPath thumbnail])
                    {
                        ++correctThumbnailIndex;
                    }
                }
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                inSection: [indexPath section]]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnails removeAllObjects];
    
    [_thumbnails addEntriesFromDictionary: thumbnails];
    
    NSMutableDictionary *thumbnailLayouts = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] <= [indexPath thumbnail])
                    {
                        ++correctThumbnailIndex;
                    }
                }
                
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                      inSection: [indexPath section]]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnailLayouts removeAllObjects];
    
    [_thumbnailLayouts addEntriesFromDictionary: thumbnailLayouts];
    
    NSMutableDictionary *preservedThumbnailIndexPaths = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] <= [indexPath thumbnail])
                    {
                        ++correctThumbnailIndex;
                    }
                }
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                  inSection: [indexPath section]]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_preservedThumbnailIndexPaths removeAllObjects];
    
    [_preservedThumbnailIndexPaths addEntriesFromDictionary: preservedThumbnailIndexPaths];
    
    NSMutableArray *selfManagedIndexPaths = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selfManagedIndexPaths)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selfManagedIndexPaths addObject: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] <= [indexPath thumbnail])
                    {
                        ++correctThumbnailIndex;
                    }
                }
                
                [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                           inSection: [indexPath section]]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selfManagedIndexPaths removeAllObjects];
    
    [_selfManagedIndexPaths addObjectsFromArray: selfManagedIndexPaths];
    
    NSMutableArray *selection = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selection)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selection addObject: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] <= [indexPath thumbnail])
                    {
                        ++correctThumbnailIndex;
                    }
                }
                
                [selection addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                               inSection: [indexPath section]]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selection removeAllObjects];
    
    [_selection addObjectsFromArray: selection];
    
    //[_animationIndexPaths removeAllObjects];
    
    for (NSNumber *sectionIndex in indexPathsSettings)
    {
        
        NSMutableArray *scanner =  [NSMutableArray array];
        
        NSMutableArray *thumbnailIndexes = [indexPathsSettings objectForKey: sectionIndex];
        
        NSInteger looper = 0;
        while (looper < [_galleryView numberOfThumbnailsInSectionAtIndex: [sectionIndex integerValue]] - [thumbnailIndexes count])
        {
            
            [scanner addObject: [NSNumber numberWithBool: NO]];
            
            ++looper;
        }
        
        looper = [thumbnailIndexes count];
        while (looper)
        {
            --looper;
            
            [scanner insertObject: [NSNumber numberWithBool: YES]
                          atIndex: [[thumbnailIndexes objectAtIndex: looper] integerValue]];
            
        }
        
        [scanner enumerateObjectsUsingBlock: (^(id object, NSUInteger index, BOOL *stop)
                                              {
                                                  if ([object boolValue])
                                                  {
                                                      [_animationIndexPaths addObject: [NSIndexPath indexPathForThumbnail: index
                                                                                                                inSection: [sectionIndex integerValue]]];
                                                  }
                                              })];
        
    }
    
    _needRearrangement = YES;
    
    //[self rearrangeThumbnailsWithAnimation: animation
    //                     draggingPlaceable: NO];
    
    //[_animationIndexPaths removeAllObjects];
    
}

- (void)deleteThumbnailsAtIndexPaths: (NSArray *)indexPaths
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    
    NSMutableArray *thumbnailsToRemove = [NSMutableArray array];
    
    NSMutableDictionary *indexPathsSettings = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        
        NSMutableArray *indexes = [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]];
        if (!indexes)
        {
            
            indexes = [NSMutableArray array];
            
            [indexPathsSettings setObject: indexes
                                   forKey: [NSNumber numberWithInteger: [indexPath section]]];
            
        }
        
        [indexes addObject: [NSNumber numberWithInteger: [indexPath thumbnail]]];
        
    }
    
    NSMutableDictionary *thumbnails = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                BOOL needToRemove = NO;
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] < [indexPath thumbnail])
                    {
                        --correctThumbnailIndex;
                    }
                    else if ([number integerValue] == [indexPath thumbnail])
                    {
                        needToRemove = YES;
                    }
                }
                
                if (needToRemove)
                {
                    [thumbnailsToRemove addObject: [_thumbnails objectForKey: indexPath]];
                }
                else
                {
                    [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                   forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                    inSection: [indexPath section]]];
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnails removeAllObjects];
    
    [_thumbnails addEntriesFromDictionary: thumbnails];
    
    NSMutableDictionary *thumbnailLayouts = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                BOOL needToRemove = NO;
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] < [indexPath thumbnail])
                    {
                        --correctThumbnailIndex;
                    }
                    else if ([number integerValue] == [indexPath thumbnail])
                    {
                        needToRemove = YES;
                    }
                }
                
                if (!needToRemove)
                {
                    [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                         forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                          inSection: [indexPath section]]];
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnailLayouts removeAllObjects];
    
    [_thumbnailLayouts addEntriesFromDictionary: thumbnailLayouts];
    
    NSMutableDictionary *preservedThumbnailIndexPaths = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                BOOL needToRemove = NO;
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] < [indexPath thumbnail])
                    {
                        --correctThumbnailIndex;
                    }
                    else if ([number integerValue] == [indexPath thumbnail])
                    {
                        needToRemove = YES;
                    }
                }
                
                if (!needToRemove)
                {
                    [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                     forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                      inSection: [indexPath section]]];
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_preservedThumbnailIndexPaths removeAllObjects];
    
    [_preservedThumbnailIndexPaths addEntriesFromDictionary: preservedThumbnailIndexPaths];
    
    NSMutableArray *selfManagedIndexPaths = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selfManagedIndexPaths)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selfManagedIndexPaths addObject: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                BOOL needToRemove = NO;
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] < [indexPath thumbnail])
                    {
                        --correctThumbnailIndex;
                    }
                    else if ([number integerValue] == [indexPath thumbnail])
                    {
                        needToRemove = YES;
                    }
                }
                
                if (!needToRemove)
                {
                    [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                               inSection: [indexPath section]]];
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selfManagedIndexPaths removeAllObjects];
    
    [_selfManagedIndexPaths addObjectsFromArray: selfManagedIndexPaths];
    
    NSMutableArray *selection = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selection)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selection addObject: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                BOOL needToRemove = NO;
                
                NSInteger correctThumbnailIndex = [indexPath thumbnail];
                
                for (NSNumber *number in [indexPathsSettings objectForKey: [NSNumber numberWithInteger: [indexPath section]]])
                {
                    if ([number integerValue] < [indexPath thumbnail])
                    {
                        --correctThumbnailIndex;
                    }
                    else if ([number integerValue] == [indexPath thumbnail])
                    {
                        needToRemove = YES;
                    }
                }
                
                if (!needToRemove)
                {
                    [selection addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                   inSection: [indexPath section]]];
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selection removeAllObjects];
    
    [_selection addObjectsFromArray: selection];
    
    [thumbnailsToRemove retain];
    
    switch (animation)
    {
            
        case ERGalleryViewThumbnailAnimationNone:
        {
            
            for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
            {
                [thumbnail removeFromSuperview];
            }
            
            [thumbnailsToRemove release];
            
            break;
        }
            
        case ERGalleryViewThumbnailAnimationFade:
        {
            
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail setAlpha: 0];
                                              }
                                          })
                             completion: (^(BOOL finished)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail removeFromSuperview];
                                              }
                                              
                                              [thumbnailsToRemove release];
                                              
                                          })];
            
            break;
        }
            
        case ERGalleryViewThumbnailAnimationZoom:
        {
            
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                              }
                                          })
                             completion: (^(BOOL finished)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail removeFromSuperview];
                                              }
                                              
                                              [thumbnailsToRemove release];
                                              
                                          })];
            
            break;
        }
            
        case ERGalleryViewThumbnailAnimationAutomatic:
        default:
        {
            
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                                  [thumbnail setAlpha: 0];
                                              }
                                          })
                             completion: (^(BOOL finished)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail removeFromSuperview];
                                              }
                                              
                                              [thumbnailsToRemove release];
                                              
                                          })];
            
            break;
        }
            
    }
    
    _needRearrangement = YES;
    
    //[self rearrangeThumbnailsWithAnimation: animation
    //                     draggingPlaceable: NO];
    
}

- (void)moveThumbnailAtIndexPath: (NSIndexPath *)fromIndexPath
                     toIndexPath: (NSIndexPath *)toIndexPath
{
    
    NSMutableDictionary *thumbnails = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                if ([indexPath isEqual: fromIndexPath])
                {
                    [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                   forKey: toIndexPath];
                }
                else
                {
                    
                    NSInteger correctThumbnailIndex = [indexPath thumbnail];
                    
                    if (([fromIndexPath thumbnail] < [indexPath thumbnail]) &&
                        ([indexPath section] == [fromIndexPath section]))
                    {
                        --correctThumbnailIndex;
                    }
                    
                    if ((correctThumbnailIndex >= [toIndexPath thumbnail]) &&
                        ([indexPath section] == [toIndexPath section]))
                    {
                        ++correctThumbnailIndex;
                    }
                    
                    [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                   forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                    inSection: [indexPath section]]];
                    
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnails removeAllObjects];
    [_thumbnails addEntriesFromDictionary: thumbnails];
    
    NSMutableDictionary *thumbnailLayouts = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                if ([fromIndexPath isEqual: indexPath])
                {
                    [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                         forKey: toIndexPath];
                }
                else
                {
                    
                    NSInteger correctThumbnailIndex = [indexPath thumbnail];
                    
                    if (([fromIndexPath thumbnail] < [indexPath thumbnail]) &&
                        ([indexPath section] == [fromIndexPath section]))
                    {
                        --correctThumbnailIndex;
                    }
                    
                    if ((correctThumbnailIndex >= [toIndexPath thumbnail]) &&
                        ([indexPath section] == [toIndexPath section]))
                    {
                        ++correctThumbnailIndex;
                    }
                    
                    [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                         forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                          inSection: [indexPath section]]];
                    
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnailLayouts removeAllObjects];
    [_thumbnailLayouts addEntriesFromDictionary: thumbnailLayouts];
    
    NSMutableDictionary *preservedThumbnailIndexPaths = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                if ([fromIndexPath isEqual: indexPath])
                {
                    [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                     forKey: toIndexPath];
                }
                else
                {
                    
                    NSInteger correctThumbnailIndex = [indexPath thumbnail];
                    
                    if (([fromIndexPath thumbnail] < [indexPath thumbnail]) &&
                        ([indexPath section] == [fromIndexPath section]))
                    {
                        --correctThumbnailIndex;
                    }
                    
                    if ((correctThumbnailIndex >= [toIndexPath thumbnail]) &&
                        ([indexPath section] == [toIndexPath section]))
                    {
                        ++correctThumbnailIndex;
                    }
                    
                    [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                     forKey: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                      inSection: [indexPath section]]];
                    
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_preservedThumbnailIndexPaths removeAllObjects];
    [_preservedThumbnailIndexPaths addEntriesFromDictionary: preservedThumbnailIndexPaths];
    
    NSMutableArray *selfManagedIndexPaths = [NSMutableArray array];
    for (NSIndexPath *indexPath in _selfManagedIndexPaths)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selfManagedIndexPaths addObject: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                if ([fromIndexPath isEqual: indexPath])
                {
                    [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: [fromIndexPath thumbnail]
                                                                               inSection: [fromIndexPath section]]];
                }
                else
                {
                    
                    NSInteger correctThumbnailIndex = [indexPath thumbnail];
                    
                    if (([fromIndexPath thumbnail] < [indexPath thumbnail]) &&
                        ([indexPath section] == [fromIndexPath section]))
                    {
                        --correctThumbnailIndex;
                    }
                    
                    if ((correctThumbnailIndex >= [toIndexPath thumbnail]) &&
                        ([indexPath section] == [toIndexPath section]))
                    {
                        ++correctThumbnailIndex;
                    }
                    
                    [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                               inSection: [indexPath section]]];
                    
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selfManagedIndexPaths removeAllObjects];
    
    [_selfManagedIndexPaths addObjectsFromArray: selfManagedIndexPaths];
    
    NSMutableArray *selection = [NSMutableArray array];
    for (NSIndexPath *indexPath in _selection)
    {
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selection addObject: indexPath];
                
                break;
            }
                
            case 2:
            {
                
                if ([fromIndexPath isEqual: indexPath])
                {
                    [selection addObject: [NSIndexPath indexPathForThumbnail: [fromIndexPath thumbnail]
                                                                   inSection: [fromIndexPath section]]];
                }
                else
                {
                    
                    NSInteger correctThumbnailIndex = [indexPath thumbnail];
                    
                    if (([fromIndexPath thumbnail] < [indexPath thumbnail]) &&
                        ([indexPath section] == [fromIndexPath section]))
                    {
                        --correctThumbnailIndex;
                    }
                    
                    if ((correctThumbnailIndex >= [toIndexPath thumbnail]) &&
                        ([indexPath section] == [toIndexPath section]))
                    {
                        ++correctThumbnailIndex;
                    }
                    
                    [selection addObject: [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                   inSection: [indexPath section]]];
                    
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selection removeAllObjects];
    
    [_selection addObjectsFromArray: selection];
    
    _needRearrangement = YES;
    
    //[self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
    //                     draggingPlaceable: NO];
    
}

- (void)    insertSections: (NSArray *)sectionIndexes
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    
    NSMutableDictionary *thumbnails = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            if ([number integerValue] <= [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnails removeAllObjects];
    
    [_thumbnails addEntriesFromDictionary: thumbnails];
    
    NSMutableDictionary *thumbnailLayouts = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            if ([number integerValue] <= [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                      inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnailLayouts removeAllObjects];
    
    [_thumbnailLayouts addEntriesFromDictionary: thumbnailLayouts];
    
    NSMutableDictionary *preservedThumbnailIndexPaths = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            if ([number integerValue] <= [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                                  inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_preservedThumbnailIndexPaths removeAllObjects];
    
    [_preservedThumbnailIndexPaths addEntriesFromDictionary: preservedThumbnailIndexPaths];
    
    NSMutableArray *selfManagedIndexPaths = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selfManagedIndexPaths)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            if ([number integerValue] <= [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selfManagedIndexPaths addObject: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                           inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selfManagedIndexPaths removeAllObjects];
    
    [_selfManagedIndexPaths addObjectsFromArray: selfManagedIndexPaths];
    
    NSMutableArray *selection = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selection)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            if ([number integerValue] <= [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selfManagedIndexPaths addObject: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                           inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selection removeAllObjects];
    
    [_selection addObjectsFromArray: selection];
    
    _needRearrangement = YES;
    
    //[self rearrangeThumbnailsWithAnimation: animation
    //                     draggingPlaceable: NO];
    
}

- (void)    deleteSections: (NSArray *)sectionIndexes
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    
    NSMutableArray *thumbnailsToRemove = [NSMutableArray array];
    
    NSMutableDictionary *thumbnails = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        BOOL needToRemove = NO;
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            if ([number integerValue] < [indexPath indexAtPosition: 0])
            {
                --correctSectionIndex;
            }
            else if ([number integerValue] == [indexPath indexAtPosition: 0])
            {
                needToRemove = YES;
            }
        }
        
        if (needToRemove)
        {
            [thumbnailsToRemove addObject: [_thumbnails objectForKey: indexPath]];
        }
        else
        {
            
            switch ([indexPath length])
            {
                    
                case 1:
                {
                    
                    [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                   forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                    
                    break;
                }
                    
                case 2:
                {
                    
                    [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                                   forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                    inSection: correctSectionIndex]];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
        }
        
    }
    
    [_thumbnails removeAllObjects];
    
    [_thumbnails addEntriesFromDictionary: thumbnails];
    
    NSMutableDictionary *thumbnailLayouts = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        BOOL needToRemove = NO;
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            
            if ([number integerValue] < [indexPath indexAtPosition: 0])
            {
                --correctSectionIndex;
            }
            else if ([number integerValue] == [indexPath indexAtPosition: 0])
            {
                needToRemove = YES;
            }
            
        }
        
        if (!needToRemove)
        {
            
            switch ([indexPath length])
            {
                    
                case 1:
                {
                    
                    [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                         forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                    
                    break;
                }
                    
                case 2:
                {
                    
                    [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                         forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                          inSection: correctSectionIndex]];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
        }
        
    }
    
    [_thumbnailLayouts removeAllObjects];
    
    [_thumbnailLayouts addEntriesFromDictionary: thumbnailLayouts];
    
    NSMutableDictionary *preservedThumbnailIndexPaths = [NSMutableDictionary dictionary];
    
    for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
    {
        
        BOOL needToRemove = NO;
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            
            if ([number integerValue] < [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
            else if ([number integerValue] == [indexPath indexAtPosition: 0])
            {
                needToRemove = YES;
            }
            
        }
        
        if (!needToRemove)
        {
            
            switch ([indexPath length])
            {
                    
                case 1:
                {
                    
                    [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                     forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                    
                    break;
                }
                    
                case 2:
                {
                    
                    [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                     forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                                      inSection: correctSectionIndex]];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
        }
        
    }
    
    [_preservedThumbnailIndexPaths removeAllObjects];
    
    [_preservedThumbnailIndexPaths addEntriesFromDictionary: preservedThumbnailIndexPaths];
    
    NSMutableArray *selfManagedIndexPaths = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selfManagedIndexPaths)
    {
        
        BOOL needToRemove = NO;
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            
            if ([number integerValue] < [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
            else if ([number integerValue] == [indexPath indexAtPosition: 0])
            {
                needToRemove = YES;
            }
            
        }
        
        if (!needToRemove)
        {
            
            switch ([indexPath length])
            {
                    
                case 1:
                {
                    
                    [selfManagedIndexPaths addObject: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                    
                    break;
                }
                    
                case 2:
                {
                    
                    [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                               inSection: correctSectionIndex]];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
        }
        
    }
    
    [_selfManagedIndexPaths removeAllObjects];
    
    [_selfManagedIndexPaths addObjectsFromArray: selfManagedIndexPaths];
    
    NSMutableArray *selection = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _selection)
    {
        
        BOOL needToRemove = NO;
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        
        for (NSNumber *number in sectionIndexes)
        {
            
            if ([number integerValue] < [indexPath indexAtPosition: 0])
            {
                ++correctSectionIndex;
            }
            else if ([number integerValue] == [indexPath indexAtPosition: 0])
            {
                needToRemove = YES;
            }
            
        }
        
        if (!needToRemove)
        {
            
            switch ([indexPath length])
            {
                    
                case 1:
                {
                    
                    [selection addObject: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                    
                    break;
                }
                    
                case 2:
                {
                    
                    [selection addObject: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                   inSection: correctSectionIndex]];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
        }
        
    }
    
    [_selection removeAllObjects];
    
    [_selection addObjectsFromArray: selection];
    
    switch (animation)
    {
            
        case ERGalleryViewThumbnailAnimationNone:
        {
            
            for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
            {
                [thumbnail removeFromSuperview];
            }
            
            break;
        }
            
        case ERGalleryViewThumbnailAnimationFade:
        {
            
            [thumbnailsToRemove retain];
            
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail setAlpha: 0];
                                              }
                                              
                                          })
                             completion: (^(BOOL finished)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail removeFromSuperview];
                                              }
                                              
                                              [thumbnailsToRemove release];
                                          })];
            
            break;
        }
            
        case ERGalleryViewThumbnailAnimationZoom:
        {
            
            [thumbnailsToRemove retain];
            
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                              }
                                              
                                          })
                             completion: (^(BOOL finished)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail removeFromSuperview];
                                              }
                                              
                                              [thumbnailsToRemove release];
                                          })];
            
            break;
        }
            
        case ERGalleryViewThumbnailAnimationAutomatic:
        default:
        {
            
            [thumbnailsToRemove retain];
            
            [UIView animateWithDuration: 0.3
                             animations: (^(void)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail setTransform: CGAffineTransformMakeScale(0.0001, 0.0001)];
                                                  [thumbnail setAlpha: 0];
                                              }
                                              
                                          })
                             completion: (^(BOOL finished)
                                          {
                                              
                                              for (ERGalleryViewThumbnail *thumbnail in thumbnailsToRemove)
                                              {
                                                  [thumbnail removeFromSuperview];
                                              }
                                              
                                              [thumbnailsToRemove release];
                                          })];
            
            break;
        }
            
    }
    
    _needRearrangement = YES;
    
    //[self rearrangeThumbnailsWithAnimation: animation
    //                     draggingPlaceable: NO];
    
}

- (void)moveSection: (NSInteger)fromSection
          toSection: (NSInteger)toSection
{
    
    NSMutableDictionary *thumbnails = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        if (correctSectionIndex == fromSection)
        {
            correctSectionIndex = toSection;
        }
        else
        {
            
            if (fromSection < [indexPath indexAtPosition: 0])
            {
                --correctSectionIndex;
            }
            
            if (correctSectionIndex >= toSection)
            {
                ++correctSectionIndex;
            }
            
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [thumbnails setObject: [_thumbnails objectForKey: indexPath]
                               forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnails removeAllObjects];
    [_thumbnails addEntriesFromDictionary: thumbnails];
    
    NSMutableDictionary *thumbnailLayouts = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        if (correctSectionIndex == fromSection)
        {
            correctSectionIndex = toSection;
        }
        else
        {
            
            if (fromSection < [indexPath indexAtPosition: 0])
            {
                --correctSectionIndex;
            }
            
            if (correctSectionIndex >= toSection)
            {
                ++correctSectionIndex;
            }
            
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                [thumbnailLayouts setObject: [_thumbnailLayouts objectForKey: indexPath]
                                     forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                      inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_thumbnailLayouts removeAllObjects];
    [_thumbnailLayouts addEntriesFromDictionary: thumbnailLayouts];
    
    NSMutableDictionary *preservedThumbnailIndexPaths = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        if (correctSectionIndex == fromSection)
        {
            correctSectionIndex = toSection;
        }
        else
        {
            
            if (fromSection < [indexPath indexAtPosition: 0])
            {
                --correctSectionIndex;
            }
            
            if (correctSectionIndex >= toSection)
            {
                ++correctSectionIndex;
            }
            
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [preservedThumbnailIndexPaths setObject: [_preservedThumbnailIndexPaths objectForKey: indexPath]
                                                 forKey: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                                  inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_preservedThumbnailIndexPaths removeAllObjects];
    [_preservedThumbnailIndexPaths addEntriesFromDictionary: preservedThumbnailIndexPaths];
    
    NSMutableArray *selfManagedIndexPaths = [NSMutableArray array];
    for (NSIndexPath *indexPath in _selfManagedIndexPaths)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        if (correctSectionIndex == fromSection)
        {
            correctSectionIndex = toSection;
        }
        else
        {
            
            if (fromSection < [indexPath indexAtPosition: 0])
            {
                --correctSectionIndex;
            }
            
            if (correctSectionIndex >= toSection)
            {
                ++correctSectionIndex;
            }
            
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selfManagedIndexPaths addObject: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [selfManagedIndexPaths addObject: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                                           inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selfManagedIndexPaths removeAllObjects];
    
    [_selfManagedIndexPaths addObjectsFromArray: selfManagedIndexPaths];
    
    NSMutableArray *selection = [NSMutableArray array];
    for (NSIndexPath *indexPath in _selection)
    {
        
        NSInteger correctSectionIndex = [indexPath indexAtPosition: 0];
        if (correctSectionIndex == fromSection)
        {
            correctSectionIndex = toSection;
        }
        else
        {
            
            if (fromSection < [indexPath indexAtPosition: 0])
            {
                --correctSectionIndex;
            }
            
            if (correctSectionIndex >= toSection)
            {
                ++correctSectionIndex;
            }
            
        }
        
        switch ([indexPath length])
        {
                
            case 1:
            {
                
                [selection addObject: [NSIndexPath indexPathWithIndex: correctSectionIndex]];
                
                break;
            }
                
            case 2:
            {
                
                [selection addObject: [NSIndexPath indexPathForThumbnail: [indexPath thumbnail]
                                                               inSection: correctSectionIndex]];
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
    }
    
    [_selection removeAllObjects];
    
    [_selection addObjectsFromArray: selection];
    
    _needRearrangement = YES;
    
    //[self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
    //                    draggingPlaceable: NO];
    
}

- (void)reloadData
{
    
    _needRearrangement = YES;
    
    [self clearSelection];
    
    for (NSIndexPath *indexPath in _thumbnails)
    {
        [[_thumbnails objectForKey: indexPath] removeFromSuperview];
    }
    
    [_thumbnails removeAllObjects];
    
    [_thumbnailLayouts removeAllObjects];
    
    [_preservedThumbnailIndexPaths removeAllObjects];
    
    [_selfManagedIndexPaths removeAllObjects];
    
    if ([_galleryView superview])
    {
        [self rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationNone
                             draggingPlaceable: NO];
    }
    
}

- (void)reloadThumbnailsAtIndexPaths: (NSArray *)indexPaths
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    
    _needRearrangement = YES;
    
    [self clearSelection];
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        [[_thumbnails objectForKey: indexPath] removeFromSuperview];
    }
    
    [_thumbnails removeObjectsForKeys: indexPaths];
    
    [_thumbnailLayouts removeObjectsForKeys: indexPaths];
    
    [_preservedThumbnailIndexPaths removeObjectsForKeys: indexPaths];
    
    [_selfManagedIndexPaths removeObjectsInArray: indexPaths];
    
    [self rearrangeThumbnailsWithAnimation: animation
                         draggingPlaceable: NO];
    
}

- (void)    reloadSections: (NSIndexSet *)sections
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    
    _needRearrangement = YES;
    
    [self clearSelection];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        if ([sections containsIndex: [indexPath indexAtPosition: 0]])
        {
            
            [[_thumbnails objectForKey: indexPath] removeFromSuperview];
            
            [indexPaths addObject: indexPath];
            
        }
        
    }
    
    [_thumbnails removeObjectsForKeys: indexPaths];
    
    [indexPaths removeAllObjects];
    
    for (NSIndexPath *indexPath in _thumbnailLayouts)
    {
        if ([sections containsIndex: [indexPath indexAtPosition: 0]])
        {
            [indexPaths addObject: indexPath];
        }
    }
    
    [_thumbnailLayouts removeObjectsForKeys: indexPaths];
    
    [indexPaths removeAllObjects];
    
    for (NSIndexPath *indexPath in _preservedThumbnailIndexPaths)
    {
        if ([sections containsIndex: [indexPath indexAtPosition: 0]])
        {
            [indexPaths addObject: indexPath];
        }
    }
    
    [_preservedThumbnailIndexPaths removeObjectsForKeys: indexPaths];
    
    [indexPaths removeAllObjects];
    
    for (NSIndexPath *indexPath in _selfManagedIndexPaths)
    {
        if ([sections containsIndex: [indexPath indexAtPosition: 0]])
        {
            [indexPaths addObject: indexPath];
        }
    }
    
    [_selfManagedIndexPaths removeObjectsInArray: indexPaths];
    
    [self rearrangeThumbnailsWithAnimation: animation
                         draggingPlaceable: NO];
    
}

- (void)reloadWithThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    
    _needRearrangement = YES;
    
    [self rearrangeThumbnailsWithAnimation: animation
                         draggingPlaceable: NO];
    
}

- (void)startScrollingTimer
{
    
    [_scrollingTimer invalidate];
    
    _scrollingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.025
                                                       target: self
                                                     selector: @selector(tryToScrollForDraggingActivatedBy:)
                                                     userInfo: nil
                                                      repeats: YES];
    
}

- (void)stopScrollingTimer
{
    
    [_scrollingTimer invalidate];
    
    _scrollingTimer = nil;
    
}

- (CGSize)sizeThatFits: (CGSize)size
{

    if (size.width > ERMachineFloatMeaningfulMaximum)
    {
        size.width = ERMachineFloatMeaningfulMaximum;
    }

    if (size.height > ERMachineFloatMeaningfulMaximum)
    {
        size.height = ERMachineFloatMeaningfulMaximum;
    }
    
    CGSize targetSize = size;
    
    if (targetSize.width > _targetContentSize.width)
    {
        targetSize.width = _targetContentSize.width;
    }
    
    if (targetSize.height > _targetContentSize.height)
    {
        targetSize.height = _targetContentSize.height;
    }
    
    return targetSize;
}

@end
