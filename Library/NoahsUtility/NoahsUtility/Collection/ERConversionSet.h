//
//  ERConversionSet.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <NoahsUtility/ERConversionConfiguration.h>

@interface ERConversionSet : ERConversionConfiguration
{
    NSArray *_configurations;
    NSString *_targetCollectionType;
}

@property (nonatomic, retain) NSArray *configurations;
@property (nonatomic, retain) NSString *targetCollectionType;

@end
