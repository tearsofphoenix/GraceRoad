#import "NSString+XMLTextEscaping.h"

@implementation NSString(XMLTextEscaping)

- (NSString *)XMLTextEscaped
{
    return [[[[[self stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
               stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"] 
              stringByReplacingOccurrencesOfString: @"'" withString: @"&#39;"] 
             stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"] 
            stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
}

- (NSString *)XMLTextUnescaped
{
    return [[[[[self stringByReplacingOccurrencesOfString: @"&lt;" withString: @"<"]
               stringByReplacingOccurrencesOfString: @"&gt;" withString: @">"] 
              stringByReplacingOccurrencesOfString: @"&#39;" withString: @"'"] 
             stringByReplacingOccurrencesOfString: @"&quot;" withString: @"\""] 
            stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
}

@end
