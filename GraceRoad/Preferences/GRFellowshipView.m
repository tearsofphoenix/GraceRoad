//
//  GRFellowshipView.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRFellowshipView.h"
#import "ERGalleryView.h"
#import "ERGalleryViewThumbnail.h"
#import "GRFellowshipCell.h"

@interface GRFellowshipView ()<ERGalleryViewDataSource, ERGalleryViewDelegate>

@property (nonatomic, strong) ERGalleryView *contentView;
@property (nonatomic, strong) NSArray *data;

@end


@implementation GRFellowshipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setData: @[
                         (@{
                            GRFellowshipNameKey : @"香柏树团契",
                            GRFellowshipAddressKey : @"三湘2期46号1401",
                            GRFellowshipPhoneKey : @"135-0162-5880",
                            }),
                         (@{
                            GRFellowshipNameKey : @"无花果树团契",
                            GRFellowshipAddressKey : @"月亮河桂园别墅53号",
                            GRFellowshipPhoneKey : @"130-0310-0418",
                            }),
                         (@{
                            GRFellowshipNameKey : @"皂荚树团契",
                            GRFellowshipAddressKey : @"建设花园79号301",
                            GRFellowshipPhoneKey : @"189-3064-8530",
                            }),
                         (@{
                            GRFellowshipNameKey : @"仁爱团契",
                            GRFellowshipAddressKey : @"御上海30号702",
                            GRFellowshipPhoneKey : @"139-1768-3163",
                            }),
                         (@{
                            GRFellowshipNameKey : @"以琳团契",
                            GRFellowshipAddressKey : @"泗泾金港花园二期66号202",
                            GRFellowshipPhoneKey : @"135-6556-9288",
                            }),
                         ]];
        
        [self setTitle: @"团契"];
        [self setHideTabbar: YES];
        
        _contentView = [[ERGalleryView alloc] initWithFrame: [self bounds]];
        [self addSubview: _contentView];
        
        [_contentView setDataSource: self];
        [_contentView setDelegate: self];
    }
    return self;
}

- (NSInteger)numberOfSectionsInGalleryView: (ERGalleryView *)galleryView
{
    return 2;
}

- (NSInteger)          galleryView: (ERGalleryView *)galleryView
numberOfThumbnailsInSectionAtIndex: (NSInteger)sectionIndex
{
    if (sectionIndex == 0)
    {
        return 3;
    }
    
    return 2;
}

- (ERGalleryViewThumbnail *)galleryView: (ERGalleryView *)galleryView
                   thumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    GRFellowshipCell *view = [[GRFellowshipCell alloc] initWithFrame: CGRectMake(0, 0, 100, 60)];
    
    NSInteger idx = [indexPath section] * [self numberOfSectionsInGalleryView: galleryView] + [indexPath row];
    
    NSDictionary *info = _data[idx];
    [view setInfo: info];
    
    return [view autorelease];
}

- (CGSize)      galleryView: (ERGalleryView *)galleryView
sizeForThumbnailAtIndexPath: (NSIndexPath *)indexPath
{
    return CGSizeMake(100, 200);
}

@end