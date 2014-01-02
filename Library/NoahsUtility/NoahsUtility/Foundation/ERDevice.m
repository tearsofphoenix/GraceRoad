//
//  ERDevice.m
//  NoahsUtility
//
//  Created by Minun Dragonation on 5/20/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "ERDevice.h"

#import <mach/mach.h>
#import <mach/mach_host.h>

#include <sys/utsname.h>
#include <sys/sysctl.h>
#include <sys/stat.h>
#include <sys/time.h>

#include <execinfo.h>

#import <UIKit/UIKit.h>

#import <NoahsService/NoahsService.h>

#import "NSDictionary+NSNull.h"

#if !(TARGET_IPHONE_SIMULATOR) && !defined(APPLE_STORE_DISTRIBUTION)
#   define ERDeviceGetSerialNumber
#endif

#ifdef ERDeviceGetSerialNumber
#   import "IOKit.h"
#endif

static ERDevice *ERDeviceCurrentDevice;
//static CLLocationManager *ERDeviceCurrentLocationManager;

static int ERDeviceGetSystemInformation(unsigned int typeSpecifier)
{

    size_t size = sizeof(int);

    int results;

    int name[2] = {CTL_HW, typeSpecifier};

    sysctl(name, 2, &results, &size, NULL, 0);

    return results;
}

@implementation ERDevice

+ (void)load
{
    
    ERDeviceCurrentDevice = [[ERDevice alloc] init];

    /*
    ERDeviceCurrentLocationManager = [[CLLocationManager alloc] init];

    [ERDeviceCurrentLocationManager setDelegate: ERDeviceCurrentDevice];

    [ERDeviceCurrentLocationManager setDistanceFilter: kCLDistanceFilterNone];
    [ERDeviceCurrentLocationManager setDesiredAccuracy: kCLLocationAccuracyBest];

    [ERDeviceCurrentLocationManager startUpdatingLocation];
     */
}

+ (ERDevice *)currentDevice
{
    return ERDeviceCurrentDevice;
}

- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations
{

    CLLocation *location = [locations lastObject];

    _altitude = [location altitude];
    _latitude = [location coordinate].latitude;
    _longitude = [location coordinate].longitude;

}

- (double)altitude
{
    return _altitude;
}

- (double)latitude
{
    return _latitude;
}

- (double)longitude
{
    return _longitude;
}

- (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

- (NSString *)model
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)machine
{

    struct utsname systemInfo;
    
    uname(&systemInfo);

    return [NSString stringWithUTF8String: systemInfo.machine];
    
}

- (NSString *)serialNumber
{

#ifdef ERDeviceGetSerialNumber

    BOOL couldContinueToFindSerialNumber = YES;

    mach_port_t masterPort;
    CFTypeID properyID = (CFTypeID)NULL;
    unsigned int bufferSize;
    kern_return_t kernelReturn;
    io_registry_entry_t entry;
    CFTypeRef property;
    CFDataRef propertyData;
    NSArray *serialNumberArray;

    if (couldContinueToFindSerialNumber)
    {
        kernelReturn = IOMasterPort(MACH_PORT_NULL, &masterPort);
        if (kernelReturn != noErr)
        {
            couldContinueToFindSerialNumber = NO;
        }
    }

    if (couldContinueToFindSerialNumber)
    {
        entry = IORegistryGetRootEntry(masterPort);
        if (entry == MACH_PORT_NULL)
        {
            couldContinueToFindSerialNumber = NO;
        }
    }

    if (couldContinueToFindSerialNumber)
    {
        property = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, (CFStringRef)@"serial-number", nil, kIORegistryIterateRecursively);
        if (!property)
        {
            couldContinueToFindSerialNumber = NO;
        }
    }

    if (couldContinueToFindSerialNumber)
    {
        properyID = CFGetTypeID(property);
        if (!(properyID == CFDataGetTypeID()))
        {
            mach_port_deallocate(mach_task_self(), masterPort);
            couldContinueToFindSerialNumber = NO;
        }
    }

    if (couldContinueToFindSerialNumber)
    {
        propertyData = (CFDataRef)property;
        if (!propertyData)
        {
            couldContinueToFindSerialNumber = NO;
        }
    }

    if (couldContinueToFindSerialNumber)
    {
        bufferSize = CFDataGetLength(propertyData);
        if (!bufferSize)
        {
            couldContinueToFindSerialNumber = NO;
        }
    }

    if (couldContinueToFindSerialNumber)
    {

        NSString *propertyString = [[[NSString alloc] initWithBytes: CFDataGetBytePtr(propertyData)
                                                             length: bufferSize
                                                           encoding: 1] autorelease];

        mach_port_deallocate(mach_task_self(), masterPort);

        serialNumberArray = [propertyString componentsSeparatedByString:@"\0"];

    }

    const char *serialNumber = NULL;
    if (couldContinueToFindSerialNumber)
    {
        serialNumber = [[serialNumberArray objectAtIndex: 0] UTF8String];
    }

    if (couldContinueToFindSerialNumber)
    {
        return [NSString stringWithUTF8String: serialNumber];
    }
    else
    {
        return nil;
    }

