// EREACH CONFIDENTIAL
// 
// [2011] eReach Mobile Software Technology Co., Ltd.
// All Rights Reserved.
//
// NOTICE:  All information contained herein is, and remains the
// property of eReach Mobile Software Technology and its suppliers,
// if any.  The intellectual and technical concepts contained herein
// are proprietary to eReach Mobile Software Technology and its
// suppliers and may be covered by U.S. and Foreign Patents, patents
// in process, and are protected by trade secret or copyright law.
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained
// from eReach Mobile Software Technology Co., Ltd.
//

#import "ERUUID.h"

@implementation ERUUID

- (id)init
{
    
    self = [super init];
    if (self)
    {
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        
        CFStringRef string = CFUUIDCreateString(NULL, uuid);
        
        CFRelease(uuid);
        
        _stringDescription = [(NSString *)string lowercaseString];
        
        [_stringDescription retain];
        
        CFRelease(string);
        
    }
    
    return self;
    
}

- (id)initWithCoder: (NSCoder*)decoder
{
    
    self = [super init];
    if (self)
    {
        _stringDescription = [[decoder decodeObjectForKey: @"_stringDescription"] copy];
    }
    
    return self;
}

- (id)initWithStringDescription: (NSString *)stringDescription
{
    
    self = [super init];
    if (self)
    {
        
        if (stringDescription)
        {
            
            _stringDescription = stringDescription;
        
            [_stringDescription retain];
            
        }
        else 
        {
            
            [self release];
            
            self = nil;
            
        }
        
    }
    
    return self;
}

+ (ERUUID *)UUID
{
    return [[[ERUUID alloc] init] autorelease];
}

+ (ERUUID *)UUIDWithStringDescription: (NSString *)description
{
    
    if (description)
    {
        return [[[ERUUID alloc] initWithStringDescription: description] autorelease];
    }
    else 
    {
        return nil;
    }
    
}

- (void)dealloc
{
    
    [_stringDescription release];
    
    [super dealloc];
}

- (void)encodeWithCoder: (NSCoder*)encoder
{
    [encoder encodeObject: _stringDescription forKey: @"_stringDescription"];
}

- (BOOL)isEqual: (id)object
{
    
    if ([object isKindOfClass: [ERUUID class]])
    {
        return [_stringDescription isEqualToString: [object stringDescription]];
    }
    else 
    {
        return NO;
    }
    
}

- (NSUInteger)hash
{
    return [_stringDescription hash];
}

- (NSString *)stringDescription;
{
    return _stringDescription;
}

- (NSString *)description
{
    return _stringDescription;
}

- (id)copyWithZone: (NSZone *)zone
{
    return [[[self class] allocWithZone: zone] initWithStringDescription: _stringDescription];
}

@end
