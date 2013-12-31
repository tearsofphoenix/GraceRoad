//
//  ApplicationService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//
#define ERApplicationServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.application"

#define ERApplicationServiceLaunchAction @"launch"
#define ERApplicationServiceSinkAction @"sink"
#define ERApplicationServiceMoorAction @"moor"

#define ERApplicationServiceVariantWithName_Action @"variantWithName:"
#define ERApplicationServiceUpdateVariant_WithName_Action @"updateVariant:withName:"

#define ERApplicationServiceApplicationDidReceiveURLRequestNotification @"com.eintsoft.gopher-wood.noahs-service.application.notification.did-receive-url"

#define ERVariantNotNil(NAME, DEFAULT) \
(id)(ERVariant(NAME) ?: (DEFAULT))

#define ERVariant(NAME) \
ERSSC(ERApplicationServiceIdentifier, \
      ERApplicationServiceVariantWithName_Action, \
      (@[((NAME) ?: [NSNull null])]))

#define ERUpdateVariant(NAME, VALUE) \
ERSSC(ERApplicationServiceIdentifier, \
      ERApplicationServiceUpdateVariant_WithName_Action, \
      (@[((VALUE) ?: [NSNull null]), ((NAME) ?: [NSNull null])]))