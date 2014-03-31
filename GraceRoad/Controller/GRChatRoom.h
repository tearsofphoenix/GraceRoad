//
//  GRChatRoom.h
//  GraceRoad
//
//  Created by Mac003 on 14-3-31.
//  Copyright (c) 2014年 Mac003. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRChatRoom : NSObject

@property (nonatomic, strong) NSString *name;

- (void)addMembers: (NSArray *)members;

- (NSDictionary *)memberOfID: (NSString *)memberID;

@end
