//
//  SecurityService.h
//  NoahsService
//
//  Created by Minun Dragonation on 4/10/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#pragma mark - Service identifier

#define ERSecurityServiceIdentifier @"com.eintsoft.gopher-wood.noahs-service.security"


#pragma mark - Service actions

#define ERSecurityServiceQuickSigningAccountsSymbolsWithToken_Action @"quickSigningAccountsSymbolsWithToken:"
#define ERSecurityServiceAccountWithSymbol_Password_Token_Action @"accountWithSymbol:password:token:"
#define ERSecurityServiceAccountWithSymbol_QuickSigningPassword_Token_Action @"accountWithSymbol:quickSigningPassword:token:"
#define ERSecurityServiceSwitchToAccountWithIdentifier_SigningSettings_Token_Action @"switchToAccountWithIdentifier:signingSettings:token:"
#define ERSecurityServiceUpdateAccountWithSymbol_Password_Profile_Action @"updateAccountWithSymbol:password:profile:"
#define ERSecurityServiceActiveAccountSubjectIdentifierForToken_Action @"activeAccountSubjectIdentifierForToken:"
#define ERSecurityServiceActiveAccountSigningSettingsForToken_Action @"activeAccountSigningSettingsForToken:"
#define ERSecurityServiceActiveAccountStateWithToken_Action @"activeAccountStateWithToken:"
#define ERSecurityServiceSetActiveAccountState_Token_Action @"setActiveAccountState:token:"
#define ERSecurityServiceResetOldPassword_NewPassword_Token_Action @"resetOldPassword:newPassword:token:"


#pragma mark - Data service profile property keys

#define ERSecurityServiceProfileActiveAccountSigningSettingsKey @"com.eintsoft.gopher-wood.noahs-service.security.active-account.signing-settings"
#define ERSecurityServiceProfileActiveAccountIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.security.active-account.identifier"
#define ERSecurityServiceProfileActiveAccountSubjectIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.security.active-account.subject-identifier"


#pragma mark - Account property keys

#define ERSecurityServiceAccountIdentifierKey @"com.eintsoft.gopher-wood.noahs-service.security.account.identifier"
#define ERSecurityServiceAccountSymbolKey @"com.eintsoft.gopher-wood.noahs-service.security.account.symbol"
#define ERSecurityServiceAccountPasswordKey @"com.eintsoft.gopher-wood.noahs-service.security.account.password"


#pragma mark - Account states

#define ERSecurityServiceAccountCreatedState @"com.eintsoft.gopher-wood.noahs-service.security.account.created"
#define ERSecurityServiceAccountAvailableState @"com.eintsoft.gopher-wood.noahs-service.security.account.available"
#define ERSecurityServiceAccountUnavailableState @"com.eintsoft.gopher-wood.noahs-service.security.account.unavailable"


#pragma mark - Account setting states

#define ERSecurityServiceAccountSettingAvailableState @"com.eintsoft.gopher-wood.noahs-service.security.account-setting.available"


#pragma mark - Security cryptography algorithms

#define ERSecurityService3DSCryptographyAlgorithm @"com.eintsoft.gopher-wood.noahs-service.security.cryptography.3ds"


#pragma mark - Security situations

#define ERSecurityServiceIOSSigningSituation @"com.eintsoft.gopher-wood.noahs-service.security.situation.signing.ios"


#pragma mark - Security methods

#define ERSecurityServiceSymbolPasswordMethod @"com.eintsoft.gopher-wood.noahs-service.security.method.symbol-password"
#define ERSecurityServiceSymbolDotsMethod @"com.eintsoft.gopher-wood.noahs-service.security.method.symbol-dots"
