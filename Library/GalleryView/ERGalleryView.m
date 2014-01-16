//
//  ERGalleryView.m
//  NoahsScratch
//
//  Created by Minun Dragonation on 6/30/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERGalleryView.h"

#import <objc/runtime.h>

#import <NoahsUtility/NoahsUtility.h>

#import "ERGalleryViewDelegate.h"
#import "ERGalleryViewDataSource.h"

#import "ERGalleryViewPrivateHandler.h"

#import "NSIndexPath+ERGalleryView.h"

#import "ERGalleryViewThumbnail.h"

extern char ERGalleryViewThumbnailGalleryViewKey;

#pragma mark - TODO: fix the incorrect dragging thumbnail position for variable size

static CGSize ERGalleryViewLoopForEveryThumbnail(ERGalleryView *self, 
                                                 ERGalleryViewStyle style,
                                                 BOOL draggingPlaceable,
                                                 NSArray *draggingIndexPaths,
                                                 CGPoint draggingPosition,
                                                 NSIndexPath **draggingTargetIndexPath,
                                                 ERGalleryViewIterator iterator)
{
    
    BOOL draggingProcessed = draggingPlaceable;
    
    CGSize draggingSize = CGSizeMake(0, 0);
    if ([draggingIndexPaths count])
    {
        draggingSize = [self sizeForThumbnailAtIndexPath: [draggingIndexPaths objectAtIndex: 0]];
    }
    
    CGRect layoutSituation;
    switch ([self arrangementDirection])
    {
            
        case ERGalleryViewArrangementDirectionHorizontal:
        {
            
            layoutSituation = CGRectMake([self galleryHeaderViewWeight], 0, 0, 0);
            
            break;
        }
            
        case ERGalleryViewArrangementDirectionVertical:
        {
            
            layoutSituation = CGRectMake(0, [self galleryHeaderViewWeight], 0, 0);

            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
    CGRect bounds = [self bounds];
    
    if (draggingPosition.x < bounds.origin.x)
    {
        draggingPosition.x = bounds.origin.x;
    }
    else if (draggingPosition.x > bounds.origin.x + bounds.size.width)
    {
        draggingPosition.x = bounds.origin.x + bounds.size.width;
    }
    
    if (draggingPosition.y < bounds.origin.y)
    {
        draggingPosition.y = bounds.origin.y;
    }
    else if (draggingPosition.y > bounds.origin.y + bounds.size.height)
    {
        draggingPosition.y = bounds.origin.y + bounds.size.height;
    }
    
    NSInteger sectionCount = [self numberOfSections];
    
    NSUInteger sectionLooper = 0;
    while (sectionLooper < sectionCount)
    {
        
        CGFloat sectionX = 0;
        CGFloat sectionY = 0;
        
        switch ([self arrangementDirection])
        {
                
            case ERGalleryViewArrangementDirectionHorizontal:
            {
                
                sectionX = layoutSituation.origin.x + layoutSituation.size.width;
                sectionY = 0;
                
                CGFloat weight = [self weightForHeaderOfSection: sectionLooper];
                
                layoutSituation.origin.y = 0;
                layoutSituation.origin.x += layoutSituation.size.width + weight;
                
                if ([draggingIndexPaths count] && 
                    (!draggingProcessed) && 
                    (CGRectContainsPoint(CGRectMake(sectionX, sectionY, weight, bounds.size.height), draggingPosition) || 
                     (draggingPosition.x < sectionX)))
                {
                    
                    draggingProcessed = YES;
                    
                    [*draggingTargetIndexPath release];
                    
                    *draggingTargetIndexPath = [NSIndexPath indexPathForThumbnail: 0 inSection: sectionLooper];
                    
                    [*draggingTargetIndexPath retain];
                    
                    if (layoutSituation.origin.y + draggingSize.height > bounds.origin.y + bounds.size.height)
                    {
                        layoutSituation.origin.y = bounds.origin.y + draggingSize.height;
                        layoutSituation.origin.x += layoutSituation.size.width;
                        layoutSituation.size.width = draggingSize.width;
                    }
                    else
                    {
                        layoutSituation.origin.y += draggingSize.height;
                        if (layoutSituation.size.width < draggingSize.width)
                        {
                            layoutSituation.size.width = draggingSize.width;
                        }
                    }
                    
                }
                
                break;
            }
                
            case ERGalleryViewArrangementDirectionVertical:
            {
                
                sectionX = 0;
                sectionY = layoutSituation.origin.y + layoutSituation.size.height;
                
                CGFloat weight = [self weightForHeaderOfSection: sectionLooper];
                
                layoutSituation.origin.x = 0;
                layoutSituation.origin.y += layoutSituation.size.height + weight;
                
                if ([draggingIndexPaths count] && 
                    (!draggingProcessed) && 
                    (CGRectContainsPoint(CGRectMake(sectionX, sectionY, bounds.size.width, weight), draggingPosition) ||
                     (draggingPosition.y < sectionY)))
                {
                    
                    draggingProcessed = YES;
                    
                    [*draggingTargetIndexPath release];
                    
                    *draggingTargetIndexPath = [NSIndexPath indexPathForThumbnail: 0 inSection: sectionLooper];
                    
                    [*draggingTargetIndexPath retain];
                    
                    if (layoutSituation.origin.x + draggingSize.width > bounds.origin.x + bounds.size.width)
                    {
                        layoutSituation.origin.x = bounds.origin.x + draggingSize.width;
                        layoutSituation.origin.y += layoutSituation.size.height;
                        layoutSituation.size.height = draggingSize.height;
                    }
                    else
                    {
                        layoutSituation.origin.x += draggingSize.width;
                        if (layoutSituation.size.height < draggingSize.height)
                        {
                            layoutSituation.size.height = draggingSize.height;
                        }
                    }
                    
                }
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
        NSInteger thumbnailCount = [self numberOfThumbnailsInSectionAtIndex: sectionLooper];
        
        NSUInteger thumbnailLooper = 0;
        while (thumbnailLooper < thumbnailCount)
        {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForThumbnail: thumbnailLooper
                                                              inSection: sectionLooper];
            
            if (![draggingIndexPaths containsObject: indexPath])
            {
                
                CGSize size = [self sizeForThumbnailAtIndexPath: indexPath];
                
                switch ([self arrangementDirection])
                {
                        
                    case ERGalleryViewArrangementDirectionHorizontal:
                    {
                        
                        CGRect frame;
                        if (layoutSituation.origin.y + size.height > bounds.origin.y + bounds.size.height)
                        {
                            frame = CGRectMake(layoutSituation.origin.x + layoutSituation.size.width, 
                                               0, 
                                               size.width, 
                                               size.height);
                        }
                        else
                        {
                            frame = CGRectMake(layoutSituation.origin.x, 
                                               layoutSituation.origin.y, 
                                               size.width, 
                                               size.height);
                        }
                        
                        if ([draggingIndexPaths count] && 
                            (!draggingProcessed) && 
                            (CGRectContainsPoint(frame, draggingPosition)))
                        {
                            
                            draggingProcessed = YES;
                            
                            [*draggingTargetIndexPath release];
                            
                            NSInteger correctThumbnailIndex = thumbnailLooper;
                            for (NSIndexPath *indexPath in draggingIndexPaths)
                            {
                                if (([indexPath section] == sectionLooper) && 
                                    ([indexPath thumbnail] < thumbnailLooper))
                                {
                                    --correctThumbnailIndex;
                                }
                            }
                            *draggingTargetIndexPath = [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                inSection: sectionLooper];
                            
                            [*draggingTargetIndexPath retain];
                            
                            if (layoutSituation.origin.y + draggingSize.height > bounds.origin.y + bounds.size.height)
                            {
                                layoutSituation.origin.y = bounds.origin.y + draggingSize.height;
                                layoutSituation.origin.x += layoutSituation.size.width;
                                layoutSituation.size.width = draggingSize.width;
                            }
                            else
                            {
                                layoutSituation.origin.y += draggingSize.height;
                                if (layoutSituation.size.width < draggingSize.width)
                                {
                                    layoutSituation.size.width = draggingSize.width;
                                }
                            }
                            
                        }
                        
                        if (layoutSituation.origin.y + size.height > bounds.origin.y + bounds.size.height)
                        {
                            
                            CGRect frame = CGRectMake(layoutSituation.origin.x + layoutSituation.size.width, 
                                                      0, 
                                                      size.width, 
                                                      size.height);
                            
                            if (iterator)
                            {
                                iterator(indexPath, frame, NO);
                            }
                            
                            layoutSituation.origin.y = bounds.origin.y + size.height;
                            layoutSituation.origin.x += layoutSituation.size.width;
                            layoutSituation.size.width = size.width;
                            
                        }
                        else
                        {
                            
                            CGRect frame = CGRectMake(layoutSituation.origin.x, 
                                                      layoutSituation.origin.y, 
                                                      size.width, 
                                                      size.height);
                            
                            if (iterator)
                            {
                                iterator(indexPath, frame, NO);
                            }
                            
                            layoutSituation.origin.y += size.height;
                            if (layoutSituation.size.width < size.width)
                            {
                                layoutSituation.size.width = size.width;
                            }
                            
                        }
                        
                        break;
                    }
                        
                    case ERGalleryViewArrangementDirectionVertical:
                    {
                        
                        CGRect frame;
                        
                        if (layoutSituation.origin.x + size.width > bounds.origin.x + bounds.size.width)
                        {
                            frame = CGRectMake(0,
                                               layoutSituation.origin.y + layoutSituation.size.height, 
                                               size.width, 
                                               size.height);
                        }
                        else
                        {
                            frame = CGRectMake(layoutSituation.origin.x, 
                                               layoutSituation.origin.y, 
                                               size.width, 
                                               size.height);
                        }
                        
                        if ([draggingIndexPaths count] && 
                            (!draggingProcessed) && 
                            CGRectContainsPoint(frame, draggingPosition))
                        {
                            
                            draggingProcessed = YES;
                            
                            [*draggingTargetIndexPath release];
                            
                            NSInteger correctThumbnailIndex = thumbnailLooper;
                            for (NSIndexPath *indexPath in draggingIndexPaths)
                            {
                                if (([indexPath section] == sectionLooper) && 
                                    ([indexPath thumbnail] < thumbnailLooper))
                                {
                                    --correctThumbnailIndex;
                                }
                            }
                            *draggingTargetIndexPath = [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                                inSection: sectionLooper];
                            
                            [*draggingTargetIndexPath retain];
                            
                            if (layoutSituation.origin.x + draggingSize.width > bounds.origin.x + bounds.size.width)
                            {
                                layoutSituation.origin.x = bounds.origin.x + draggingSize.width;
                                layoutSituation.origin.y += layoutSituation.size.height;
                                layoutSituation.size.height = draggingSize.height;
                            }
                            else
                            {
                                layoutSituation.origin.x += draggingSize.width;
                                if (layoutSituation.size.height < draggingSize.height)
                                {
                                    layoutSituation.size.height = draggingSize.height;
                                }
                            }
                            
                        }
                        
                        if (layoutSituation.origin.x + size.width > bounds.origin.x + bounds.size.width)
                        {
                            
                            CGRect frame = CGRectMake(0,
                                                      layoutSituation.origin.y + layoutSituation.size.height, 
                                                      size.width, 
                                                      size.height);
                            
                            if (iterator)
                            {
                                iterator(indexPath, frame, NO);
                            }
                            
                            layoutSituation.origin.x = bounds.origin.x + size.width;
                            layoutSituation.origin.y += layoutSituation.size.height;
                            layoutSituation.size.height = size.height;
                            
                        }
                        else
                        {
                            
                            CGRect frame = CGRectMake(layoutSituation.origin.x, 
                                                      layoutSituation.origin.y, 
                                                      size.width, 
                                                      size.height);
                            
                            if (iterator)
                            {
                                iterator(indexPath, frame, NO);
                            }
                            
                            layoutSituation.origin.x += size.width;
                            if (layoutSituation.size.height < size.height)
                            {
                                layoutSituation.size.height = size.height;
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
            
            ++thumbnailLooper;
        }
        
        switch ([self arrangementDirection])
        {
                
            case ERGalleryViewArrangementDirectionHorizontal:
            {
                
                CGFloat weight = [self weightForHeaderOfSection: sectionLooper];
                
                if ([draggingIndexPaths count] && 
                    (!draggingProcessed) && 
                    (CGRectContainsPoint(CGRectMake(layoutSituation.origin.x + layoutSituation.size.width, 
                                                    sectionY,
                                                    weight, 
                                                    bounds.size.height), draggingPosition) ||
                     (draggingPosition.x < layoutSituation.origin.x + layoutSituation.size.width) ||
                     ((draggingPosition.x >= layoutSituation.origin.x + layoutSituation.size.width) && 
                      (sectionLooper == sectionCount - 1))))
                {
                    
                    draggingProcessed = YES;
                    
                    [*draggingTargetIndexPath release];
                    
                    NSInteger correctThumbnailIndex = thumbnailCount;
                    for (NSIndexPath *indexPath in draggingIndexPaths)
                    {
                        if (([indexPath section] == sectionLooper) && 
                            ([indexPath thumbnail] < thumbnailCount))
                        {
                            --correctThumbnailIndex;
                        }
                    }
                    *draggingTargetIndexPath = [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                        inSection: sectionLooper];
                    
                    [*draggingTargetIndexPath retain];
                    
                    if (layoutSituation.origin.y + draggingSize.height > bounds.origin.y + bounds.size.height)
                    {
                        layoutSituation.origin.y = bounds.origin.y + draggingSize.height;
                        layoutSituation.origin.x += layoutSituation.size.width;
                        layoutSituation.size.width = draggingSize.width;
                    }
                    else
                    {
                        layoutSituation.origin.y += draggingSize.height;
                        if (layoutSituation.size.width < draggingSize.width)
                        {
                            layoutSituation.size.width = draggingSize.width;
                        }
                    }
                    
                }
                
                BOOL fixed = NO;
                if (([self style] == ERGalleryViewStylePlain) &&
                    (sectionX < bounds.origin.x) &&
                    (layoutSituation.origin.x + layoutSituation.size.width > bounds.origin.x))
                {
                    
                    sectionX = layoutSituation.origin.x + layoutSituation.size.width - weight;
                    if (sectionX >  bounds.origin.x)
                    {
                        sectionX = bounds.origin.x;
                    }
                    
                    fixed = YES;
                    
                }
                
                if (iterator)
                {
                    iterator([NSIndexPath indexPathWithIndex: sectionLooper], 
                             CGRectMake(sectionX, sectionY, weight, bounds.size.height), fixed);
                }
                
                weight = [self weightForFooterOfSection: sectionLooper];
                if (iterator)
                {
                    iterator([NSIndexPath indexPathForThumbnail: thumbnailLooper
                                                      inSection: sectionLooper],
                             CGRectMake(layoutSituation.origin.x + layoutSituation.size.width, 
                                        sectionY,
                                        weight, 
                                        bounds.size.height), NO);
                }
                
                layoutSituation.origin.y = 0;
                layoutSituation.origin.x = layoutSituation.origin.x + layoutSituation.size.width + weight;
                layoutSituation.size.width = 0;
                
                break;
            }
                
            case ERGalleryViewArrangementDirectionVertical:
            {
                
                CGFloat weight = [self weightForHeaderOfSection: sectionLooper];
                
                if ([draggingIndexPaths count] && 
                    (!draggingProcessed) && 
                    (CGRectContainsPoint(CGRectMake(sectionX, 
                                                    layoutSituation.origin.y + layoutSituation.size.height, 
                                                    bounds.size.width, 
                                                    weight), draggingPosition) || 
                     (draggingPosition.y < layoutSituation.origin.y + layoutSituation.size.height) ||
                     ((draggingPosition.y >= layoutSituation.origin.y + layoutSituation.size.height) && 
                      (sectionLooper == sectionCount - 1))))
                {
                    
                    draggingProcessed = YES;
                    
                    [*draggingTargetIndexPath release];
                    
                    NSInteger correctThumbnailIndex = thumbnailCount;
                    for (NSIndexPath *indexPath in draggingIndexPaths)
                    {
                        if (([indexPath section] == sectionLooper) && 
                            ([indexPath thumbnail] < thumbnailCount))
                        {
                            --correctThumbnailIndex;
                        }
                    }
                    *draggingTargetIndexPath = [NSIndexPath indexPathForThumbnail: correctThumbnailIndex
                                                                        inSection: sectionLooper];
                    
                    [*draggingTargetIndexPath retain];
                    
                    if (layoutSituation.origin.x + draggingSize.width > bounds.origin.x + bounds.size.width)
                    {
                        layoutSituation.origin.x = bounds.origin.x + draggingSize.width;
                        layoutSituation.origin.y += layoutSituation.size.height;
                        layoutSituation.size.height = draggingSize.height;
                    }
                    else
                    {
                        layoutSituation.origin.x += draggingSize.width;
                        if (layoutSituation.size.height < draggingSize.height)
                        {
                            layoutSituation.size.height = draggingSize.height;
                        }
                    }
                    
                }
                
                BOOL fixed = NO;
                if (([self style] == ERGalleryViewStylePlain) &&
                    (sectionY < bounds.origin.y) && 
                    (layoutSituation.origin.y + layoutSituation.size.height > bounds.origin.y))
                {
                    
                    sectionY = layoutSituation.origin.y + layoutSituation.size.height - weight;
                    if (sectionY >  bounds.origin.y)
                    {
                        sectionY = bounds.origin.y;
                    }
                    
                    fixed = YES;
                    
                }
                
                if (iterator)
                {
                    iterator([NSIndexPath indexPathWithIndex: sectionLooper], 
                             CGRectMake(sectionX, sectionY, bounds.size.width, weight), fixed);
                }
                
                weight = [self weightForFooterOfSection: sectionLooper];
                if (iterator)
                {
                    iterator([NSIndexPath indexPathForThumbnail: thumbnailLooper
                                                      inSection: sectionLooper],
                             CGRectMake(sectionX, 
                                        layoutSituation.origin.y + layoutSituation.size.height, 
                                        bounds.size.width, 
                                        weight), NO);
                }
                
                layoutSituation.origin.x = 0;
                layoutSituation.origin.y = layoutSituation.origin.y + layoutSituation.size.height + weight;
                layoutSituation.size.height = 0;
                
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
        ++sectionLooper;
    }
    
    switch ([self arrangementDirection])
    {
            
        case ERGalleryViewArrangementDirectionHorizontal:
        {
            
            return CGSizeMake(layoutSituation.origin.x + layoutSituation.size.width + [self galleryFooterViewWeight], 
                              bounds.size.height);
            
            break;
        }
            
        case ERGalleryViewArrangementDirectionVertical:
        {
            
            return CGSizeMake(bounds.size.width, 
                              layoutSituation.origin.y + layoutSituation.size.height + [self galleryFooterViewWeight]);
            
            break;
        }
            
        default:
        {
            
            return CGSizeMake(layoutSituation.origin.x + layoutSituation.size.width, 
                              layoutSituation.origin.y + layoutSituation.size.height);
            
            break;
        }
            
    }
    
}

@implementation ERGalleryView

- (id)initWithCoder: (NSCoder *)decoder
{
    
    self = [super initWithCoder: decoder];
    if (self)
    {
        
        _deallocated = NO;
        
        _thumbnails = [[NSMutableDictionary alloc] init];
        
        _selection = [[NSMutableArray alloc] init];
        
        _thumbnailSize = CGSizeMake(100, 100);
        
        _sectionHeaderWeight = 40;
        _sectionFooterWeight = 0;
        
        ERGalleryViewArranger arranger = (^CGSize(ERGalleryView *self,
                                                  BOOL draggingPlaceable,
                                                  ERGalleryViewIterator iterator)
                                          {
                                              return ERGalleryViewLoopForEveryThumbnail(self,
                                                                                        self->_style,
                                                                                        draggingPlaceable,
                                                                                        self->_draggingIndexPaths,
                                                                                        self->_draggingPosition,
                                                                                        &self->_draggingTargetIndexPath,
                                                                                        iterator);
                                          });
        
        _draggingIndexPaths = [[NSMutableArray alloc] init];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        
        _handler = [[ERGalleryViewPrivateHandler alloc] initWithGalleryView: self
                                                                 thumbnails: _thumbnails
                                                                  selection: _selection
                                                       panGestureRecognizer: _panGestureRecognizer
                                                 longPressGestureRecognizer: _longPressGestureRecognizer
                                                       tapGestureRecognizer: _tapGestureRecognizer
                                                                   arranger: arranger
                                                           draggingPosition: &_draggingPosition
                                                         draggingIndexPaths: _draggingIndexPaths
                                                    draggingTargetIndexPath: &_draggingTargetIndexPath];
        
        
        _reloaded = YES;
        
        [super setDelegate: _handler];
        
        [_panGestureRecognizer setMaximumNumberOfTouches: 1];
        [_panGestureRecognizer addTarget: _handler
                                  action: @selector(panGestureRecognizedBy:)];
        [self addGestureRecognizer: _panGestureRecognizer];
        [_panGestureRecognizer setDelegate: _handler];
        [_panGestureRecognizer release];
        
        [_longPressGestureRecognizer addTarget: _handler
                                        action: @selector(longPressGestureRecognizedBy:)];
        
        [[self panGestureRecognizer] requireGestureRecognizerToFail: _longPressGestureRecognizer];
        
        [self addGestureRecognizer: _longPressGestureRecognizer];
        [_longPressGestureRecognizer setDelegate: _handler];
        [_longPressGestureRecognizer release];
        [_longPressGestureRecognizer setEnabled: NO];
        
        [_tapGestureRecognizer addTarget: _handler
                                  action: @selector(tapGestureRecognizedBy:)];
        
        [self addGestureRecognizer: _tapGestureRecognizer];
        [_tapGestureRecognizer setDelegate: _handler];
        [_tapGestureRecognizer release];
        
    }
    
    return self;
}

- (id)initWithFrame: (CGRect)frame
{
    
    self = [super initWithFrame: frame];
    if (self)
    {
        
        _deallocated = NO;
        
        _thumbnails = [[NSMutableDictionary alloc] init];
        
        _selection = [[NSMutableArray alloc] init];
        
        _thumbnailSize = CGSizeMake(100, 100);
        
        _sectionHeaderWeight = 40;
        _sectionFooterWeight = 0;
        
        ERGalleryViewArranger arranger = (^CGSize(ERGalleryView *self,
                                                  BOOL draggingPlaceable,
                                                  ERGalleryViewIterator iterator)
                                          {
                                              return ERGalleryViewLoopForEveryThumbnail(self,
                                                                                        self->_style,
                                                                                        draggingPlaceable,
                                                                                        self->_draggingIndexPaths,
                                                                                        self->_draggingPosition,
                                                                                        &self->_draggingTargetIndexPath,
                                                                                        iterator);
                                          });
        
        _draggingIndexPaths = [[NSMutableArray alloc] init];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        
        _handler = [[ERGalleryViewPrivateHandler alloc] initWithGalleryView: self
                                                                 thumbnails: _thumbnails
                                                                  selection: _selection
                                                       panGestureRecognizer: _panGestureRecognizer
                                                 longPressGestureRecognizer: _longPressGestureRecognizer
                                                       tapGestureRecognizer: _tapGestureRecognizer
                                                                   arranger: arranger
                                                           draggingPosition: &_draggingPosition
                                                         draggingIndexPaths: _draggingIndexPaths
                                                    draggingTargetIndexPath: &_draggingTargetIndexPath];
        
        
        _reloaded = YES;
        
        [super setDelegate: _handler];

        [_panGestureRecognizer setMaximumNumberOfTouches: 1];
        [_panGestureRecognizer addTarget: _handler
                                  action: @selector(panGestureRecognizedBy:)];
        [self addGestureRecognizer: _panGestureRecognizer];
        [_panGestureRecognizer setDelegate: _handler];
        [_panGestureRecognizer release];
        
        [_longPressGestureRecognizer addTarget: _handler
                                        action: @selector(longPressGestureRecognizedBy:)];
        
        [[self panGestureRecognizer] requireGestureRecognizerToFail: _longPressGestureRecognizer];
        
        [self addGestureRecognizer: _longPressGestureRecognizer];
        [_longPressGestureRecognizer setDelegate: _handler];
        [_longPressGestureRecognizer release];
        [_longPressGestureRecognizer setEnabled: NO];
        
        [_tapGestureRecognizer addTarget: _handler
                                  action: @selector(tapGestureRecognizedBy:)];
        
        [self addGestureRecognizer: _tapGestureRecognizer];
        [_tapGestureRecognizer setDelegate: _handler];
        [_tapGestureRecognizer release];
        
    }
    
    return self;
}
- (void)dealloc
{
    
    _deallocated = YES;

    _dataSource = nil;
    
    [self setDelegate: nil];
    
    [_draggingTargetIndexPath release];
    
    [_draggingIndexPaths release];
    
    [_handler release];
    
    [_selection release];
    
    [_thumbnails release];
    
    [super dealloc];
}

#pragma mark - Inheriting

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    CGSize newSize = [self bounds].size;
    
    if (_reloaded || (!CGSizeEqualToSize(newSize, _lastSize)))
    {
        
        _reloaded = NO;
        
        _lastSize = newSize;
        
        [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationNone
                                 draggingPlaceable: NO];
    }
    
}

#pragma mark - Behavior

@synthesize style = _style;

@synthesize editing = _editing;

@synthesize arrangementDirection = _arrangementDirection;

@synthesize thumbnailSize = _thumbnailSize;

@synthesize sectionHeaderWeight = _sectionHeaderWeight;

@synthesize sectionFooterWeight = _sectionFooterWeight;

@synthesize galleryHeaderView = _galleryHeaderView;

@synthesize galleryHeaderViewWeight = _galleryHeaderViewWeight;

@synthesize galleryFooterView = _galleryFooterView;

@synthesize galleryFooterViewWeight = _galleryFooterViewWeight;

@synthesize backgroundView = _backgroundView;

- (BOOL)allowsReordering
{
    return [_handler allowsReordering];
}

- (void)setAllowsReordering: (BOOL)allowsReordering
{
    
    if (allowsReordering && (!_editing))
    {
        [_longPressGestureRecognizer setEnabled: YES];
    }
    else 
    {
        [_longPressGestureRecognizer setEnabled: NO];
    }
    
    [_handler setAllowsReordering: allowsReordering];
}

- (BOOL)allowsReorderingDuringEditing
{
    return [_handler allowsReorderingDuringEditing];
}

- (void)setAllowsReorderingDuringEditing: (BOOL)allowsReorderingDuringEditing
{
    
    if (allowsReorderingDuringEditing && _editing)
    {
        [_longPressGestureRecognizer setEnabled: YES];
    }
    else
    {
        [_longPressGestureRecognizer setEnabled: NO];
    }
    
    [_handler setAllowsReorderingDuringEditing: allowsReorderingDuringEditing];
}

- (void)setArrangementDirection: (ERGalleryViewArrangementDirection)arrangementDirection
{
    
    _arrangementDirection = arrangementDirection;
    
    [self reloadData];
    
}

- (void)setBackgroundView: (UIView *)backgroundView
{
    
    [_backgroundView removeFromSuperview];
    
    [self addSubview: backgroundView];
    
    [self sendSubviewToBack: backgroundView];
    
}

- (void)setEditing: (BOOL)editing
{
    [self setEditing: editing animated: NO];
}

- (void)setEditing: (BOOL)editing animated: (BOOL)animated
{
    
    _editing = editing;
    if ((editing && [_handler allowsReorderingDuringEditing]) ||
        ((!editing) && [_handler allowsReordering]))
    {
        [_longPressGestureRecognizer setEnabled: YES];
    }
    else
    {
        [_longPressGestureRecognizer setEnabled: NO];
    }
    
    for (NSIndexPath *indexPath in _thumbnails)
    {
        
        if (([indexPath length] == 2) &&
            ([indexPath thumbnail] < [self numberOfThumbnailsInSectionAtIndex: [indexPath section]]))
        {
            
            ERGalleryViewThumbnail *thumbnail = [_thumbnails objectForKey: indexPath];
            if (thumbnail)
            {
                
                ERGalleryViewThumbnailStateMask stateMask = ERGalleryViewThumbnailStateDefaultMask;
                
                if (_editing)
                {
                    
                    ERGalleryViewThumbnailEditingStyle style = ERGalleryViewThumbnailEditingStyleDelete;
                    if ([[self delegate] respondsToSelector: @selector(galleryView:editingStyleForThumbnailAtIndexPath:)])
                    {
                        style = [[self delegate] galleryView: self
                         editingStyleForThumbnailAtIndexPath: indexPath];
                    }
                    
                    switch (style)
                    {
                            
                        case ERGalleryViewThumbnailEditingStyleNone:
                        {
                            
                            stateMask = ERGalleryViewThumbnailStateDefaultMask;
                            
                            break;
                        }
                            
                        case ERGalleryViewThumbnailEditingStyleDelete:
                        {
                            
                            stateMask = ERGalleryViewThumbnailStateShowingDeleteButtonMask;
                            
                            break;
                        }
                            
                        default:
                        {
                            break;
                        }
                            
                    }
                    
                }
                
                [thumbnail willTransitionToState: stateMask];
                
                [thumbnail didTransitionToState: stateMask];
                
                [thumbnail setEditing: editing
                             animated: animated];
                
            }
            
        }
        
    }
    
}

- (void)setGalleryHeaderView: (UIView *)galleryHeaderView
{
    
    [_galleryHeaderView removeFromSuperview];
    
    _galleryHeaderView = galleryHeaderView;
    
    [self addSubview: _galleryHeaderView];
    
    [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                             draggingPlaceable: YES];
    
}

- (void)setGalleryFooterView: (UIView *)galleryFooterView
{
    
    [_galleryFooterView removeFromSuperview];
    
    _galleryFooterView = galleryFooterView;
    
    [self addSubview: _galleryFooterView];
    
    [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                             draggingPlaceable: YES];
    
}

- (void)setGalleryHeaderViewWeight: (CGFloat)galleryHeaderViewWeight 
{
    [self setGalleryHeaderViewWeight: galleryHeaderViewWeight 
                            animated: NO];
}

- (void)setGalleryFooterViewWeight: (CGFloat)galleryFooterViewWeight 
{
    [self setGalleryFooterViewWeight: galleryFooterViewWeight
                            animated: NO];
}

- (void)setGalleryHeaderViewWeight: (CGFloat)galleryHeaderViewWeight 
                          animated: (BOOL)animated
{
    
    _galleryHeaderViewWeight = galleryHeaderViewWeight;
    
    if (animated)
    {
        [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                                 draggingPlaceable: YES];
    }
    else
    {
        [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationNone
                                 draggingPlaceable: YES];
    }
    
}

- (void)setGalleryFooterViewWeight: (CGFloat)galleryFooterViewWeight 
                          animated: (BOOL)animated
{
    
    _galleryFooterViewWeight = galleryFooterViewWeight;
    
    if (animated)
    {
        [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                                 draggingPlaceable: YES];
    }
    else
    {
        [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationNone
                                 draggingPlaceable: YES];
    }
    
}

#pragma mark - Data source

@synthesize dataSource = _dataSource;

- (void)setDataSource: (id<ERGalleryViewDataSource>)dataSource
{
    
    if (!_deallocated)
    {
        
        _dataSource = dataSource;
        
        _reloaded = YES;
        
        [self reloadData];
        
    }
    
}

- (NSInteger)numberOfSections
{
    
    if ([_dataSource respondsToSelector: @selector(numberOfSectionsInGalleryView:)])
    {
        return [_dataSource numberOfSectionsInGalleryView: self];
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)numberOfThumbnailsInSectionAtIndex: (NSInteger)sectionIndex
{
    
    return [_dataSource galleryView: self
 numberOfThumbnailsInSectionAtIndex: sectionIndex];
    
}

- (ERGalleryViewThumbnail *)thumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    
    if (([indexPath length] == 2) && 
        ([indexPath thumbnail] < [self numberOfThumbnailsInSectionAtIndex: [indexPath indexAtPosition: 0]]))
    {
        
        ERGalleryViewThumbnail *thumbnail = [_thumbnails objectForKey: indexPath];
        if (!thumbnail)
        {
            
            thumbnail = [_dataSource galleryView: self
                            thumbnailAtIndexPath: indexPath];
            if (thumbnail)
            {
                
                objc_setAssociatedObject(thumbnail, 
                                         &ERGalleryViewThumbnailGalleryViewKey, 
                                         self, 
                                         OBJC_ASSOCIATION_ASSIGN);
                
                [thumbnail setSelected: [_selection containsObject: indexPath]];
                
                ERGalleryViewThumbnailStateMask stateMask = ERGalleryViewThumbnailStateDefaultMask;
                
                if (_editing)
                {
                    
                    ERGalleryViewThumbnailEditingStyle style = ERGalleryViewThumbnailEditingStyleDelete;
                    if ([[self delegate] respondsToSelector: @selector(galleryView:editingStyleForThumbnailAtIndexPath:)])
                    {
                        style = [[self delegate] galleryView: self
                         editingStyleForThumbnailAtIndexPath: indexPath];
                    }
                    
                    switch (style)
                    {
                            
                        case ERGalleryViewThumbnailEditingStyleNone:
                        {
                            
                            stateMask = ERGalleryViewThumbnailStateDefaultMask;
                            
                            break;
                        }
                            
                        case ERGalleryViewThumbnailEditingStyleDelete:
                        {
                            
                            stateMask = ERGalleryViewThumbnailStateShowingDeleteButtonMask;
                            
                            break;
                        }
                            
                        default:
                        {
                            break;
                        }
                            
                    }
                    
                }                
                
                [thumbnail willTransitionToState: stateMask];
                
                [thumbnail didTransitionToState: stateMask];
                
                [thumbnail setEditing: _editing];

                [_thumbnails setObject: thumbnail forKey: indexPath];
                
            }
            
        }
        
        return thumbnail;
        
    }
    else
    {
        return nil;
    }
    
}

- (UIView *)headerViewForSection: (NSInteger)section
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex: section];
    UIView *headerView = [_thumbnails objectForKey: indexPath];
    if (!headerView)
    {
        
        if ([_dataSource respondsToSelector: @selector(galleryView:headerViewForSection:)])
        {
            
            headerView = [_dataSource galleryView: self
                             headerViewForSection: section];
            if (headerView)
            {
                [_thumbnails setObject: headerView forKey: indexPath];
            }
            
        }
        
    }
    
    return headerView;
}

- (UIView *)footerViewForSection: (NSInteger)section
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForThumbnail: [self numberOfThumbnailsInSectionAtIndex: section]
                                                      inSection: section];
    UIView *footerView = [_thumbnails objectForKey: indexPath];
    if (!footerView)
    {
        
        if ([_dataSource respondsToSelector: @selector(galleryView:footerViewForSection:)])
        {
            
            footerView = [_dataSource galleryView: self
                             footerViewForSection: section];
            if (footerView)
            {
                [_thumbnails setObject: footerView forKey: indexPath];
            }
            
        }
        
    }
    
    return footerView;    
}

#pragma mark - Delegate 

@synthesize delegate = _galleryViewDelegate;

- (void)setDelegate:(id<ERGalleryViewDelegate>)delegate
{
    
    if (!_deallocated)
    {
        
        _galleryViewDelegate = delegate;
        
        _reloaded = YES;
        
        [self reloadData];
            
    }
    
}

- (CGFloat)weightForHeaderOfSection: (NSInteger)section
{
    
    if ([_galleryViewDelegate respondsToSelector: @selector(galleryView:weightForHeaderOfSection:)])
    {
        return [_galleryViewDelegate galleryView: self
                        weightForHeaderOfSection: section];
    }
    else
    {
        
        if ([_dataSource respondsToSelector: @selector(numberOfSectionsInGalleryView:)] &&
            [_dataSource numberOfSectionsInGalleryView: self])
        {
            return [self sectionHeaderWeight];
        }
        else
        {
            return 0;
        }
        
    }
    
}

- (CGFloat)weightForFooterOfSection: (NSInteger)section
{
    
    if ([_galleryViewDelegate respondsToSelector: @selector(galleryView:weightForFooterOfSection:)])
    {
        return [_galleryViewDelegate galleryView: self
                        weightForFooterOfSection: section];
    }
    else
    {
        
        if ([_dataSource respondsToSelector: @selector(numberOfSectionsInGalleryView:)] &&
            [_dataSource numberOfSectionsInGalleryView: self])
        {
            return [self sectionFooterWeight];
        }
        else
        {
            return 0;
        }
        
    }
    
}

- (CGSize)sizeForThumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    
    if ([_galleryViewDelegate respondsToSelector: @selector(galleryView:sizeForThumbnailAtIndexPath:)])
    {
        return [_galleryViewDelegate galleryView: self
                     sizeForThumbnailAtIndexPath: indexPath];
    }
    else
    {
        return [self thumbnailSize];
    }
    
}

#pragma mark - Thumbnails

- (NSIndexPath *)indexPathForThumbnail: (ERGalleryViewThumbnail *)thumbnail
{
    
    NSArray *keys = [_thumbnails allKeysForObject: thumbnail];
    if ([keys count])
    {
        
        NSIndexPath *key = [keys objectAtIndex: 0];
        if (([key length] == 2) && 
            ([key thumbnail] < [self numberOfThumbnailsInSectionAtIndex: [key indexAtPosition: 0]]))
        {
            return key;
        }
        else
        {
            return nil;
        }
        
    }
    else
    {
        return nil;
    }
    
}

- (NSIndexPath *)indexPathForThumbnailAtPoint: (CGPoint)location
{
    return [_handler indexPathForThumbnailAtPoint: location];
}

- (NSArray *)indexPathsForThumbnailInRect: (CGRect)rect
{
    return [_handler indexPathsForThumbnailInRect: rect];
}

- (NSArray *)visibleThumbnails
{
    
    NSMutableArray *thumbnails = [NSMutableArray array];
    for (NSIndexPath *indexPath in [self indexPathsForVisibleThumbnails])
    {
        [thumbnails addObject: [_thumbnails objectForKey: indexPath]];
    }
    
    return thumbnails;
}

- (NSArray *)indexPathsForVisibleThumbnails
{
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    NSArray *keys = [_thumbnails allKeys];
    for (NSIndexPath *key in keys)
    {
        
        if (([key length] == 2) && 
            ([key thumbnail] < [self numberOfThumbnailsInSectionAtIndex: [key indexAtPosition: 0]]))
        {
            [indexPaths addObject: key];
        }
        
    }
    
    return indexPaths;
}

#pragma mark - Selection

- (BOOL)allowsSelection
{
    return [_handler allowsSelection];
}

- (void)setAllowsSelection: (BOOL)allowsSelection
{
    [_handler setAllowsSelection: allowsSelection];
}

- (BOOL)allowsMultipleSelection
{
    return [_handler allowsMultipleSelection];
}

- (void)setAllowsMultipleSelection: (BOOL)allowsMultipleSelection
{
    [_handler setAllowsMultipleSelection: allowsMultipleSelection];
}

- (BOOL)allowsSelectionDuringEditing
{
    return [_handler allowsSelectionDuringEditing];
}

- (void)setAllowsSelectionDuringEditing: (BOOL)allowsSelectionDuringEditing
{
    [_handler setAllowsSelectionDuringEditing: allowsSelectionDuringEditing];
}

- (BOOL)allowsMultipleSelectionDuringEditing
{
    return [_handler allowsMultipleSelectionDuringEditing];
}

- (void)setAllowsMultipleSelectionDuringEditing: (BOOL)allowsMultipleSelectionDuringEditing
{
    [_handler setAllowsMultipleSelectionDuringEditing: allowsMultipleSelectionDuringEditing];
}

- (NSIndexPath *)indexPathForSelectedThumbnail
{
    return [_handler indexPathForSelectedThumbnail];
}

- (NSArray *)indexPathsForSelectedThumbnails
{
    return [_handler indexPathsForSelectedThumbnails];
}

- (void)selectThumbnailAtIndexPath: (NSIndexPath *)indexPath
                          animated: (BOOL)animated
                    scrollPosition: (ERGalleryViewScrollPosition)scrollPosition
{
    [_handler selectThumbnailAtIndexPath: indexPath
                                animated: animated
                          scrollPosition: scrollPosition];
}

- (void)deselectThumbnailAtIndexPath: (NSIndexPath *)indexPath
                            animated: (BOOL)animated
{
    [_handler deselectThumbnailAtIndexPath: indexPath
                                  animated: animated];
}

- (void)toggleThumbnailInSelectionAtIndexPath: (NSIndexPath *)indexPath
                                     animated: (BOOL)animated
                               scrollPosition: (ERGalleryViewScrollPosition)scrollPosition
{
    [_handler toggleThumbnailInSelectionAtIndexPath: indexPath
                                           animated: animated
                                     scrollPosition: scrollPosition];
}

- (void)clearSelection
{
    [_handler clearSelection];
}

#pragma mark - Scrolling

- (void)scrollToSectionAtIndex: (NSInteger)sectionIndex
              atScrollPosition: (ERGalleryViewScrollPosition)scrollPosition
                      animated: (BOOL)animated
{
    
    CGRect rect = [self rectForSection: sectionIndex];
    
    CGRect bounds = [self bounds];
    
    switch (scrollPosition)
    {
            
        case ERGalleryViewScrollPositionNone:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    if ((rect.origin.x < bounds.origin.x) && 
                        (rect.origin.x + rect.size.width < bounds.origin.x + bounds.size.width))
                    {
                        
                        CGFloat x = rect.origin.x;
                        if (x > [self contentSize].width - bounds.size.width)
                        {
                            x = [self contentSize].width - bounds.size.width;
                        }
                        
                        if (x < 0)
                        {
                            x = 0;
                        }
                        
                        [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                      animated: animated];
                        
                    }
                    else if ((rect.origin.x > bounds.origin.x) &&
                             (rect.origin.x + rect.size.width > bounds.origin.x + bounds.size.width))
                    {
                        
                        CGFloat x = rect.origin.x - bounds.size.width + rect.size.width;
                        if (x > [self contentSize].width - bounds.size.width)
                        {
                            x = [self contentSize].width - bounds.size.width;
                        }
                        
                        if (x < 0)
                        {
                            x = 0;
                        }
                        
                        [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                      animated: animated];
                        
                    }
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    if ((rect.origin.y < bounds.origin.y) && 
                        (rect.origin.y + rect.size.height < bounds.origin.y + bounds.size.height))
                    {
                        
                        CGFloat y = rect.origin.y;
                        if (y > [self contentSize].height - bounds.size.height)
                        {
                            y = [self contentSize].height - bounds.size.height;
                        }
                        
                        if (y < 0)
                        {
                            y = 0;
                        }
                        
                        [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                      animated: animated];
                        
                    }
                    else if ((rect.origin.y > bounds.origin.y) &&
                             (rect.origin.y + rect.size.height > bounds.origin.y + bounds.size.height))
                    {
                        
                        CGFloat y = rect.origin.y - bounds.size.height + rect.size.height;
                        if (y > [self contentSize].height - bounds.size.height)
                        {
                            y = [self contentSize].height - bounds.size.height;
                        }
                        
                        if (y < 0)
                        {
                            y = 0;
                        }
                        
                        [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                      animated: animated];
                        
                    }
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
        case ERGalleryViewScrollPositionHead:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    CGFloat x = rect.origin.x;
                    if (x > [self contentSize].width - bounds.size.width)
                    {
                        x = [self contentSize].width - bounds.size.width;
                    }
                    
                    if (x < 0)
                    {
                        x = 0;
                    }
                    
                    [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                  animated: animated];
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    CGFloat y = rect.origin.y;
                    if (y > [self contentSize].height - bounds.size.height)
                    {
                        y = [self contentSize].height - bounds.size.height;
                    }
                    
                    if (y < 0)
                    {
                        y = 0;
                    }
                    
                    [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                  animated: animated];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
        case ERGalleryViewScrollPositionBody:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    CGFloat x = rect.origin.x + rect.size.width / 2;
                    if (x > [self contentSize].width - bounds.size.width)
                    {
                        x = [self contentSize].width - bounds.size.width;
                    }
                    
                    if (x < 0)
                    {
                        x = 0;
                    }
                    
                    [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                  animated: animated];
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    CGFloat y = rect.origin.y + rect.size.height / 2;
                    if (y > [self contentSize].height - bounds.size.height)
                    {
                        y = [self contentSize].height - bounds.size.height;
                    }
                    
                    if (y < 0)
                    {
                        y = 0;
                    }
                    
                    [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                  animated: animated];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
        case ERGalleryViewScrollPositionFoot:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    CGFloat x = rect.origin.x - bounds.size.width + rect.size.width;
                    if (x > [self contentSize].width - bounds.size.width)
                    {
                        x = [self contentSize].width - bounds.size.width;
                    }
                    
                    if (x < 0)
                    {
                        x = 0;
                    }
                    
                    [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                  animated: animated];
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    CGFloat y = rect.origin.y - bounds.size.height + rect.size.height;
                    if (y > [self contentSize].height - bounds.size.height)
                    {
                        y = [self contentSize].height - bounds.size.height;
                    }
                    
                    if (y < 0)
                    {
                        y = 0;
                    }
                    
                    [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                  animated: animated];
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
    }
    
}

- (void)scrollToThumbnailAtIndexPath: (NSIndexPath *)indexPath 
                    atScrollPosition: (ERGalleryViewScrollPosition)scrollPosition
                            animated: (BOOL)animated
{
    
    CGRect rect = [self rectForThumbnailAtIndexPath: indexPath];
    
    CGRect bounds = [self bounds];
    
    UIEdgeInsets contentInsets = [self contentInset];
    
    switch (scrollPosition)
    {
            
        case ERGalleryViewScrollPositionNone:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    if (bounds.size.width < [self contentSize].width + contentInsets.left + contentInsets.right)
                    {
                        
                        if ((rect.origin.x < bounds.origin.x + contentInsets.left) &&
                            (rect.origin.x + rect.size.width < bounds.origin.x + bounds.size.width - contentInsets.right))
                        {
                            
                            CGFloat x = rect.origin.x;
                            if (x > [self contentSize].width - bounds.size.width + contentInsets.right)
                            {
                                x = [self contentSize].width - bounds.size.width + contentInsets.right;
                            }
                            
                            if (x < -contentInsets.left)
                            {
                                x = -contentInsets.left;
                            }
                            
                            [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                          animated: animated];
                            
                        }
                        else if ((rect.origin.x > bounds.origin.x + contentInsets.left) &&
                                 (rect.origin.x + rect.size.width > bounds.origin.x + bounds.size.width - contentInsets.right))
                        {
                            
                            CGFloat x = rect.origin.x - bounds.size.width + rect.size.width + contentInsets.right;
                            if (x > [self contentSize].width - bounds.size.width + contentInsets.right)
                            {
                                x = [self contentSize].width - bounds.size.width + contentInsets.right;
                            }
                            
                            if (x < -contentInsets.left)
                            {
                                x = -contentInsets.left;
                            }
                            
                            [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                          animated: animated];
                            
                        }
                        
                    }
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    if (bounds.size.height < [self contentSize].height + contentInsets.top + contentInsets.bottom)
                    {
                        
                        if ((rect.origin.y < bounds.origin.y + contentInsets.top) &&
                            (rect.origin.y + rect.size.height < bounds.origin.y + bounds.size.height - contentInsets.bottom))
                        {
                            
                            CGFloat y = rect.origin.y;
                            if (y > [self contentSize].height - bounds.size.height + contentInsets.bottom)
                            {
                                y = [self contentSize].height - bounds.size.height + contentInsets.bottom;
                            }
                            
                            if (y < -contentInsets.top)
                            {
                                y = -contentInsets.top;
                            }
                            
                            [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                          animated: animated];
                            
                        }
                        else if ((rect.origin.y > bounds.origin.y + contentInsets.top) &&
                                 (rect.origin.y + rect.size.height > bounds.origin.y + bounds.size.height - contentInsets.bottom))
                        {
                            
                            CGFloat y = rect.origin.y - bounds.size.height + rect.size.height + contentInsets.bottom;
                            if (y > [self contentSize].height - bounds.size.height + contentInsets.bottom)
                            {
                                y = [self contentSize].height - bounds.size.height + contentInsets.bottom;
                            }
                            
                            if (y < -contentInsets.top)
                            {
                                y = -contentInsets.top;
                            }
                            
                            [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                          animated: animated];
                            
                        }
                        
                    }
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
        case ERGalleryViewScrollPositionHead:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    if (bounds.size.width < [self contentSize].width + contentInsets.left + contentInsets.right)
                    {
                        
                        CGFloat x = rect.origin.x;
                        if (x > [self contentSize].width - bounds.size.width + contentInsets.right)
                        {
                            x = [self contentSize].width - bounds.size.width + contentInsets.right;
                        }
                        
                        if (x < -contentInsets.left)
                        {
                            x = -contentInsets.left;
                        }
                        
                        [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                      animated: animated];
                        
                    }
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    if (bounds.size.height < [self contentSize].height + contentInsets.top + contentInsets.bottom)
                    {
                        
                        CGFloat y = rect.origin.y;
                        if (y > [self contentSize].height - bounds.size.height + contentInsets.bottom)
                        {
                            y = [self contentSize].height - bounds.size.height + contentInsets.bottom;
                        }
                        
                        if (y < -contentInsets.top)
                        {
                            y = -contentInsets.top;
                        }
                        
                        [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                      animated: animated];
                        
                    }
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
        case ERGalleryViewScrollPositionBody:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    if (bounds.size.width < [self contentSize].width + contentInsets.left + contentInsets.right)
                    {
                        
                        CGFloat x = rect.origin.x + rect.size.width / 2 - bounds.size.width / 2 + contentInsets.right / 2;
                        if (x > [self contentSize].width - bounds.size.width + contentInsets.right)
                        {
                            x = [self contentSize].width - bounds.size.width + contentInsets.right;
                        }
                        
                        if (x < -contentInsets.left)
                        {
                            x = -contentInsets.left;
                        }
                        
                        [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                      animated: animated];
                        
                    }
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    if (bounds.size.height < [self contentSize].height + contentInsets.bottom + contentInsets.top)
                    {
                    
                        CGFloat y = rect.origin.y + rect.size.height / 2 - bounds.size.height / 2 + contentInsets.bottom / 2;
                        if (y > [self contentSize].height - bounds.size.height + contentInsets.bottom)
                        {
                            y = [self contentSize].height - bounds.size.height + contentInsets.bottom;
                        }
                        
                        if (y < -contentInsets.top)
                        {
                            y = -contentInsets.top;
                        }
                        
                        [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                      animated: animated];
                    
                    }
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
        case ERGalleryViewScrollPositionFoot:
        {
            
            switch (_arrangementDirection)
            {
                    
                case ERGalleryViewArrangementDirectionHorizontal:
                {
                    
                    if (bounds.size.width < [self contentSize].width + contentInsets.left + contentInsets.right)
                    {
                        
                        CGFloat x = rect.origin.x - bounds.size.width + rect.size.width + contentInsets.right;
                        if (x > [self contentSize].width - bounds.size.width + contentInsets.right)
                        {
                            x = [self contentSize].width - bounds.size.width + contentInsets.right;
                        }
                        
                        if (x < -contentInsets.left)
                        {
                            x = -contentInsets.left;
                        }
                        
                        [self setContentOffset: CGPointMake(x, bounds.origin.y)
                                      animated: animated];
                        
                    }
                    
                    break;
                }
                    
                case ERGalleryViewArrangementDirectionVertical:
                {
                    
                    if (bounds.size.height < [self contentSize].height + contentInsets.top + contentInsets.bottom)
                    {
                        
                        CGFloat y = rect.origin.y - bounds.size.height + rect.size.height + contentInsets.bottom;
                        if (y > [self contentSize].height - bounds.size.height + contentInsets.bottom)
                        {
                            y = [self contentSize].height - bounds.size.height + contentInsets.bottom;
                        }
                        
                        if (y < -contentInsets.top)
                        {
                            y = -contentInsets.top;
                        }
                        
                        [self setContentOffset: CGPointMake(bounds.origin.x, y)
                                      animated: animated];
                        
                    }
                    
                    break;
                }
                    
                default:
                {
                    break;
                }
                    
            }
            
            break;
        }
            
    }
    
}

#pragma mark - Updating

- (void)beginUpdates
{
    [_handler beginUpdates];
}

- (void)endUpdates
{
    [_handler endUpdates];
}

- (void)insertThumbnailsAtIndexPaths: (NSArray *)indexPaths 
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    [_handler insertThumbnailsAtIndexPaths: indexPaths
                    withThumbnailAnimation: animation];
}

- (void)deleteThumbnailsAtIndexPaths: (NSArray *)indexPaths 
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    [_handler deleteThumbnailsAtIndexPaths: indexPaths
                    withThumbnailAnimation: animation];
}

- (void)moveThumbnailAtIndexPath: (NSIndexPath *)fromIndexPath 
                     toIndexPath: (NSIndexPath *)toIndexPath
{
    [_handler moveThumbnailAtIndexPath: fromIndexPath
                           toIndexPath: toIndexPath];
}

- (void)    insertSections: (NSArray *)sectionIndexes
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    [_handler insertSections: sectionIndexes
      withThumbnailAnimation: animation];
}

- (void)    deleteSections: (NSArray *)sectionIndexes
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    [_handler deleteSections: sectionIndexes
      withThumbnailAnimation: animation];
}

