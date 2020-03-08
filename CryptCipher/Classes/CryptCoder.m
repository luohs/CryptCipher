//
//  CryptCoder.m
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import "CryptCoder.h"

#pragma GCC diagnostic ignored "-Wselector"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This library requires automatic reference counting
#endif

@implementation NSData (Base64)
+ (NSData *)cc_dataWithBase64EncodedString:(NSString *)string
{
    if (![string length]) return nil;
    
    NSData *decoded = nil;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
        decoded = [[self alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
    }
    else
#endif
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    return [decoded length]? decoded: nil;
}

- (NSString *)cc_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    if (![self length]) return nil;
    
    NSString *encoded = nil;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        encoded = [self base64Encoding];
    }
    else
#endif
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    
    return result;
}

- (NSString *)cc_base64EncodedString
{
    return [self cc_base64EncodedStringWithWrapWidth:0];
}
@end


@implementation NSString (Base64)
+ (NSString *)cc_stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData cc_dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)cc_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data cc_base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)cc_base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data cc_base64EncodedString];
}

- (NSString *)cc_base64DecodedString
{
    return [NSString cc_stringWithBase64EncodedString:self];
}

- (NSData *)cc_base64DecodedData
{
    return [NSData cc_dataWithBase64EncodedString:self];
}
@end

@implementation NSData (Hex)
- (NSString *)cc_hexLower:(BOOL)isOutputLower
{
    if (self.length == 0) { return nil; }
    
    static const char HexEncodeCharsLower[] = "0123456789abcdef";
    static const char HexEncodeChars[] = "0123456789ABCDEF";
    char *resultData = malloc([self length]*2+1);
    unsigned char *sourceData = ((unsigned char *)[self bytes]);
    NSUInteger length = [self length];
    
    if (isOutputLower) {
        for (NSUInteger index=0; index<length; index++) {
            resultData[index*2] = HexEncodeCharsLower[(sourceData[index] >> 4)];
            resultData[index*2+1] = HexEncodeCharsLower[(sourceData[index] % 0x10)];
        }
    }
    else {
        for (NSUInteger index=0; index<length; index++) {
            resultData[index*2] = HexEncodeChars[(sourceData[index] >> 4)];
            resultData[index*2+1] = HexEncodeChars[(sourceData[index] % 0x10)];
        }
    }
    resultData[[self length]*2] = 0;
    
    NSString *result = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    sourceData = nil;
    free(resultData);
    
    return result;
}

- (NSString *)cc_hexString
{
    return [self cc_hexLower:NO];
}

- (NSString *)cc_hexStringLower
{
    return [self cc_hexLower:YES];
}
@end

@implementation NSString (Hex)
- (NSData *)cc_hexData
{
    if (self.length == 0) { return nil; }
    
    static const unsigned char HexDecodeChars[] =
    {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, //49
        2, 3, 4, 5, 6, 7, 8, 9, 0, 0, //59
        0, 0, 0, 0, 0, 10, 11, 12, 13, 14,
        15, 0, 0, 0, 0, 0, 0, 0, 0, 0,  //79
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 10, 11, 12,   //99
        13, 14, 15
    };
    
    const char *source = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = strlen(source)/2;
    unsigned char *buffer = malloc(length);
    for (NSUInteger index=0; index<length; index++) {
        buffer[index] = (HexDecodeChars[source[index*2]] << 4) + (HexDecodeChars[source[index*2+1]]);
    }
    NSData *result = [NSData dataWithBytes:buffer length:length];
    free(buffer);
    source = nil;
    
    return  result;
}
@end

@implementation NSData (odd)

- (instancetype)cc_removeOddLocation
{
    const NSUInteger length = self.length;
    
    char *bytes = malloc(length);
    char *outBytes = malloc(length / 2);
    [self getBytes:bytes length:length];
    
    srand((unsigned int)time(NULL));
    for (int i = 0; i < length / 2; ++i) {
        outBytes[i] = bytes[i * 2];
    }
    
    NSData *ret = [[NSData alloc] initWithBytes:outBytes length:length / 2];
    free(bytes);
    free(outBytes);
    
    return ret;
}

- (instancetype)cc_addRandomValueAtOddLocation
{
    const NSInteger randomMax = '~' - '!';
    const NSUInteger length = self.length;
    
    char *bytes = malloc(length);
    char *outBytes = malloc(length * 2);
    [self getBytes:bytes length:length];
    
    srand((unsigned int)time(NULL));
    for (int i = 0; i < length; ++i) {
        outBytes[i * 2] = bytes[i];
        NSInteger value = random() % randomMax;
        outBytes[i * 2 + 1] = value + '!';
    }
    
    NSData *ret = [[NSData alloc] initWithBytes:outBytes length:length * 2];
    free(bytes);
    free(outBytes);
    
    return ret;
}

- (instancetype)cc_shiftValue:(NSInteger)value
{
    const NSUInteger length = self.length;
    char *bytes = malloc(length);
    [self getBytes:bytes length:length];
    
    for (int i = 0; i < length; ++i) {
        bytes[i] += value;
    }
    
    NSData *ret = [[NSData alloc] initWithBytes:bytes length:length];
    free(bytes);
    
    return ret;
}
@end

#pragma mark - Deprecated
@implementation NSData (Base64Deprecated)
- (NSString *)base64EncodedString
{
    return [self cc_base64EncodedString];
}
@end

@implementation NSData (HexDeprecated)
- (NSString *)hexString
{
    return [self cc_hexString];
}

- (NSString *)hexStringLower
{
    return [self cc_hexStringLower];
}

- (NSString *)tf_hexString
{
    return [self cc_hexString];
}

- (NSString *)tf_hexStringLower
{
    return [self cc_hexStringLower];
}
@end

@implementation NSData (oddDeprecated)
- (instancetype)removeOddLocation
{
    return [self cc_removeOddLocation];
}

- (instancetype)addRandomValueAtOddLocation
{
    return [self cc_addRandomValueAtOddLocation];
}

- (instancetype)shiftValue:(NSInteger)value
{
    return [self cc_shiftValue:value];
}
@end

@implementation NSString (Base64Deprecated)
- (NSString *)base64EncodedString
{
    return [self cc_base64EncodedString];
}

- (NSString *)base64DecodedString
{
    return [self cc_base64DecodedString];
}

- (NSData *)base64DecodedData
{
    return [self cc_base64DecodedData];
}
@end

@implementation NSString (HexDeprecated)
- (NSData *)hex
{
    return [self cc_hexData];
}

- (NSData *)tf_hex
{
    return [self cc_hexData];
}
@end
