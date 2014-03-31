//
//  GRChatRoom.m
//  GraceRoad
//
//  Created by Mac003 on 14-3-31.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import "GRChatRoom.h"
#import "GRAccountKeys.h"

@interface GRChatRoom ()

@property (nonatomic, strong) NSMutableDictionary *members;

@end

@implementation GRChatRoom

- (id)init
{
    if ((self = [super init]))
    {
        _members = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addMembers: (NSArray *)members
{
    for (NSDictionary *aLooper in members)
    {
        [_members setObject: aLooper
                     forKey: aLooper[GRAccountIDKey]];
    }
}

- (NSDictionary *)memberOfID: (NSString *)memberID
{
    return _members[memberID];
}

@end
