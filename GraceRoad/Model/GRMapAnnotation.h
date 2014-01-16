//
//  GRMapAnnotation.h
//  GraceRoad
//
//  Created by Lei on 14-1-16.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GRMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
