//
//  ERObjectDeallocationCallbackController.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 8/27/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <NoahsUtility/NSObject+DeallocationCallback.h>

@interface ERObjectDeallocationCallbackController: NSObject
{
    
    id _subject;
    
    ERObjectDeallocationCallback _callback;
    
    ERUUID *_handle;
    
}

- (id)   initWithSubject: (id)subject
    deallocationCallback: (ERObjectDeallocationCallback)callback
                  handle: (ERUUID *)handle;

- (void)clearCallback;

@end
