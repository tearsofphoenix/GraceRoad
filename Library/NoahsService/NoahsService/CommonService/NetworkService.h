//
//  NetworkService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#define ERNetworkServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.network"

#define ERNetworkServiceLoadNetworkSettingsAtFilePath_InBundle_Action @"loadNetworkSettingsAtFilePath:inBundle:"
#define ERNetworkServiceNetworkSettingWithIdentifier_Action @"networkSettingWithIdentifier:"
#define ERNetworkServiceRequestForDataWithURL_QueryParameters_DataToPost_Action @"requestForDataWithURL:queryParameters:dataToPost:"
#define ERNetworkServiceDownloadFileAtURL_QueryParameters_DataToPost_Action @"downloadFileAtURL:queryParameters:dataToPost:"
#define ERNetworkServiceRequestForAction_QueryParameters_Action @"requestForAction:queryParameters:"
#define ERNetworkServiceLocalHostNameAction @"localHostName"
#define ERNetworkServiceResolveIPAddressForHostName_Action @"resolveIPAddressForHostName:"
#define ERNetworkServiceIsHostNameAvailable_Action @"isHostNameAvailable:"
#define ERNetworkServiceLocalWiFiIPAddressAction @"localWiFiIPAddress"
#define ERNetworkServiceLocalWiFiIPAddressesAction @"localWiFiIPAddresses"
#define ERNetworkServicePublicIPAddressAction @"publicIPAddress"
#define ERNetworkServicePublicIPGeographyLocationAction @"publicIPGeographyLocation"
#define ERNetworkServiceIsNetworkAvailableAction @"isNetworkAvailable"
#define ERNetworkServiceIsWWANAvailableAction @"isWWANAvailable"
#define ERNetworkServiceIsWLANAvailableAction @"isWLANAvailable"
#define ERNetworkServiceDownloadedCachedFileAtURL_QueryParameters_Action @"downloadedCachedFileAtURL:queryParameters:"

#define ERNetworkServiceSessionIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.network.session.identifier"
#define ERNetworkServiceRequestMessageIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.network.request.message-identifier"
#define ERNetworkServiceRequestCommandKey @"com.eintsoft.gopher-wood.noahs-service.network.request.command"
#define ERNetworkServiceRequestVersionKey @"com.eintsoft.gopher-wood.noahs-service.network.request.version"
#define ERNetworkServiceRequestTokenKey @"com.eintsoft.gopher-wood.noahs-service.network.request.token"
#define ERNetworkServiceRequestModeKey @"com.eintsoft.gopher-wood.noahs-service.network.request.mode"
#define ERNetworkServiceRequestParametersKey @"com.eintsoft.gopher-wood.noahs-service.network.request.parameters"
#define ERNetworkServiceResponseStatusCodeKey @"com.eintsoft.gopher-wood.noahs-service.network.response.status-code"
#define ERNetworkServiceResponseExceptionsKey @"com.eintsoft.gopher-wood.noahs-service.network.response.exceptions"
#define ERNetworkServiceResponseVersionKey @"com.eintsoft.gopher-wood.noahs-service.network.response.version"
#define ERNetworkServiceResponseContentKey @"com.eintsoft.gopher-wood.noahs-service.network.response.content"
#define ERNetworkServiceTracingEnabledKey @"com.eintsoft.gopher-wood.noahs-service.network.tracing.enabled"
#define ERNetworkServiceOnlyWLANKey @"com.eintsoft.gopher-wood.noahs-service.network.only-wlan"

#define ERNetworkServiceSessionIdentifierCollectionPath ERNetworkServiceSessionIdentifierKey
#define ERNetworkServiceRequestMessageIdentifierCollectionPath ERNetworkServiceRequestMessageIdentifierKey
#define ERNetworkServiceRequestCommandCollectionPath ERNetworkServiceRequestCommandKey
#define ERNetworkServiceRequestVersionCollectionPath ERNetworkServiceRequestVersionKey
#define ERNetworkServiceRequestTokenCollectionPath ERNetworkServiceRequestTokenKey
#define ERNetworkServiceRequestModeCollectionPath ERNetworkServiceRequestModeKey
#define ERNetworkServiceRequestParametersCollectionPath ERNetworkServiceRequestParametersKey
#define ERNetworkServiceResponseStatusCodeCollectionPath ERNetworkServiceResponseStatusCodeKey
#define ERNetworkServiceResponseExceptionsCollectionPath ERNetworkServiceResponseExceptionsKey
#define ERNetworkServiceResponseVersionCollectionPath ERNetworkServiceResponseVersionKey
#define ERNetworkServiceResponseContentCollectionPath ERNetworkServiceResponseContentKey
#define ERNetworkServiceTracingEnabledCollectionPath ERNetworkServiceTracingEnabledKey

#define ERNetworkServiceNetworkDidBecomeAvailableNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.did-become-available"
#define ERNetworkServiceNetworkDidBecomeUnavailableNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.did-become-unavailable"
#define ERNetworkServiceWLANNetworkDidBecomeAvailableNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.did-become-available.wlan"
#define ERNetworkServiceWLANNetworkDidBecomeUnavailableNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.did-become-unavailable.wlan"

#define ERNetworkServiceFileDidBeginToDownloadNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.file.did-begin-to-download"
#define ERNetworkServiceFileDidGetProgressOnDownloadingNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.file.did-get-progress-on-downloading"
#define ERNetworkServiceFileDidFinishDownloadingNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.file.did-finish-downloading"
#define ERNetworkServiceFileDidFailToDownloadNotification @"com.eintsoft.gopher-wood.noahs-service.network.notification.file.did-fail-to-download"

static inline void ERRD(NSURL *url, NSDictionary *queryParameters, NSData *dataToPost, ERServiceCallback callback)
{
    ERSC(ERNetworkServiceIdentifier,
         ERNetworkServiceRequestForDataWithURL_QueryParameters_DataToPost_Action,
         [NSArray arrayWithObjects:
          url ?: [NSNull null],
          queryParameters ?: [NSNull null],
          dataToPost ?: [NSNull null],
          nil],
         callback);
}

static inline void ERRA(NSString *action, NSDictionary *queryParameters, ERServiceCallback callback)
{
    ERSC(ERNetworkServiceIdentifier,
         ERNetworkServiceRequestForAction_QueryParameters_Action,
         [NSArray arrayWithObjects:
          action ?: [NSNull null],
          queryParameters ?: [NSNull null],
          nil],
         callback);
}