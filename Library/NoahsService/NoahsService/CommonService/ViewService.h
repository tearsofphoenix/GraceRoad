//
//  ViewService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//
#define ERViewServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.view"

#define ERViewServiceRootViewControllerAction @"rootViewController"
#define ERViewServiceAttachRootViewControllerOnWindow_Action @"attachRootViewControllerOnWindow:"
#define ERViewServiceRootViewAction @"rootView"
#define ERViewServiceSetRootView_Action @"setRootView:"
#define ERViewServiceSetPopUpServiceMenuCallback_Action @"setPopUpServiceMenuCallback:"
#define ERViewServiceSetSupportedInterfaceOrientations_Action @"setSupportedInterfaceOrientations:"
#define ERViewServiceCurrentInterfaceOrientationAction @"currentInterfaceOrientation"
#define ERViewServiceShowNetworkActivityIndicatorAction @"showNetworkActivityIndicator"
#define ERViewServiceHideNetworkActivityIndicatorAction @"hideNetworkActivityIndicator"
#define ERViewServiceLogForUserAction_Description_Parameters_Action @"logForUserAction:description:parameters:"

static inline void ERVLog(id action, id description, id parameters)
{

    if (!action)
    {
        action = [NSNull null];
    }

    if (!description)
    {
        description = [NSNull null];
    }

    if (!parameters)
    {
        parameters = [NSNull null];
    }

    ERSC(ERViewServiceIdentifier,
         ERViewServiceLogForUserAction_Description_Parameters_Action,
         [NSArray arrayWithObjects:
          action,
          description,
          parameters,
          nil],
         nil);
    
}