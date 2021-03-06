//
//  GRIntroductView.m
//  GraceRoad
//
//  Created by Lei on 13-12-29.
//  Copyright (c) 2013年 Mac003. All rights reserved.
//

#define GRHasMap 0

#import "GRIntroductView.h"
#import "GRMapAnnotation.h"
#import "Reachability.h"
#import "GRTheme.h"
#import "GRUIExtensions.h"
#import "GRDataService.h"
#import "GRViewService.h"

#if GRHasMap
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#endif

#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>

@interface GRIntroductView ()<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{
    UITableView *_tableView;
    
    UIImageView *_placeHolderImageView;
#if GRHasMap
    MKMapView *_mapView;
    GRMapAnnotation *_annotation;
#endif
    NSArray *_telephones;
}
@end

@implementation GRIntroductView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        _telephones = [@[@"137-9535-2317",
                         @"135-6426-9605",
                         @"158-0193-5868",] retain];
        
        [self setTitle: @"新松江恩典教会"];
        
        CGRect bounds = [self bounds];
        
        _tableView = [[UITableView alloc] initWithFrame: bounds];
        [self addSubview: _tableView];
        
        [_tableView setBackgroundColor: [UIColor colorWithRed: 0.93f
                                                         green: 0.95f
                                                          blue: 0.96f
                                                         alpha: 1.00f]];
        
        CGRect rect = CGRectMake(10, 30, frame.size.width - 10 * 2, 120);
        
        UITextView *contentView = [[UITextView alloc] initWithFrame: rect];
        
        //[contentView setScrollEnabled: NO];
        [contentView setBackgroundColor: [UIColor clearColor]];
        [contentView setFont: [UIFont systemFontOfSize: 16]];
        [contentView setTextAlignment: NSTextAlignmentLeft];
        [contentView setEditable: NO];
        [contentView setScrollEnabled: NO];
        [contentView setText: (@"\n"
                               "      以马内利！新松江恩典教会欢迎您！\n"
                               "      感谢神把您带到我们当中，在基督里我们是一家人，"
                               "愿在以后的生活里我们共同学习神的话语。耶稣爱你！\n"
                               "")];
        [_tableView setTableHeaderView: contentView];
        [contentView release];

        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = frame.size.width;
        rect.size.height = 222;
        
        _placeHolderImageView = [[UIImageView alloc] initWithFrame: rect];
        [_placeHolderImageView setImage: [UIImage imageNamed: @"GRMapPlaceHolder"]];
        [_placeHolderImageView setAlpha: 0];
        
#if GRHasMap
        _mapView = [[MKMapView alloc] initWithFrame: rect];
        [_mapView setDelegate: self];
        
        [[Reachability reachabilityForInternetConnection] startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_notificationForNetworkUpdated:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
#endif
        [self _updateMapViewIfNeeded];

        [_tableView setDataSource: self];
        [_tableView setDelegate: self];
        
        ERSC(GRDataServiceID, GRDataServiceStartToSynchronizeAction, nil, nil);
    }
    return self;
}

- (void)dealloc
{
    [[Reachability reachabilityForInternetConnection] stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_telephones release];
    [_tableView release];
#if GRHasMap
    [_mapView release];
    [_annotation release];
#endif
    [_placeHolderImageView release];
    
    [super dealloc];
}

- (void)_updateMapForChurchLocation
{
#if GRHasMap
    [_placeHolderImageView setAlpha: 0];
    
    [_mapView setAlpha: 1];
    [_mapView removeAnnotation: _annotation];
    
    if (!_annotation)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(31.039477, 121.234174);
        MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(coordinate, 1500.0, 1500.0);
        [_mapView setRegion: userLocation
                   animated: YES];
        
        _annotation = [[GRMapAnnotation alloc] init];
        
        [_annotation setCoordinate: coordinate];
        [_annotation setTitle: @"新松江路276号文荟建材广场3楼19号"];
    }
    
    [_mapView addAnnotation: _annotation];
#else
    [_placeHolderImageView setAlpha: 1];
#endif
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    [_tableView setFrame: [self bounds]];
}

- (void)_updateMapViewIfNeeded
{
#if GRHasMap
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
    {
        [self _updateMapForChurchLocation];
    }else
    {
        [_placeHolderImageView setAlpha: 1];
        [_mapView setAlpha: 0];
    }
#else
    [_placeHolderImageView setAlpha: 1];
#endif
}

