//
//  GRFellowshipCell.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-27.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRFellowshipCell.h"

@interface GRFellowshipCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation GRFellowshipCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect rect = CGRectMake(0, 0, frame.size.width, 30);
        _nameLabel = [[UILabel alloc] initWithFrame: rect];
        [self addSubview: _nameLabel];
        
        rect.origin.y += rect.size.height + 2;
        
        _addressLabel = [[UILabel alloc] initWithFrame: rect];
        [self addSubview: _addressLabel];
        
        rect.origin.y += rect.size.height + 2;
        
        _phoneLabel = [[UILabel alloc] initWithFrame: rect];
        [self addSubview: _phoneLabel];
    }
    return self;
}

- (void)dealloc
{
    [_nameLabel release];
    [_addressLabel release];
    [_phoneLabel release];
    [_info release];
    
    [super dealloc];
}

- (void)setInfo: (NSDictionary *)info
{
    if (_info != info)
    {
        [_info release];
        _info = [info retain];
        
        [_nameLabel setText: _info[GRFellowshipNameKey]];
        [_addressLabel setText: [@"地址：  " stringByAppendingString: _info[GRFellowshipAddressKey]]];
        [_phoneLabel setText: [@"电话：  " stringByAppendingString: _info[GRFellowshipPhoneKey]]];
    }
}


@end
