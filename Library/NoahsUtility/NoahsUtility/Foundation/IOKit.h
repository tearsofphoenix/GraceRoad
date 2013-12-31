//
//  IOKit.h
//  DoctorsLink
//
//  Created by Minun Dragonation on 3/29/13.
//  Copyright (c) 2013 Minun Dragonation. All rights reserved.
//

#include <mach/mach_host.h>
#include <arpa/inet.h>

#define kIODeviceTreePlane "IODeviceTree"

enum
{
    kIORegistryIterateRecursively = 0x00000001,
    kIORegistryIterateParents  = 0x00000002
};

typedef mach_port_t io_object_t;
typedef io_object_t io_registry_entry_t;
typedef char io_name_t[128];
typedef UInt32 IOOptionBits;

CFTypeRef IORegistryEntrySearchCFProperty(io_registry_entry_t entry,
                                          const io_name_t plane,
                                          CFStringRef key,
                                          CFAllocatorRef allocator,
                                          IOOptionBits options);

kern_return_t IOMasterPort(mach_port_t bootstrapPort,
                           mach_port_t *masterPort);

io_registry_entry_t IORegistryGetRootEntry(mach_port_t masterPort);
