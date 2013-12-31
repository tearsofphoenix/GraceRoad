//
//  ERPM.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 3/12/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ERBlockAction)(void);

extern void ERPM(ERBlockAction action);

extern void ERPPM(ERBlockAction action);