- (void)moveSection: (NSInteger)fromSection
          toSection: (NSInteger)toSection
{
    [_handler moveSection: fromSection
                toSection: toSection];
}

- (void)automaticallyUpdateForNewData: (NSArray *)newData
                            replacing: (NSArray *)oldData
             identifierCollectionPath: (NSString *)collectionPath
{
    
    [self beginUpdates];
    
    newData = [newData objectAtIndex: 0];
    oldData = [oldData objectAtIndex: 0];
    
    NSMutableArray *oldIdentifiers = [[oldData arrayForObjectsAtCollectionPathOfElements: collectionPath] mutableCopy];
    
    NSArray *newIdentifiers = [newData arrayForObjectsAtCollectionPathOfElements: collectionPath];
    
    NSMutableIndexSet *indicesShouldDelete = [NSMutableIndexSet indexSet];
    NSMutableArray *indexPathsShouldDelete = [NSMutableArray array];
    
    [oldData enumerateObjectsUsingBlock:
     (^(id object, NSUInteger index, BOOL *stop)
      {
          
          id identifier = [object objectOrNilForKey: collectionPath];
          
          if (![newIdentifiers containsObject: identifier])
          {
              
              [indicesShouldDelete addIndex: index];
              
              [indexPathsShouldDelete addObject: [NSIndexPath indexPathForThumbnail: index
                                                                          inSection: 0]];
              
          }
          
      })];
    
    [oldIdentifiers removeObjectsAtIndexes: indicesShouldDelete];
    
    [self deleteThumbnailsAtIndexPaths: indexPathsShouldDelete
                withThumbnailAnimation: ERGalleryViewThumbnailAnimationAutomatic];
    
    [newData enumerateObjectsUsingBlock:
     (^(id object, NSUInteger index, BOOL *stop)
      {
          
          ERUUID *identifier = [object objectOrNilForKey: collectionPath];
          
          NSUInteger oldIndex = [oldIdentifiers indexOfObject: identifier];
          if (oldIndex == NSNotFound)
          {
              
              [oldIdentifiers insertObject: identifier
                                   atIndex: index];
              
              [self insertThumbnailsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForThumbnail: index
                                                                                                     inSection: 0]]
                          withThumbnailAnimation: ERGalleryViewThumbnailAnimationAutomatic];
              
          }
          else if (oldIndex != index)
          {
              
              [oldIdentifiers removeObjectAtIndex: oldIndex];
              
              [oldIdentifiers insertObject: identifier atIndex: index];
              
              [self moveThumbnailAtIndexPath: [NSIndexPath indexPathForThumbnail: oldIndex
                                                                       inSection: 0]
                                 toIndexPath: [NSIndexPath indexPathForThumbnail: index
                                                                       inSection: 0]];
              
          }
          
      })];
    
    [oldIdentifiers release];
    
    [self endUpdates];
    
}

