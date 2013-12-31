//
//  ERBlockOperation.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/30/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EROperationBlock)(void);

@interface ERBlockOperation : NSOperation

- (id)initWithBlock: (EROperationBlock)block;

@end
