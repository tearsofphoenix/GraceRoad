//
//  DataService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//
#define ERDataServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.data"

#define ERDataServiceApplyForNewTokenAction @"applyForNewToken"
#define ERDataServiceDefaultProfileAction @"defaultProfile"
#define ERDataServiceDefaultTokenAction @"defaultToken"
#define ERDataServiceProfileForToken_Action @"profileForToken:"

#define ERDataServiceTemporaryCollectionPath @"com.eintsoft.gopher-wood.noahs-service.data.temporary"

#define ERDataServiceFieldsEditedKey @"com.eintsoft.gopher-wood.noahs-service.data.fields-edited"
#define ERDataServiceNeedToUploadDataKey @"com.eintsoft.gopher-wood.noahs-service.data.need-to-upload-data"
#define ERDataServiceOwnerIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.owner.identifier"
#define ERDataServiceActionKey @"com.eintsoft.gopher-wood.noahs-service.data.action"

#define ERDataServiceFieldsEditedCollectionPath ERDataServiceTemporaryCollectionPath @"/" ERDataServiceFieldsEditedKey
#define ERDataServiceNeedToUploadDataCollectionPath ERDataServiceTemporaryCollectionPath @"/" ERDataServiceNeedToUploadDataKey
#define ERDataServiceOwnerIdentifierCollectionPath ERDataServiceTemporaryCollectionPath @"/" ERDataServiceOwnerIdentifierKey
#define ERDataServiceActionCollectionPath ERDataServiceTemporaryCollectionPath @"/" ERDataServiceActionKey
