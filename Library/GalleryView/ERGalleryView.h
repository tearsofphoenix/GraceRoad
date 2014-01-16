//
//  ERGalleryView.h
//  NoahsScratch
//
//  Created by Minun Dragonation on 6/30/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ERGalleryViewDelegate.h"

typedef enum
{
    ERGalleryViewStylePlain,
    ERGalleryViewStyleGrouped
}
ERGalleryViewStyle;

typedef enum
{
    ERGalleryViewArrangementDirectionHorizontal,
    ERGalleryViewArrangementDirectionVertical
}
ERGalleryViewArrangementDirection;

typedef enum 
{
    ERGalleryViewScrollPositionNone,
    ERGalleryViewScrollPositionHead,
    ERGalleryViewScrollPositionBody,
    ERGalleryViewScrollPositionFoot
} 
ERGalleryViewScrollPosition;

typedef enum
{
    ERGalleryViewThumbnailAnimationNone,
    ERGalleryViewThumbnailAnimationFade,
    ERGalleryViewThumbnailAnimationZoom,
    ERGalleryViewThumbnailAnimationAutomatic = 100
} 
ERGalleryViewThumbnailAnimation;

@protocol ERGalleryViewDataSource;

@class ERGalleryViewPrivateHandler;
@class ERGalleryViewThumbnail;

@interface ERGalleryView: UIScrollView
{
    
    BOOL _deallocated;
    
    ERGalleryViewStyle _style;
    ERGalleryViewArrangementDirection _arrangementDirection;
    
    BOOL _editing;
    
    ERGalleryViewPrivateHandler *_handler;
    
    NSMutableDictionary *_thumbnails;
    
    NSMutableArray *_selection;
    
    id<ERGalleryViewDelegate> _galleryViewDelegate;
    
    id<ERGalleryViewDataSource> _dataSource;
    
    CGSize _thumbnailSize;
    CGFloat _sectionHeaderWeight;
    CGFloat _sectionFooterWeight;
    
    UIView *_galleryHeaderView;
    CGFloat _galleryHeaderViewWeight;
    
    UIView *_galleryFooterView;
    CGFloat _galleryFooterViewWeight;
    
    CGPoint _draggingPosition;
    NSMutableArray *_draggingIndexPaths;
    NSIndexPath *_draggingTargetIndexPath;
    
    UIPanGestureRecognizer *_panGestureRecognizer;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    UITapGestureRecognizer *_tapGestureRecognizer;
    
    CGSize _lastSize;
    
    UIView *_backgroundView;
    
    BOOL _reloaded;
    
}

#pragma mark - Behavior

@property (nonatomic, retain) UIView *backgroundView;

@property (nonatomic) ERGalleryViewStyle style;

@property (nonatomic) ERGalleryViewArrangementDirection arrangementDirection;

@property (nonatomic) CGSize thumbnailSize;

@property (nonatomic) CGFloat sectionHeaderWeight;

@property (nonatomic) CGFloat sectionFooterWeight;

@property (nonatomic, strong) UIView *galleryHeaderView;

@property (nonatomic) CGFloat galleryHeaderViewWeight;

@property (nonatomic, strong) UIView *galleryFooterView;

@property (nonatomic) CGFloat galleryFooterViewWeight;

- (void)setGalleryHeaderViewWeight: (CGFloat)galleryHeaderViewWeight 
                          animated: (BOOL)animated;

- (void)setGalleryFooterViewWeight: (CGFloat)galleryFooterViewWeight 
                          animated: (BOOL)animated;

#pragma mark - Data source

@property (nonatomic, weak) IBOutlet id<ERGalleryViewDataSource> dataSource;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfThumbnailsInSectionAtIndex: (NSInteger)sectionIndex;

- (ERGalleryViewThumbnail *)thumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (UIView *)headerViewForSection: (NSInteger)section;

- (UIView *)footerViewForSection: (NSInteger)section;

#pragma mark - Delegate 

@property (nonatomic, weak) IBOutlet id<ERGalleryViewDelegate> delegate;

- (CGFloat)weightForHeaderOfSection: (NSInteger)section;

- (CGFloat)weightForFooterOfSection: (NSInteger)section;

- (CGSize)sizeForThumbnailAtIndexPath: (NSIndexPath *)indexPath;

#pragma mark - Thumbnails

- (NSIndexPath *)indexPathForThumbnail: (ERGalleryViewThumbnail *)thumbnail;

- (NSIndexPath *)indexPathForThumbnailAtPoint: (CGPoint)location;

- (NSArray *)indexPathsForThumbnailInRect: (CGRect)rect;

- (NSArray *)visibleThumbnails;

- (NSArray *)indexPathsForVisibleThumbnails;

#pragma mark - Selection

@property (nonatomic) BOOL allowsSelection;

@property (nonatomic) BOOL allowsReordering;

@property (nonatomic) BOOL allowsMultipleSelection;

@property (nonatomic) BOOL allowsSelectionDuringEditing;

@property (nonatomic) BOOL allowsReorderingDuringEditing;

@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing;

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

#pragma mark - Scrolling

- (void)scrollToSectionAtIndex: (NSInteger)sectionIndex
              atScrollPosition: (ERGalleryViewScrollPosition)scrollPosition
                      animated: (BOOL)animated;

- (void)scrollToThumbnailAtIndexPath: (NSIndexPath *)indexPath 
                    atScrollPosition: (ERGalleryViewScrollPosition)scrollPosition
                            animated: (BOOL)animated;

#pragma mark - Editing

@property (nonatomic) BOOL editing;

- (void)setEditing: (BOOL)editing animated: (BOOL)animated;

#pragma mark - Updating

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

- (void)automaticallyUpdateForNewData: (NSArray *)newData
                            replacing: (NSArray *)oldData
             identifierCollectionPath: (NSString *)collectinoPath;

#pragma mark - Reloading

- (void)reloadData;

- (void)reloadThumbnailsAtIndexPaths: (NSArray *)indexPaths 
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)    reloadSections: (NSIndexSet *)sections
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

- (void)reloadWithThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation;

#pragma mark - Locating

- (CGRect)rectForSection: (NSInteger)section;

- (CGRect)rectForThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (CGRect)rectForHeaderInSection: (NSInteger)section;

- (CGRect)rectForFooterInSection: (NSInteger)section;

#pragma mark - Dropping

- (void)beginDroppingWithScrolling: (BOOL)scrolling;

- (NSIndexPath *)rearrangeForDroppingAtLocation: (CGPoint)location
                                      canceling: (BOOL)canceling;

- (void)endDroppingSucceeded: (BOOL)succeeded;

@end
