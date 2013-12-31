//
//  ERDevice.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/20/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface ERDevice: NSObject<CLLocationManagerDelegate>
{
    double _altitude;
    double _longitude;
    double _latitude;
}

+ (ERDevice *)currentDevice;

- (NSString *)model;

- (NSString *)machine;

- (NSString *)serialNumber;

- (NSString *)deviceIdentifier;

- (NSString *)identifierForVendor;

- (NSString *)CPUType;

- (NSInteger)numberOfCPUCores;

- (unsigned long long)storageSize;

- (unsigned long long)memorySize;

- (NSString *)systemName;

- (NSString *)systemVersion;

- (unsigned long long)numberOfFreeNodesOnStorage;
- (unsigned long long)numberOfUsedNodesOnStorage;

- (unsigned long long)usedStorageSize;
- (unsigned long long)freeStorageSize;

- (unsigned long long)usedMemorySize;
- (unsigned long long)freeMemorySize;

- (id)profile;

@end
