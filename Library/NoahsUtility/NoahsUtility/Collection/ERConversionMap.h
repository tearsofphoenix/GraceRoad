//
//  ERConversionMap.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/8/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <NoahsUtility/ERConversionSet.h>

@interface ERConversionMap: ERConversionSet
{
    
    NSString *_targetElementType;
    NSString *_expectedSourceElementCollectionType;
    
    NSString *_filteringCollectionPath;
    NSString *_filteringCalculatorIdentifier;
    id _filteringCalculatorParameter;
    
}

@property (nonatomic, retain) NSString *targetElementType;
@property (nonatomic, retain) NSString *expectedSourceElementCollectionType;

@property (nonatomic, retain) NSString *filteringCollectionPath;
@property (nonatomic, retain) NSString *filteringCalculatorIdentifier;
@property (nonatomic, retain) id filteringCalculatorParameter;

@end
