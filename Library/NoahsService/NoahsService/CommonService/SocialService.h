//
//  SocialService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#pragma mark - Service identifier

#define ERSocialServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.data.social"


#pragma mark - Service actions

#define ERSocialServiceEnableSocialSynchronizationAction @"enableSocialSynchronization"

#define ERSocialServiceUpdatePersonProfile_WithToken_Action @"updatePersonProfile:withToken:"
#define ERSocialServicePersonProfileWithIdentifier_Token_Action @"personProfileWithIdentifier:token:"
#define ERSocialServicePersonProfileWithIdentifier_BatchStatements_Token_Action @"personProfileWithIdentifier:batchStatements:token:"
#define ERSocialServiceAllContactPersonProfilesWithToken_Action @"allContactPersonProfilesWithToken:"
#define ERSocialServiceAllContactPersonProfilesWithBatchStatements_Token_Action @"allContactPersonProfilesWithBatchStatements:token:"
#define ERSocialServiceAllContactPersonProfilesCouldMatch_Replacement_WithinRange_Token_Action @"allContactPersonProfilesCouldMatch:replacement:withinRange:token:"
#define ERSocialServicePersonProfileIdentifierFromServerIdentifier_BatchStatements_Token_Action @"personProfileIdentifierFromServerIdentifier:batchStatements:token:"
#define ERSocialServiceSearchForPersonCouldBindWithName_Token_Action @"searchForPersonCouldBindWithName:token:"
#define ERSocialServiceAddContactPersonProfile_NeededToUploadData_BatchStatements_Token_Action @"addContactPersonProfile:neededToUploadData:batchStatements:token:"
#define ERSocialServiceAddContactPersonProfile_NeededToUploadData_Token_Action @"addContactPersonProfile:neededToUploadData:token:"
#define ERSocialServiceRemoveContactPersonProfile_Token_Action @"removeContactPersonProfile:token:"
#define ERSocialServiceSynchronizeSocialWithToken_Action @"synchronizeSocialWithToken:"
#define ERSocialServiceServerIdentifierForPersonProfileIdentifier_BatchStatements_Token_Action @"serverIdentifierForPersonProfileIdentifier:batchStatements:token:"
#define ERSocialServiceMarkObjectWithIdentifier_AsFavourite_Token_Action @"markObjectWithIdentifier:asFavourite:token:"
#define ERSocialServiceListTagsForPersonWithProfile_Token_Action @"listTagsForPersonWithProfile:token:"
#define ERSocialServiceRateTag_ForPersonWithProfile_Token_Action @"rateTag:forPersonWithProfile:token:"
#define ERSocialServiceAllContactPersonProfilesHasRecentMessagesWithToken_Action @"allContactPersonProfilesHasRecentMessagesWithToken:"
#define ERSocialServiceAllMessagesForPersonProfile_WithToken_Action @"allMessagesForPersonProfile:withToken:"
#define ERSocialServiceUpdateMessageProfile_WithToken_Action @"updateMessageProfile:withToken:"

#pragma mark - Person property keys

#define ERSocialServicePersonIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.identifier"
#define ERSocialServicePersonServerIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.server-identifier"
#define ERSocialServicePersonNameKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.name"
#define ERSocialServicePersonFamilyNameKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.family-name"
#define ERSocialServicePersonGivenNameKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.given-name"
#define ERSocialServicePersonGenderKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.gender"
#define ERSocialServicePersonBirthdateKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.birthdate"
#define ERSocialServicePersonDescriptionKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.description"
#define ERSocialServicePersonWorkExpierenceKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.work-expierence"
#define ERSocialServiceNumberOfPersonsToSearchKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.number-of-persons-to-search"
#define ERSocialServiceNamePatternOfPersonsToSearchKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.name-pattern-of-persons-to-search"


#pragma mark - Person profile property keys

#define ERSocialServicePersonProfileKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile"
#define ERSocialServicePersonProfileIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.identifier"
#define ERSocialServicePersonProfileServerIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.server-identifier"
#define ERSocialServicePersonProfileHasBeenBindedKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.has-been-binded"
#define ERSocialServicePersonProfileBindedPersonServerIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.binded-server-identifier"
#define ERSocialServicePersonProfileLastUpdatedTimestampKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.last-updated-timestamp"
#define ERSocialServicePersonProfileStateKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.state"


#pragma mark - Contact property keys

#define ERSocialServiceContactProfileCollectionPath @"com.eintsoft.gopher-wood.noahs-service.data.social.person.contact.profile"
#define ERSocialServiceContactLastUpdatedTimestampCollectionPath @"com.eintsoft.gopher-wood.noahs-service.data.social.person.contact.last-updated-timestamp"
#define ERSocialServiceContactOwnerProfileServerIdentifierCollectionPath @"com.eintsoft.gopher-wood.noahs-service.data.social.person.contact.profile.owner/" ERSocialServicePersonProfileServerIdentifierKey


#pragma mark - Contact list property keys

#define ERSocialServiceContactListLastUpdatedTimestampKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.contact-list.last-updated-timestamp"
#define ERSocialServiceContactListKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.contact-list"


#pragma mark - Notifications

#define ERSocialServiceMessageProfileUpdatedNotification @"com.eintsoft.gopher-wood.noahs-service.data.social.message.profile.notification.updated"
#define ERSocialServicePersonProfileUpdatedNotification @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.notification.updated"
#define ERSocialServicePersonProfileTagsUpdatedNotification @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.tag.notification.updated"
#define ERSocialServicePersonContactAddedNotification @"com.eintsoft.gopher-wood.noahs-service.data.social.person.contact.notification.added"
#define ERSocialServicePersonContactRemovedNotification @"com.eintsoft.gopher-wood.noahs-service.data.social.person.contact.notification.removed"

#define ERSocialServicePersonFavouritesChangedNotification @"com.eintsoft.gopher-wood.noahs-service.data.social.person.favourites.notification.changed"


#pragma mark - Undetermined properties

#define ERSocialServicePersonAvatarImageKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.avatar-image-path"
#define ERSocialServicePersonIsFavouriteKey @"com.eintsoft.gopher-wood.noahs-service.data.social.person.is-favourite"



#define ERSocialServicePersonProfileStateVisible @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.state.visible"
#define ERSocialServicePersonProfileStateHidden @"com.eintsoft.gopher-wood.noahs-service.data.social.person.profile.state.hidden"

//"com.eintsoft.gopher-wood.noahs-service.data.social.person.emails"
//"com.eintsoft.gopher-wood.noahs-service.data.social.person.marital-status" = "com.eintsoft.gopher-wood.noahs-service.data.social.person.marital-status.married";
//"com.eintsoft.gopher-wood.noahs-service.data.social.person.phones"
//"com.eintsoft.gopher-wood.noahs-service.security.account" = "test@ereachmobile.com";
