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

#import "NSData+HEXStringDescription.h"

static char ERBase64EncodingTable[64] = 
{
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSData (HEXStringDescription)

- (NSString *)hexBytesStringDescription
{
    
    static const char hexDigits[] = "0123456789abcdef";
    
    const size_t size = [self length];
    
    const unsigned char *bytes = [self bytes];
    
    char *buffer = (char *)malloc(size * 2 + 1);
    
    char *current = buffer;
    
    int looper = 0;
    while (looper < size)
    {
        
        *current = hexDigits[*bytes >> 4];
        
        ++current;
        
        *current = hexDigits[*bytes & 0xF];
        
        ++current;
        
        ++bytes;
        
        ++looper;
    }
    
    *current = '\0';
    
    NSString *result = [NSString stringWithUTF8String: buffer];
    
    free(buffer);
    
    return result;
}

- (NSString *)base64StringDescription
{
    
    NSInteger length = [self length];
    
    unsigned long ixtext;
    unsigned long lentext;
    
    long ctremaining;
    short ctcopy;

    unsigned char input[3];
    unsigned char output[4];
    
    short looper;
    short charsonline = 0;
    const unsigned char *raw;
    
    NSMutableString *result;
    
    lentext = [self length]; 
    if (lentext < 1)
    {
        return @"";
    }
    
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [self bytes];
    ixtext = 0; 
    
    while (true) 
    {
        
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) 
        {
            break;        
        }
        
        for (looper = 0; looper < 3; looper++) 
        { 
            unsigned long ix = ixtext + looper;
            if (ix < lentext)
                input[looper] = raw[ix];
            else
                input[looper] = 0;
        }
        
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        
        ctcopy = 4;
        
        switch (ctremaining) 
        {
                
            case 1: 
            {
                ctcopy = 2; 
                break;
            }
                
            case 2: 
            {
                ctcopy = 3; 
                break;
            }
                
            default:
            {
                break;
            }
                
        }
        
        for (looper = 0; looper < ctcopy; looper++)
        {
            [result appendString: [NSString stringWithFormat: @"%c", ERBase64EncodingTable[output[looper]]]];
        }
        
        for (looper = ctcopy; looper < 4; looper++)
        {
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
        {
            charsonline = 0;
        }
        
    }     
    
    return result;
    
}


@end
