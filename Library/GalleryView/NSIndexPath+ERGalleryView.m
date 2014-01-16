#import "NSIndexPath+ERGalleryView.h"

@implementation NSIndexPath(ERGalleryView)

+ (NSIndexPath *)indexPathForThumbnail: (NSUInteger)thumbnailIndex
                             inSection: (NSUInteger)sectionIndex
{
    
    NSUInteger indexes[2] = {sectionIndex, thumbnailIndex};
    
    return [NSIndexPath indexPathWithIndexes: indexes
                                      length: 2];
    
}

- (NSUInteger)thumbnail
{
    return [self indexAtPosition: 1];
}

@end
