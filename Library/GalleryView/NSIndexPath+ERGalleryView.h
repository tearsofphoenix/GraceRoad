#import <Foundation/Foundation.h>

@interface NSIndexPath (ERGalleryView)

+ (NSIndexPath *)indexPathForThumbnail: (NSUInteger)thumbnailIndex
                             inSection: (NSUInteger)sectionIndex;

- (NSUInteger)thumbnail;

@end