#else

    return nil;

#endif

}

- (NSString *)deviceIdentifier
{
#ifdef APPLE_STORE_DISTRIBUTION
    return [self identifierForVendor];
#else
    return [[UIDevice currentDevice] performSelector: @selector(uniqueIdentifier)];
#endif
}

- (NSString *)identifierForVendor
{

    if ([[UIDevice currentDevice] respondsToSelector: @selector(identifierForVendor)])
    {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else
    {
        return nil;
    }

}

- (NSString *)CPUType
{

    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;

    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO,
              (host_info_t)&hostInfo, &infoCount);

    cpu_type_t CPUType = hostInfo.cpu_type;

    if ((CPUType & (~CPU_ARCH_MASK)) == CPU_TYPE_ARM)
    {
        return [NSString stringWithFormat: @"ARM(%d bit)", (CPUType & CPU_ARCH_ABI64) ? 64 : 32];
    }
    else if ((CPUType & (~CPU_ARCH_MASK)) == CPU_TYPE_X86)
    {
        return @"X86(64 bit)";
    }
    else
    {
        return nil;
    }

}

- (NSString *)CPUSubtype
{

    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;

    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO,
              (host_info_t)&hostInfo, &infoCount);

    cpu_type_t CPUType = hostInfo.cpu_type;
    cpu_subtype_t CPUSubtype = hostInfo.cpu_subtype;

    if ((CPUType & (~CPU_ARCH_MASK)) == CPU_TYPE_ARM)
    {

        switch (CPUSubtype)
        {

            case CPU_SUBTYPE_ARM_V6:
            {
                return @"armv6";
            }
                
            case CPU_SUBTYPE_ARM_V7:
            {
                return @"armv7";
            }

            case CPU_SUBTYPE_ARM_V7S:
            {
                return @"armv7s";
            }

            default:
            {
                return nil;
            }

        }

    }
    else if ((CPUType & (~CPU_ARCH_MASK)) == CPU_TYPE_X86)
    {
        return @"x86_64";
    }
    else
    {
        return nil;
    }
    
}

- (NSInteger)numberOfCPUCores
{
    return ERDeviceGetSystemInformation(HW_NCPU);
}

- (unsigned long long)storageSize
{

    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: nil];

    return [[fileAttributes objectForKey: NSFileSystemSize] longLongValue];

}

- (unsigned long long)memorySize
{
    return [self usedMemorySize] + [self freeMemorySize];
}

- (NSString *)systemName
{
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

- (unsigned long long)numberOfFreeNodesOnStorage
{

    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: nil];

    return  [[fileAttributes objectForKey: NSFileSystemFreeNodes] longLongValue];

}

- (unsigned long long)numberOfUsedNodesOnStorage
{

    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: nil];

    return ([[fileAttributes objectForKey: NSFileSystemNodes] longLongValue] -
            [[fileAttributes objectForKey: NSFileSystemFreeNodes] longLongValue]);

}

- (unsigned long long)usedStorageSize
{

    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: nil];

    return ([[fileAttributes objectForKey: NSFileSystemSize] longLongValue] -
            [[fileAttributes objectForKey: NSFileSystemFreeSize] longLongValue]);

}

- (unsigned long long)freeStorageSize
{

    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: nil];

    return [[fileAttributes objectForKey: NSFileSystemFreeSize] longLongValue];

}

