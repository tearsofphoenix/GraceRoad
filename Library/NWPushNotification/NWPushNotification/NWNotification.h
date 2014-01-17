//
//  NWNotification.h
//  Pusher
//
//  Copyright (c) 2014 noodlewerk. All rights reserved.
//

#import "NWPusher.h"
#import <Foundation/Foundation.h>


@interface NWNotification : NSObject

@property (nonatomic, strong) NSString *payload;
@property (nonatomic, strong) NSData *payloadData;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSData *tokenData;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, strong) NSDate *expiration;
@property (nonatomic, assign) NSUInteger expirationStamp;
@property (nonatomic, assign) NSUInteger priority;

- (id)initWithPayload:(NSString *)payload token:(NSString *)token identifier:(NSUInteger)identifier expiration:(NSDate *)date priority:(NSUInteger)priority;
- (id)initWithPayloadData:(NSData *)payload tokenData:(NSData *)token identifier:(NSUInteger)identifier expirationStamp:(NSUInteger)expirationStamp priority:(NSUInteger)priority;

- (NSData *)dataWithType:(NWNotificationType)type;
- (NWPusherResult)validate;

+ (NSData *)dataFromHex:(NSString *)hex;
+ (NSString *)hexFromData:(NSData *)data;

@end
