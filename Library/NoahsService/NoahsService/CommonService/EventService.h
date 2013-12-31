//
//  EventService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//
#define EREventServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.data.event"

//#define EREventServiceEventsForTargetClientWithIdentifier_Features_Token_Action @"eventsForTargetClientWithIdentifier:features:token:"
//#define EREventServiceEventsForAllTargetClientOfEmployeeWithIdentifier_Features_Token_Action @"eventsForAllTargetClientOfEmployeeWithIdentifier:features:token:"
#define EREventServiceEventsForContactWithProfileIdentifier_Features_Offset_Limit_Token_Action @"eventsForContactWithProfileIdentifier:features:offset:limit:token:"
#define EREventServiceEventsForAllContactsWithFeatures_Offset_Limit_Token_Action @"eventsForAllContactsWithFeatures:offset:limit:token:"
#define EREventServiceEventWithIdentifier_Token_Action @"eventWithIdentifier:token:"
#define EREventServiceEventFeaturesWithToken_Action @"eventFeaturesWithToken:"
#define EREventServiceEnableEventSynchronizationAction @"enableEventSynchronization"
#define EREventServiceSynchronizeEventsOfPersonWithProfile_Offset_Limit_Token_Action @"synchronizeEventsOfPersonWithProfile:offset:limit:token:"
#define EREventServiceMarkEventAsRead_Token_Action @"markEventAsRead:token:"
#define EREventServiceSynchronizePaperEventsOfPersonWithProfile_Offset_Limit_Token_Action @"synchronizePaperEventsOfPersonWithProfile:offset:limit:token:"
#define EREventServiceUpdateEvent_Token_Action @"updateEvent:token:"
#define EREventServiceUpdateEventFeedback_Token_Action @"updateEventFeedback:token:"
#define EREventServiceEventFeedbacksForEvent_Token_Action @"eventFeedbacksForEvent:token:"


#define EREventServiceEventIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.event.identifier"
#define EREventServiceEventServerIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.event.server-identifier"
#define EREventServiceEventFeaturesKey @"com.eintsoft.gopher-wood.noahs-service.data.event.features"
#define EREventServiceEventHolderProfileIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.event.holder-profile-identifier"
#define EREventServiceEventHolderProfileServerIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.event.holder-profile-server-identifier"
#define EREventServiceEventLatitudeKey @"com.eintsoft.gopher-wood.noahs-service.data.event.latitude"
#define EREventServiceEventLongitudeKey @"com.eintsoft.gopher-wood.noahs-service.data.event.longitude"
#define EREventServiceEventLastUpdatedTimestampKey @"com.eintsoft.gopher-wood.noahs-service.data.event.last-updated-timestamp"
#define EREventServiceEventStartTimestampKey @"com.eintsoft.gopher-wood.noahs-service.data.event.start-timestamp"
#define EREventServiceEventEndTimestampKey @"com.eintsoft.gopher-wood.noahs-service.data.event.end-timestamp"
#define EREventServiceEventTypeKey @"com.eintsoft.gopher-wood.noahs-service.data.event.type"
#define EREventServiceEventSubjectKey @"com.eintsoft.gopher-wood.noahs-service.data.event.subject"
#define EREventServiceEventContentKey @"com.eintsoft.gopher-wood.noahs-service.data.event.content"
#define EREventServiceEventStateKey @"com.eintsoft.gopher-wood.noahs-service.data.event.state"
#define EREventServiceEventParticipantIdentifiersKey ERDataServiceTemporaryCollectionPath @"/com.eintsoft.gopher-wood.noahs-service.data.event.participant-identifiers"

#define EREventServiceEventNumberOfEventsToFetchKey @"com.eintsoft.gopher-wood.noahs-service.data.event.number-of-events-to-fetch"
#define EREventServiceEventOffsetOfEventsToFetchKey @"com.eintsoft.gopher-wood.noahs-service.data.event.offset-of-events-to-fetch"
#define EREventServiceEventRelatedPersonProfileServerIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.data.event.related-person.profile.server-identifier"
#define EREventServiceEventOriginalURLKey @"com.eintsoft.gopher-wood.noahs-service.data.event.original-url"

#define EREventServiceEventFeatureKeyKey @"com.eintsoft.gopher-wood.noahs-service.data.event-feature.key"
#define EREventServiceEventFeatureNameKey @"com.eintsoft.gopher-wood.noahs-service.data.event-feature.name"

#define EREventServiceEventListKey @"com.eintsoft.gopher-wood.noahs-service.data.event.list"
#define EREventServiceEventParticipantSettingListKey @"com.eintsoft.gopher-wood.noahs-service.data.event-participant.setting.list"

#define EREventServiceEventHolderProfileKey @"com.eintsoft.gopher-wood.noahs-service.data.temporary/com.eintsoft.gopher-wood.noahs-service.data.event.holder"

#define EREventServiceEventUpdatedNotification @"com.eintsoft.gopher-wood.noahs-service.data.event.notification.updated"
#define EREventServiceEventRelatedPersonBindedNotification @"com.eintsoft.gopher-wood.noahs-service.data.event.related-person.notification.binded"
#define EREventServiceEventReadNotification @"com.eintsoft.gopher-wood.noahs-service.data.event.notification.read"
