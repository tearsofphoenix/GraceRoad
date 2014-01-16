//
//  ERGalleryViewDataSource.h
//  NoahsScratch
//
//  Created by Minun Dragonation on 6/30/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ERGalleryViewThumbnailEditingStyleNone,
    ERGalleryViewThumbnailEditingStyleDelete
} ERGalleryViewThumbnailEditingStyle;

@class ERGalleryView;
@class ERGalleryViewThumbnail;

@protocol ERGalleryViewDataSource<NSObject>

@required

- (NSInteger)              galleryView: (ERGalleryView *)galleryView
    numberOfThumbnailsInSectionAtIndex: (NSInteger)sectionIndex;

- (ERGalleryViewThumbnail *)galleryView: (ERGalleryView *)galleryView
                   thumbnailAtIndexPath: (NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInGalleryView: (ERGalleryView *)galleryView;

- (UIView *)galleryView: (ERGalleryView *)galleryView
   headerViewForSection: (NSInteger)section;

- (UIView *)galleryView: (ERGalleryView *)galleryView
   footerViewForSection: (NSInteger)section;

- (void)        galleryView: (ERGalleryView *)galleryView
         commitEditingStyle: (ERGalleryViewThumbnailEditingStyle)thumbnailEditingStyle
    forThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (BOOL)            galleryView: (ERGalleryView *)galleryView
    canEditThumbnailAtIndexPath: (NSIndexPath *)indexPath;

- (BOOL)                galleryView: (ERGalleryView *)galleryView
      canMoveThumbnailsAtIndexPaths: (NSArray *)indexPaths;

- (void)             galleryView: (ERGalleryView *)galleryView
      moveThumbnailsAtIndexPaths: (NSArray *)fromIndexPaths
                     toIndexPath: (NSIndexPath *)toIndexPath;

@end
