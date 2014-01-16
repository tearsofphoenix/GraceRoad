//
//  ERGalleryViewDelegate.h
//  NoahsScratch
//
//  Created by Minun Dragonation on 6/30/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ERGalleryViewDataSource.h"

@class ERGalleryView;

@class ERGalleryViewThumbnail;

@protocol ERGalleryViewDelegate<UIScrollViewDelegate>

@optional

- (CGFloat)      galleryView: (ERGalleryView *)galleryView
    weightForHeaderOfSection: (NSInteger)section;

- (CGFloat)      galleryView: (ERGalleryView *)galleryView
    weightForFooterOfSection: (NSInteger)section;

- (CGSize)          galleryView: (ERGalleryView *)galleryView
    sizeForThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (void)        galleryView: (ERGalleryView *)galleryView
       willDisplayThumbnail: (ERGalleryViewThumbnail *)thumbnail
    forThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (void)               galleryView: (ERGalleryView *)galleryView
    willSelectThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (void)              galleryView: (ERGalleryView *)galleryView
    didSelectThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (void)                 galleryView: (ERGalleryView *)galleryView
    willDeselectThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (void)                galleryView: (ERGalleryView *)galleryView
    didDeselectThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (void)galleryView: (ERGalleryView *)galleryView
   selectionChanged: (NSArray *)selection;

- (ERGalleryViewThumbnailEditingStyle)galleryView: (ERGalleryView *)galleryView
              editingStyleForThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (NSString *)                                  galleryView: (ERGalleryView *)galleryView
    titleForDeleteConfirmationButtonForThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (void)                        galleryView: (ERGalleryView *)galleryView
    willBeginDraggingThumbnailsAtIndexPaths: (NSArray *)indexPaths;

- (void)                       galleryView: (ERGalleryView *)galleryView
    didBeginDraggingThumbnailsAtIndexPaths: (NSArray *)indexPaths;

- (BOOL)           galleryView: (ERGalleryView *)galleryView
    dragThumbnailsAtIndexPaths: (NSArray *)indexPaths
                    toLocation: (CGPoint)location;

- (BOOL)              galleryView: (ERGalleryView *)galleryView
      couldThumbnailsAtIndexPaths: (NSArray *)indexPaths
              beDraggedOnLocation: (CGPoint)location;

- (void)                         galleryView: (ERGalleryView *)galleryView
    willEndDraggingForThumbnailsAtIndexPaths: (NSArray *)indexPaths
                                    location: (CGPoint)location;

- (void)                        galleryView: (ERGalleryView *)galleryView
    didEndDraggingForThumbnailsAtIndexPaths: (NSArray *)indexPaths
                                   location: (CGPoint)location;

- (void)galleryView: (ERGalleryView *)galleryView
    didTapEmptyArea: (UITapGestureRecognizer *)tapGestureRecognizer;


@end
