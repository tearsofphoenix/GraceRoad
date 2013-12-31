//
//  GRDataService.m
//  GraceRoad
//
//  Created by Mac003 on 13-12-31.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#import "GRDataService.h"
#import "GRResourceKey.h"
#import <NoahsUtility/NoahsUtility.h>

@interface GRDataService ()
{
    NSMutableArray *_resourceCategories;
    NSMutableDictionary *_resources;
}
@end

@implementation GRDataService

+ (void)load
{
    [self registerServiceClass: self];
}

+ (NSString *)serviceIdentifier
{
    return GRDataServiceID;
}

- (id)init
{
    if ((self = [super init]))
    {
        _resourceCategories = [[NSMutableArray alloc] init];
        _resources = [[NSMutableDictionary alloc] init];
        
        NSDictionary *typeLooper = (@{
                                      GRResourceCategoryName : @"每周作业",
                                      GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                                      });
        [_resourceCategories addObject: typeLooper];
        
        NSDate *date = [NSDate date];
        NSInteger year = [date year];
        NSInteger month = [date month];
        NSInteger day = [date day];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第一周作业",
                                     GRResourceAbstract : @"作业的内容是...",
                                     GRResourcePath : @"1.pdf",
                                     GRResourceUploadDate : date,
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第二周作业",
                                     GRResourceAbstract : @"这是一份作业...",
                                     GRResourcePath : @"2.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 1],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"第三周作业",
                                     GRResourceAbstract : @"需要好好做...",
                                     GRResourcePath : @"3.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 1],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        typeLooper = (@{
                        GRResourceCategoryName : @"CEF培训",
                        GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                        });
        [_resourceCategories addObject: typeLooper];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"无字书",
                                     GRResourceAbstract : @"怎样向儿童传福音？",
                                     GRResourcePath : @"cef1.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 2],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"金句教导",
                                     GRResourceAbstract : @"需要让孩子能记住...",
                                     GRResourcePath : @"cef2.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 2],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"圣经故事",
                                     GRResourceAbstract : @"怎样在圣经故事中穿插福音信息...",
                                     GRResourcePath : @"cef3.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 3],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
        
        typeLooper = (@{
                        GRResourceCategoryName : @"福音手册",
                        GRResourceCategoryID : [[ERUUID UUID] stringDescription],
                        });
        [_resourceCategories addObject: typeLooper];
        
        [_resources setObject: (@[
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"传福音的使命",
                                     GRResourceAbstract : @"来自圣经的教导，耶稣的吩咐",
                                     GRResourcePath : @"fuyin1.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 3],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  (@{
                                     GRResourceID : [[ERUUID UUID] stringDescription],
                                     GRResourceName : @"怎样传福音",
                                     GRResourceAbstract : @"把福音的要义告诉第一次听到的人",
                                     GRResourcePath : @"fuyin2.pdf",
                                     GRResourceUploadDate : [NSDate dateWithYear: year
                                                                           month: month
                                                                             day: day - 4],
                                     GRResourceTypeName : GRResourceTypePDF,
                                     }),
                                  ])
                       forKey: typeLooper[GRResourceCategoryID]];
    }
    
    return self;
}

- (NSDictionary *)allResources
{
    return _resources;
}

- (NSArray *)allResourceCategories
{
    return _resourceCategories;
}

@end
