//
//  GRMapAnnotation.m
//  GraceRoad
//
//  Created by Lei on 14-1-16.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRMapAnnotation.h"

@implementation GRMapAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (void)dealloc
{
    [_title release];
    [_subtitle release];
    
    [super dealloc];
}
@end
