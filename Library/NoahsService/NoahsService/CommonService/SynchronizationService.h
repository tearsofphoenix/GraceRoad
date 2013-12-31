//
//  SynchronizationService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#define ERSynchronizationServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.synchronization"

#define ERSynchronizationServiceRegisterSynchronizationBlock_Action @"registerSynchronizationBlock:"
#define ERSynchronizationServiceEnableSynchronizationAction @"enableSynchronization"
#define ERSynchronizationServiceDisableSynchronizationAction @"disableSynchronization"
#define ERSynchronizationServiceCheckSymbol_WithPassword_Action @"checkSymbol:withPassword:"
#define ERSynchronizationServiceSynchronizationSessionIdentifierAction @"synchronizationSessionIdentifier"
#define ERSynchronizationServiceSynchronizationTokenAction @"synchronizationToken"
#define ERSynchronizationServiceRequestTokenAction @"requestToken"
#define ERSynchronizationServiceRequestSessionIdentifierAction @"requestSessionIdentifier"
#define ERSynchronizationServiceWaitForNextSynchronizationAction @"waitForNextSynchronization"
#define ERSynchronizationServiceDoRequest_Action @"doRequest:"
#define ERSynchronizationServiceTryToSynchronizeAction @"tryToSynchronize"

#define ERSynchronizationServiceTransactionsKey @"com.eintsoft.gopher-wood.noahs-service.synchronization.transactions"

#define ERSynchronizationServiceTransactionsCollectionPath ERSynchronizationServiceTransactionsKey

typedef void (^ERSynchronizationServiceBlock)(ERServiceCallback callback);
typedef void (^ERSynchronizationServiceRequest)(id exception, ERServiceCallback callback);
