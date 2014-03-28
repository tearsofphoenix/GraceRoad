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

#import <NoahsUtility/NSObject+DeallocationCallback.h>

#import <NoahsUtility/NSString+NumberOfOccurrence.h>
#import <NoahsUtility/NSString+XMLTextEscaping.h>
#import <NoahsUtility/NSString+RegularExpression.h>
#import <NoahsUtility/NSString+Words.h>
#import <NoahsUtility/NSString+XMLTextStripping.h>
#import <NoahsUtility/NSString+LatinTransliteration.h>
#import <NoahsUtility/NSString+Transform.h>
#import <NoahsUtility/NSString+DictionaryDescription.h>
#import <NoahsUtility/NSString+Quotation.h>
#import <NoahsUtility/NSString+EditingMatch.h>

#import <NoahsUtility/NSData+HEXStringDescription.h>
#import <NoahsUtility/NSDate+Calendar.h>
#import <NoahsUtility/NSDate+Formatting.h>

#import <NoahsUtility/ERLocale.h>
#import <NoahsUtility/ERLocaleSettings.h>

#import <NoahsUtility/NSArray+NSNull.h>
#import <NoahsUtility/NSMutableArray+NSNull.h>
#import <NoahsUtility/NSDictionary+NSNull.h>
#import <NoahsUtility/NSMutableDictionary+NSNull.h>

#import <NoahsUtility/NSArray+Groupping.h>

#import <NoahsUtility/NSArray+CollectionPath.h>
#import <NoahsUtility/NSSet+CollectionPath.h>
#import <NoahsUtility/NSDictionary+CollectionPath.h>
#import <NoahsUtility/NSMutableArray+CollectionPath.h>
#import <NoahsUtility/NSMutableDictionary+CollectionPath.h>

#import <NoahsUtility/NSArray+ReversedArray.h>
#import <NoahsUtility/NSArray+ShuffledArray.h>
#import <NoahsUtility/NSArray+ToggledMatrixArray.h>
#import <NoahsUtility/NSArray+LocaleComparision.h>

#import <NoahsUtility/NSDictionary+Merging.h>
#import <NoahsUtility/NSArray+Merging.h>
#import <NoahsUtility/NSMutableDictionary+Merging.h>

#import <NoahsUtility/NSSet+Filtering.h>
#import <NoahsUtility/NSArray+Filtering.h>
#import <NoahsUtility/NSDictionary+Filtering.h>

#import <NoahsUtility/NSTimer+ClosureBlock.h>
#import <NoahsUtility/NSThread+ClosureBlock.h>
#import <NoahsUtility/NSThread+BackgroundTask.h>
#import <NoahsUtility/NSOperationQueue+GeneralBackgroundTask.h>

#import <NoahsUtility/NSFileManager+DirectoryOperation.h>

#import <NoahsUtility/NSBundle+ConditionalFileResourceLoading.h>

#import <NoahsUtility/ERUUID.h>

#import <NoahsUtility/ERPDFDocument.h>
#import <NoahsUtility/ERPDFPage.h>
#import <NoahsUtility/NSIndexPath+ERPDFDocument.h>

#import <NoahsUtility/NSNotificationCenter+Application.h>

#import <NoahsUtility/ERPM.h>

#import <NoahsUtility/ERConversionConfiguration.h>
#import <NoahsUtility/ERConversionProcedure.h>
#import <NoahsUtility/ERConversionMap.h>
#import <NoahsUtility/ERConversionSet.h>
#import <NoahsUtility/ERConditionalConversionSet.h>

#import <NoahsUtility/ERRequestPool.h>

#import <NoahsUtility/NSArray+ObjectSharing.h>

#import <NoahsUtility/ERDevice.h>

#import <NoahsUtility/UIApplication+ApplicationInfo.h>

#import <NoahsUtility/NSURL+ApplicationURL.h>

#import <NoahsUtility/ERBlockOperation.h>

#define ERFloatMeaningfulMax 1000000

#define ERDoubleMeaningfulMax 100000000000000

#if defined(__LP64__) && __LP64__
#   define ERMachineFloatMeaningfulMaximum ERDoubleMeaningfulMax
#else
#   define ERMachineFloatMeaningfulMaximum ERFloatMeaningfulMax
#endif

static inline id ERBlock(id block)
{
    
    if (block)
    {
        
        id copiedBlock = [block copy];
        
        return copiedBlock;
        
    }
    else
    {
        return nil;
    }
    
}

static inline id ERBlockCopy(id block)
{
    return [block copy];
}

static inline void ERBlockRelease(id block)
{
//    Block_release(block);
}
