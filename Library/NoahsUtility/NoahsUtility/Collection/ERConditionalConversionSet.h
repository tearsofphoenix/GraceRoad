//
//  ERConditionalConversionSet.h
//  NoahsUtility
//
//  Created by Minun Dragonation on 4/9/13.
//  Copyright (c) 2013 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <NoahsUtility/ERConversionSet.h>

typedef BOOL (^ERConditionalConversionCalculator)(id source, id parameters);

#define ERConditionalConversionIsEqualCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-equal"
#define ERConditionalConversionIsNotEqualCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-not-equal"
#define ERConditionalConversionContainsCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.contains"
#define ERConditionalConversionIsContainedInCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-contained-in"
#define ERConditionalConversionIsNullCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-null"
#define ERConditionalConversionIsNotNullCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-not-null"
#define ERConditionalConversionIsNullOrZeroCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-null-or-zero"
#define ERConditionalConversionIsNotNullOrZeroCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-not-null-or-zero"
#define ERConditionalConversionIsNullOrZeroLengthStringCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-null-or-zero-length-string"
#define ERConditionalConversionIsNotNullOrZeroLengthStringCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-not-null-or-zero-length-string"
#define ERConditionalConversionImageIsNotNullCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.image-is-not-null"
#define ERConditionalConversionIsTheSameDayCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-the-same-day"
#define ERConditionalConversionIsNotTheSameDayCalculator @"com.eintsoft.gopher-wood.noahs-utility.conversion-configuration.calculator.is-not-the-same-day"


@interface ERConditionalConversionSet : ERConversionSet
{
    NSString *_conditionCollectionPath;
    NSString *_conditionCalculatorIdentifier;
    id _conditionCalculatorParameter;
}

@property (nonatomic, retain) NSString *conditionCollectionPath;
@property (nonatomic, retain) NSString *conditionCalculatorIdentifier;
@property (nonatomic, retain) id conditionCalculatorParameter;

+ (void)registerConditionCalculator: (ERConditionalConversionCalculator)calculator
                     withIdentifier: (NSString *)identifier;

+ (ERConditionalConversionCalculator)conditionCalculatorWithIdentifier: (NSString *)identifier;

@end
