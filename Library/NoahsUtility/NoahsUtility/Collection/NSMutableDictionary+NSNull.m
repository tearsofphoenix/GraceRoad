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

#import "NSMutableDictionary+NSNull.h"

@implementation NSMutableDictionary(NSNull)

- (void)setObjectOrNil: (id)object forKey: (id)key
{
    
    if (!key)
    {
        key = [NSNull null];
    }
    
    if (object)
    {
        [self setObject: object forKey: key];
    }
    else 
    {
        [self setObject: [NSNull null] forKey: key];
    }
    
}

- (void)removeObjectOrNilForKey: (id)key
{
    
    if (!key)
    {
        key = [NSNull null];
    }
    
    [self removeObjectForKey: key];
    
}

@end
