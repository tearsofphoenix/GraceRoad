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

#import <Foundation/Foundation.h>

@interface NSMutableArray(NSNull)

- (void)replaceObjectAtIndex: (NSUInteger)index withObjectOrNil: (id)object;

- (void)addObjectOrNil: (id)object;

- (void)insertObjectOrNil: (id)object atIndex:(NSUInteger)index;

- (void)setObject: (id)object
          atIndex: (NSUInteger)index;

- (void)setObjectOrNil: (id)object atIndex: (NSUInteger)index;

@end