- (unsigned long long)usedMemorySize
{
    
    vm_statistics_data_t vmStatistics;

    mach_port_t hostPort = mach_host_self();

    vm_size_t pageSize;

    host_page_size(hostPort, &pageSize);

    mach_msg_type_number_t hostSize = sizeof(vm_statistics_data_t) / sizeof(integer_t);

    long long memoryUsed = 0;

    BOOL succeededToFetchHostStatistics = host_statistics(hostPort, HOST_VM_INFO, (host_info_t)&vmStatistics, &hostSize);
    if (succeededToFetchHostStatistics == KERN_SUCCESS)
    {
        memoryUsed = (vmStatistics.active_count + vmStatistics.inactive_count + vmStatistics.wire_count) * (long long)pageSize;
    }

    return memoryUsed;

}

- (unsigned long long)freeMemorySize
{

    vm_statistics_data_t vmStatistics;

    mach_port_t hostPort = mach_host_self();

    vm_size_t pageSize;

    host_page_size(hostPort, &pageSize);

    mach_msg_type_number_t hostSize = sizeof(vm_statistics_data_t) / sizeof(integer_t);

    long long memoryFree = 0;

    BOOL succeededToFetchHostStatistics = host_statistics(hostPort, HOST_VM_INFO, (host_info_t)&vmStatistics, &hostSize);
    if (succeededToFetchHostStatistics == KERN_SUCCESS)
    {
        memoryFree = vmStatistics.free_count * (long long)pageSize;
    }

    return memoryFree;

}

- (id)profile
{
    return [NSDictionary dictionaryWithKeysAndObjectsOrNils:
            
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.model", [self model],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.machine", [self machine],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.serial-number", [self serialNumber],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.identifier.device", [self deviceIdentifier],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.identifier.for-vendor", [self identifierForVendor],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.cpu.type", [self CPUType],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.cpu.subtype", [self CPUSubtype],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.cpu.number-of-cores", [NSNumber numberWithInteger: [self numberOfCPUCores]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.storage.size", [NSNumber numberWithUnsignedLongLong: [self storageSize]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.hardware.memory.size", [NSNumber numberWithUnsignedLongLong: [self memorySize]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.system.name", [self systemName],
            @"com.eintsoft.gopher-wood.noahs-utility.device.system.version", [self systemVersion],
            @"com.eintsoft.gopher-wood.noahs-utility.device.statistics.storage.nodes.free", [NSNumber numberWithUnsignedLongLong: [self numberOfFreeNodesOnStorage]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.statistics.storage.nodes.used", [NSNumber numberWithUnsignedLongLong: [self numberOfUsedNodesOnStorage]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.statistics.storage.space.free", [NSNumber numberWithUnsignedLongLong: [self freeStorageSize]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.statistics.storage.space.used", [NSNumber numberWithUnsignedLongLong: [self usedStorageSize]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.statistics.memory.space.free", [NSNumber numberWithUnsignedLongLong: [self freeMemorySize]],
            @"com.eintsoft.gopher-wood.noahs-utility.device.statistics.memory.space.used", [NSNumber numberWithUnsignedLongLong: [self usedMemorySize]],

            @"com.eintsoft.gopher-wood.noahs-utility.device.network.host.name", ERSSC(ERNetworkServiceIdentifier,
                                                                                      ERNetworkServiceLocalHostNameAction, nil),
            @"com.eintsoft.gopher-wood.noahs-utility.device.network.status", ERSSC(ERNetworkServiceIdentifier,
                                                                                   ERNetworkServiceIsNetworkAvailableAction, nil),
            @"com.eintsoft.gopher-wood.noahs-utility.device.network.wwan.status", ERSSC(ERNetworkServiceIdentifier,
                                                                                        ERNetworkServiceIsWWANAvailableAction, nil),
            @"com.eintsoft.gopher-wood.noahs-utility.device.network.wlan.status", ERSSC(ERNetworkServiceIdentifier,
                                                                                        ERNetworkServiceIsWLANAvailableAction, nil),
            @"com.eintsoft.gopher-wood.noahs-utility.device.network.wlan.local-ip-addresses", ERSSC(ERNetworkServiceIdentifier,
                                                                                                    ERNetworkServiceLocalWiFiIPAddressesAction, nil),
            @"com.eintsoft.gopher-wood.noahs-utility.device.location.altitude", [NSNumber numberWithDouble: _altitude],
            @"com.eintsoft.gopher-wood.noahs-utility.device.location.latitude", [NSNumber numberWithDouble: _latitude],
            @"com.eintsoft.gopher-wood.noahs-utility.device.location.longitude", [NSNumber numberWithDouble: _longitude],

            nil];
}

@end
