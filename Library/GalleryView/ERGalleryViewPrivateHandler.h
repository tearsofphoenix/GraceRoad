//
//  ERGalleryViewPrivateHandler.h
//  NoahsScratch
//
//  Created by Minun Dragonation on 7/2/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "ERGalleryView.h"

typedef void (^ERGalleryViewIterator)(NSIndexPath *indexPath, 
                                      CGRect frame,
                                      BOOL fixed);

typedef CGSize (^ERGalleryViewArranger)(ERGalleryView *self, 
                                        BOOL draggingPlaceable,
                                        ERGalleryViewIterator iterator);

@interface ERGalleryViewPrivateHandler: NSObject<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) BOOL allowsSelection;

@property (nonatomic) BOOL allowsReordering;

@property (nonatomic) BOOL allowsMultipleSelection;

@property (nonatomic) BOOL allowsSelectionDuringEditing;

@property (nonatomic) BOOL allowsReorderingDuringEditing;

@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing;

- (id)    initWithGalleryView: (ERGalleryView *)galleryView
                   thumbnails: (NSMutableDictionary *)thumbnails
                    selection: (NSMutableArray *)selection
         panGestureRecognizer: (UIPanGestureRecognizer *)panGestureRecognizer
   longPressGestureRecognizer: (UILongPressGestureRecognizer *)longPressGestureRecognizer
         tapGestureRecognizer: (UITapGestureRecognizer *)tapGestureRecognizer
                     arranger: (ERGalleryViewArranger) arranger
             draggingPosition: (CGPoint *)draggingPosition
           draggingIndexPaths: (NSMutableArray *)draggingIndexPaths
      draggingTargetIndexPath: (NSIndexPath **)draggingTargetIndexPath;

- (void)requireFullRearrangement;

- (void)rearrangeThumbnailsWithAnimation: (ERGalleryViewThumbnailAnimation)animation
                       draggingPlaceable: (BOOL)draggingPlaceable;

- (void)panGestureRecognizedBy: (UIPanGestureRecognizer *)recognizer;

- (void)longPressGestureRecognizedBy: (UILongPressGestureRecognizer *)recognizer;

- (void)tapGestureRecognizedBy: (UITapGestureRecognizer *)recognizer;

- (NSIndexPath *)indexPathForSelectedThumbnail;

- (NSArray *)indexPathsForSelectedThumbnails;

- (void)selectThumbnailAtIndexPath: (NSIndexPath *)indexPath
                          animated: (BOOL)animated
                    scrollPosition: (ERGalleryViewScrollPosition)scrollPosition;

- (void)deselectThumbnailAtIndexPath: (NSIndexPath *)indexPath
                            animated: (BOOL)animated;

- (void)toggleThumbnailInSelectionAtIndexPath: (NSIndexPath *)indexPath
                                     animated: (BOOL)animated
                               scrollPosition: (ERGalleryViewScrollPosition)scrollPosition;

- (void)clearSelection;

- (void)beginUpdates;

- (void)endUpdates;

- (void)insertThumbnailsAtIndexPaths: (NSArray *)indexPaths 
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)deleteThumbnailsAtIndexPaths: (NSArray *)indexPaths 
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)moveThumbnailAtIndexPath: (NSIndexPath *)fromIndexPath 
                     toIndexPath: (NSIndexPath *)toIndexPath;

- (void)    insertSections: (NSArray *)sectionIndexes
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)    deleteSections: (NSArray *)sectionIndexes
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)moveSection: (NSInteger)fromSection
          toSection: (NSInteger)toSection;

- (void)reloadData;

- (void)reloadThumbnailsAtIndexPaths: (NSArray *)indexPaths 
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)    reloadSections: (NSIndexSet *)sections
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)reloadWithThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)startScrollingTimer;

- (void)stopScrollingTimer;

- (CGSize)sizeThatFits: (CGSize)size;

#pragma mark - Locating

- (NSIndexPath *)indexPathForThumbnailAtPoint: (CGPoint)location;

- (NSArray *)indexPathsForThumbnailInRect: (CGRect)rect;

- (CGRect)rectForSection: (NSInteger)section;

- (CGRect)rectForThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (CGRect)rectForHeaderInSection: (NSInteger)section;

- (CGRect)rectForFooterInSection: (NSInteger)section;

@end
