//
//  GRUserDetailView.m
//  GraceRoad
//
//  Created by Lei on 14-1-14.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRUserDetailView.h"
#import "GRDataService.h"
#import "GRAccountKeys.h"
#import "GRViewService.h"
#import "GRTeamKeys.h"

@interface GRUserDetailView ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *_avatarBackgroundView;
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    
    UILabel *_titleLabel;
    
    NSMutableArray *_memberList;
    UITableView *_memberListView;
    NSMutableSet *_selectedIndexPaths;
}
@end

@implementation GRUserDetailView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        CGRect bounds = [self bounds];
        
        CGRect avatarBackgroundFrame = CGRectMake(0, 0, 320, 110);
        _avatarBackgroundView = [[UIImageView alloc] initWithFrame: avatarBackgroundFrame];
        [_avatarBackgroundView setImage: [UIImage imageNamed: @"GRAvatarBackground"]];
        [self addSubview: _avatarBackgroundView];
        
        _avatarView = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 60, 60)];
        [[_avatarView layer] setCornerRadius: 30];
        [_avatarView setImage: [UIImage imageNamed: @"GRExampleAvatar"]];
        [_avatarView setClipsToBounds: YES];
        
        [self addSubview: _avatarView];
        
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(94, 15, 50, 30)];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextColor: [UIColor whiteColor]];
        [label setFont: [UIFont systemFontOfSize: 14]];
        [label setText: @"姓名："];
        [self addSubview: label];
        [label release];
        
        _nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(144, 10, 260, 40)];
        [_nameLabel setTextColor: [UIColor whiteColor]];
        //[_nameLabel setTextAlignment: NSTextAlignmentLeft];
        [_nameLabel setBackgroundColor: [UIColor clearColor]];
        [self addSubview: _nameLabel];
        
        label = [[UILabel alloc] initWithFrame: CGRectMake(80, 50, 60, 30)];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextColor: [UIColor whiteColor]];
        [label setFont: [UIFont systemFontOfSize: 14]];
        [label setText: @"所在组："];
        [self addSubview: label];
        [label release];
        
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(144, 35, 260, 60)];
        [_titleLabel setTextColor: [UIColor whiteColor]];
        [_titleLabel setBackgroundColor: [UIColor clearColor]];
        [self addSubview: _titleLabel];
        
        NSDictionary *accountInfo = ERSSC(GRDataServiceID, GRDataServiceCurrentAccountAction, nil);
        NSDictionary *team = ERSSC(GRDataServiceID, GRDataServiceTeamForAccountIDAction, @[ ]);

        [_nameLabel setText: accountInfo[GRAccountNameKey]];
        [_titleLabel setText: team[GRTeamNameKey]];
        
        UIButton *logoutButton = [[UIButton alloc] initWithFrame: CGRectMake(30, bounds.size.height - 60,
                                                                             bounds.size.width - 30 * 2,
                                                                             40)];
        [logoutButton setBackgroundColor: [UIColor redColor]];
        [logoutButton setTitle: @"登出"
                      forState: UIControlStateNormal];
        [logoutButton addTarget: self
                         action: @selector(_handleLogoutButtonTappedEvent:)
               forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: logoutButton];
        [logoutButton release];
        
        //
        NSArray *members = ERSSC(GRDataServiceID, GRDataServiceAllMemberForTeamIDAction, @[ team[GRTeamIDKey] ]);
        
        _memberList = [[NSMutableArray alloc] initWithArray: members];
        
        CGFloat originY = avatarBackgroundFrame.origin.y + avatarBackgroundFrame.size.height;
        _memberListView = [[UITableView alloc] initWithFrame: CGRectMake(0, originY, frame.size.width, frame.size.height - originY - 60)];
        [_memberListView setDataSource: self];
        [_memberListView setDelegate: self];
        
        [self addSubview: _memberListView];
        
        _selectedIndexPaths = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_avatarBackgroundView release];
    [_avatarView release];
    [_nameLabel release];
    [_titleLabel release];
    
    [_memberList release];
    [_memberListView release];
    [_selectedIndexPaths release];
    
    [super dealloc];
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    CGRect rect = [_avatarBackgroundView frame];
    CGFloat originY = rect.origin.y + rect.size.height;
    [_memberListView setFrame: CGRectMake(0, originY, frame.size.width, frame.size.height - originY - 60)];
}

- (void)_handleLogoutButtonTappedEvent: (id)sender
{
    ERSC(GRDataServiceID, GRDataServiceLogoutAction, nil,
         (^(id result, id exception)
          {
              ERSC(GRViewServiceID, GRViewServicePopContentViewAction, nil, nil);
          }));
}

#pragma mark - UITableViewDataSource & delegate

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    return [_memberList count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSDictionary *memberInfo = _memberList[[indexPath row]];
    
    [[cell textLabel] setText: memberInfo[GRAccountNameKey]];
    
    return [cell autorelease];
}

- (void)      tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];

    if ([_selectedIndexPaths containsObject: indexPath])
    {
        [_selectedIndexPaths removeObject: indexPath];
        [cell setAccessoryType: UITableViewCellAccessoryNone];
    }else
    {
        [_selectedIndexPaths addObject: indexPath];
        [cell setAccessoryType: UITableViewCellAccessoryCheckmark];
    }
}

@end