#pragma mark - Reloading

- (void)reloadData
{
    
    if (!_deallocated)
    {
        [_handler reloadData];
    }
    
}

- (void)reloadThumbnailsAtIndexPaths: (NSArray *)indexPaths
              withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    [_handler reloadThumbnailsAtIndexPaths: indexPaths
                    withThumbnailAnimation: animation];
}

- (void)    reloadSections: (NSIndexSet *)sections
    withThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    [_handler reloadSections: sections
      withThumbnailAnimation: animation];
}

- (void)reloadWithThumbnailAnimation: (ERGalleryViewThumbnailAnimation)animation
{
    [_handler reloadWithThumbnailAnimation: animation];
}

#pragma mark - Locating

- (CGRect)rectForSection: (NSInteger)section
{
    return [_handler rectForSection: section];
}

- (CGRect)rectForThumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    return [_handler rectForThumbnailAtIndexPath: indexPath];
}

- (CGRect)rectForHeaderInSection: (NSInteger)section
{
    return [_handler rectForHeaderInSection: section];
}

- (CGRect)rectForFooterInSection: (NSInteger)section
{
    return [_handler rectForFooterInSection: section];
}

#pragma mark - Dropping

- (void)beginDroppingWithScrolling: (BOOL)scrolling
{
    
    if (scrolling)
    {
        [_handler startScrollingTimer];
    }
    
    [_draggingIndexPaths removeAllObjects];
    
    [_draggingIndexPaths addObject: [NSIndexPath indexPathForThumbnail: 0
                                                             inSection: [self numberOfSections]]];
    
}

- (NSIndexPath *)rearrangeForDroppingAtLocation: (CGPoint)location 
                                      canceling: (BOOL)canceling
{
    
    _draggingPosition = location;
    
    [_handler requireFullRearrangement];
    
    [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                             draggingPlaceable: canceling];
    
    return _draggingTargetIndexPath;
}

- (void)endDroppingSucceeded: (BOOL)succeeded
{
    
    [_handler stopScrollingTimer];
    
    [_draggingIndexPaths removeAllObjects];
    
    [_handler requireFullRearrangement];
    
    if (succeeded)
    {

        [self beginUpdates];
        
        [self insertThumbnailsAtIndexPaths: [NSArray arrayWithObject: _draggingTargetIndexPath]
                    withThumbnailAnimation: ERGalleryViewThumbnailAnimationAutomatic];
        
        [self endUpdates];
        
    }
    else
    {
        [_handler rearrangeThumbnailsWithAnimation: ERGalleryViewThumbnailAnimationAutomatic
                                 draggingPlaceable: NO];
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [_handler sizeThatFits: size];
}

@end
