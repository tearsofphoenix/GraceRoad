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
#import "GRTheme.h"
#import "GRSendMessageView.h"
#import "UIActionSheet+BlockSupport.h"

@interface GRUserDetailView ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *_avatarBackgroundView;
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    
    UIButton *_teamNameButton;
    
    NSMutableArray *_memberList;
    UITableView *_memberListView;
    NSMutableSet *_selectedIndexPaths;
    
    UIButton *_logoutButton;
}

@property (nonatomic, retain) NSArray *teams;
@property (nonatomic, retain) NSDictionary *selectedTeam;

@end

@implementation GRUserDetailView

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        CGRect bounds = [self bounds];
                
        CGRect avatarBackgroundFrame = CGRectMake(0, 0, 320, 120);
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
        
        _teamNameButton = [[UIButton alloc] initWithFrame: CGRectMake(144, 50, 80, 36)];
        [_teamNameButton addTarget: self
                            action: @selector(_handleTeamNameButtonTappedEvent:)
                  forControlEvents: UIControlEventTouchUpInside];
        [[_teamNameButton titleLabel] setTextAlignment: NSTextAlignmentCenter];
        [[_teamNameButton titleLabel] setFont: [UIFont systemFontOfSize: 15]];
        [_teamNameButton setTitleColor: [UIColor whiteColor]
                              forState: UIControlStateNormal];
        [_teamNameButton setBackgroundColor: [GRTheme darkColor]];
        [self addSubview: _teamNameButton];
        
        NSDictionary *accountInfo = ERSSC(GRDataServiceID, GRDataServiceCurrentAccountAction, nil);
        //TODO: Isaac team logic

        if (accountInfo)
        {
            [_nameLabel setText: accountInfo[GRAccountNameKey]];

            [self setTeams: ERSSC(GRDataServiceID,
                                  GRDataServiceTeamsForAccountIDAction,
                                  @[ accountInfo[GRAccountIDKey] ])];
        }
        
        _logoutButton = [[UIButton alloc] initWithFrame: CGRectMake(30, bounds.size.height - 60,
                                                                    bounds.size.width - 30 * 2,
                                                                    30)];
        [_logoutButton setBackgroundColor: [UIColor redColor]];
        [_logoutButton setTitle: @"登出"
                       forState: UIControlStateNormal];
        [_logoutButton addTarget: self
                          action: @selector(_handleLogoutButtonTappedEvent:)
                forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _logoutButton];
        
        //
        UIButton *selectAllButton = [[UIButton alloc] initWithFrame: CGRectMake(10, 78, 60, 36)];
        [selectAllButton setTitle: @"全选"
                         forState: UIControlStateNormal];
        [selectAllButton setTitleColor: [UIColor whiteColor]
                              forState: UIControlStateNormal];
        [selectAllButton setBackgroundColor: [GRTheme darkColor]];
        [[selectAllButton titleLabel] setFont: [UIFont systemFontOfSize: 14]];
        [selectAllButton addTarget: self
                            action: @selector(_handleSelectAllTappedEvent:)
                  forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: selectAllButton];
        [selectAllButton release];
        
        UIButton *sendMessageButton = [[UIButton alloc] initWithFrame: CGRectMake(frame.size.width - 80, 78, 70, 36)];
        [sendMessageButton setTitle: @"发送消息"
                           forState: UIControlStateNormal];
        [sendMessageButton setTitleColor: [UIColor whiteColor]
                                forState: UIControlStateNormal];
        [[sendMessageButton titleLabel] setFont: [UIFont systemFontOfSize: 14]];
        [sendMessageButton setBackgroundColor: [GRTheme darkColor]];
        [sendMessageButton addTarget: self
                              action: @selector(_handleSendMessageButtonTappedEvent:)
                    forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: sendMessageButton];
        [sendMessageButton release];
        
        _memberList = [[NSMutableArray alloc] init];
        
        CGFloat originY = avatarBackgroundFrame.origin.y + avatarBackgroundFrame.size.height;
        _memberListView = [[UITableView alloc] initWithFrame: CGRectMake(0, originY, frame.size.width, frame.size.height - originY - 60)];
        [_memberListView setDataSource: self];
        [_memberListView setDelegate: self];
        
        [self addSubview: _memberListView];
        
        _selectedIndexPaths = [[NSMutableSet alloc] init];
        
        if ([_teams count] > 0)
        {
            [self setSelectedTeam: _teams[0]];
        }
    }
    return self;
}

- (void)dealloc
{
    [_avatarBackgroundView release];
    [_avatarView release];
    [_nameLabel release];
    [_teamNameButton release];
    
    [_logoutButton release];
    
    [_memberList release];
    [_memberListView release];
    [_selectedIndexPaths release];
    
    [_teams release];
    [_selectedTeam release];
    
    [super dealloc];
}