- (void)_notificationForNetworkUpdated: (NSNotification *)notification
{
    [self _updateMapViewIfNeeded];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 3;
}

- (UIView *) tableView: (UITableView *)tableView
viewForHeaderInSection: (NSInteger)section
{
    UILabel *headerLabel = [GRTheme newheaderLabel];
    
    switch (section)
    {
        case 0:
        {
            [headerLabel setText: @"    周日事项"];
            break;
        }
        case 1:
        {
            [headerLabel setText: @"    联系方式"];
            break;
        }
        case 2:
        {
            [headerLabel setText: @"    地图"];
            break;
        }
        default:
            break;
    }
    
    return headerLabel;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 5;
        }
        case 1:
        {
            return 3;
        }
        case 2:
        {
            return 1;
        }
        default:
        {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setBackgroundColor: [UIColor clearColor]];
    
    switch (section)
    {
        case 0:
        {
            switch (row)
            {
                case 0:
                {
                    [[cell textLabel] setText: @"第一场礼拜    07:30-08:30"];
                    break;
                }
                case 1:
                {
                    [[cell textLabel] setText: @"第二场礼拜    09:00-10:30"];
                    break;
                }
                case 2:
                {
                    [[cell textLabel] setText: @"第三场礼拜    11:00-12:00（韩语）"];
                    break;
                }
                case 3:
                {
                    [[cell textLabel] setText: @"青年礼拜        13:30-15:00"];
                    break;
                }
                case 4:
                {
                    [[cell textLabel] setText: @"成人主日学    11:00-12:00"];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (row)
            {
                case 0:
                {
                    [[cell textLabel] setText: [NSString stringWithFormat: @"孙牧师    电话：%@", _telephones[0]]];
                    break;
                }
                case 1:
                {
                    [[cell textLabel] setText: [NSString stringWithFormat: @"张传道    电话：%@", _telephones[1]]];
                    break;
                }
                case 2:
                {
                    [[cell textLabel] setText: [NSString stringWithFormat: @"李传道    电话：%@", _telephones[2]]];
                    break;
                }
                default:
                    break;
            }
        }
        case 2:
        {
            [[cell contentView] addSubview: _placeHolderImageView];
#if  GRHasMap
            [[cell contentView] addSubview: _mapView];
#endif
            break;
        }
        default:
        {
            break;
        }
    }

    return [cell autorelease];
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    switch (section)
    {
        case 0:
        case 1:
        {
            return 40;
        }
        case 2:
        {
            return [_placeHolderImageView bounds].size.height;
        }
        default:
        {
            return 0;
        }
    }
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (1 == section)
    {
        [UIActionSheet showWithTitle: nil
                             choices: @[ @"打电话", @"发短信" ]
                              inView: self
                            callback: (^(NSInteger buttonIndex)
                                       {
                                           if (1 == buttonIndex)
                                           {
                                               NSString *phoneNumber = [@"telprompt://" stringByAppendingString: _telephones[row]];
                                               NSURL *URL = [NSURL URLWithString: phoneNumber];
                                               if ([[UIApplication sharedApplication] canOpenURL: URL])
                                               {
                                                   [[UIApplication sharedApplication] openURL: URL];
                                               }else
                                               {
                                                   ERSC(GRViewServiceID, GRViewServiceAlertMessageAction, @[ @"您的设备无法拨打电话！"], nil);
                                               }
                                           }else if (2 == buttonIndex)
                                           {
                                               ERSC(GRViewServiceID,
                                                    GRViewServiceSendMessageAction,
                                                    (@[
                                                       @[_telephones[row]],
                                                       ]), nil);
                                           }
                                       })];
    }
}

#if GRHasMap
- (MKAnnotationView *)mapView: (MKMapView *)mapView
            viewForAnnotation: (id <MKAnnotation>)annotation
{
    CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
    if (!annotationView)
    {
        annotationView = [[[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"] autorelease];
        JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
        [annotationView.contentView addSubview:cell];
        
    }
    return annotationView;

//    MKPinAnnotationView *annView=[[[MKPinAnnotationView alloc] initWithAnnotation: annotation
//                                                                  reuseIdentifier: @"pin"] autorelease];
//    annView.pinColor = MKPinAnnotationColorGreen;
//
//    [annView setBackgroundColor: [UIColor whiteColor]];
//    [annView setEnabled:YES];
//    [annView setCanShowCallout:YES];
//    
//    return annView;

}

#endif

@end