- (void)setSelectedTeam: (NSDictionary *)selectedTeam
{
    if (_selectedTeam != selectedTeam)
    {
        [_selectedTeam release];
        _selectedTeam = [selectedTeam retain];
        
        [_teamNameButton setTitle: _selectedTeam[GRTeamNameKey]
                         forState: UIControlStateNormal];

        NSArray *members = ERSSC(GRDataServiceID,
                                 GRDataServiceAllMemberForTeamIDAction,
                                 @[ _selectedTeam[GRTeamIDKey] ]);
        [_memberList setArray: members];
        
        [_memberListView reloadData];
    }
}

- (void)setFrame: (CGRect)frame
{
    [super setFrame: frame];
    
    CGRect rect = [_avatarBackgroundView frame];
    CGFloat originY = rect.origin.y + rect.size.height;
    [_memberListView setFrame: CGRectMake(0, originY, frame.size.width, frame.size.height - originY - 60)];
    
    CGRect bounds = [self bounds];
    [_logoutButton setFrame: CGRectMake(30, bounds.size.height - 60, bounds.size.width - 30 * 2, 34)];
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

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (UIView *) tableView: (UITableView *)tableView
viewForHeaderInSection: (NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
    
    [headerLabel setBackgroundColor: [GRTheme headerBlueColor]];
    [headerLabel setTextColor: [UIColor whiteColor]];

//    if (section == 0)
//    {
//        [headerLabel setText: @"    上周服事"];
//    }else
    {
        [headerLabel setText: @"    成员"];
    }
    
    return [headerLabel autorelease];
}

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
    
    if ([_selectedIndexPaths containsObject: indexPath])
    {
        [cell setAccessoryType: UITableViewCellAccessoryCheckmark];
    }else
    {
        [cell setAccessoryType: UITableViewCellAccessoryNone];
    }
    
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

- (CGFloat)    tableView: (UITableView *)tableView
heightForHeaderInSection: (NSInteger)section
{
    return 30;
}

- (CGFloat)    tableView: (UITableView *)tableView
heightForFooterInSection: (NSInteger)section
{
    return 0;
}

- (CGFloat)   tableView: (UITableView *)tableView
heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 40;
}

- (void)_handleSelectAllTappedEvent: (UIButton *)sender
{
    NSInteger section = 0;
    NSInteger count = [self tableView: _memberListView
                numberOfRowsInSection: section];
    
    //has selected all, so dis-selectall
    //
    if ([_selectedIndexPaths count] == count)
    {
        [sender setTitle: @"全选"
                forState: UIControlStateNormal];
        [[sender titleLabel] setFont: [UIFont systemFontOfSize: 14]];
        
        for (NSIndexPath *iLooper in _selectedIndexPaths)
        {
            UITableViewCell *cell = [_memberListView cellForRowAtIndexPath: iLooper];
            [cell setAccessoryType: UITableViewCellAccessoryNone];
        }
        
        [_selectedIndexPaths removeAllObjects];
    }else
    {
        [sender setTitle: @"全不选"
                forState: UIControlStateNormal];
        [[sender titleLabel] setFont: [UIFont systemFontOfSize: 13]];
        
        for (NSInteger iLooper = 0; iLooper < count; ++iLooper)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: iLooper
                                                        inSection: section];
            UITableViewCell *cell = [_memberListView cellForRowAtIndexPath: indexPath];
            
            [cell setAccessoryType: UITableViewCellAccessoryCheckmark];
            [_selectedIndexPaths addObject: indexPath];
        }
    }
}

- (void)_handleSendMessageButtonTappedEvent: (id)sender
{
    NSInteger count = [_selectedIndexPaths count];
    if (count == 0)
    {
        ERSC(GRViewServiceID,
             GRViewServiceAlertMessageAction,
             @[@"请先选择成员！"], nil);
    }else
    {
        NSMutableArray *targetAccounts = [NSMutableArray arrayWithCapacity: count];
        
        for (NSIndexPath *iLooper in _selectedIndexPaths)
        {
            [targetAccounts addObject: _memberList[[iLooper row]]];
        }
        
        GRSendMessageView *sendMessageView = [[GRSendMessageView alloc] initWithFrame: [self frame]];
        
        [sendMessageView setTargetAccounts: targetAccounts];
        
        ERSC(GRViewServiceID, GRViewServicePushContentViewAction, @[ sendMessageView ], nil);
        
        [sendMessageView release];
    }
}

- (void)_handleTeamNameButtonTappedEvent: (id)sender
{
    NSMutableArray *teams = [NSMutableArray arrayWithCapacity: [_teams count]];
    for (NSDictionary *tLooper in _teams)
    {
        [teams addObject: tLooper[GRTeamNameKey]];
    }
    
    [UIActionSheet showWithTitle: nil
                         choices: teams
                          inView: self
                        callback: (^(NSInteger buttonIndex)
                                   {
                                       if (buttonIndex > 0)
                                       {
                                           [self setSelectedTeam: _teams[buttonIndex - 1]];
                                       }
                                   })];
}

@end
