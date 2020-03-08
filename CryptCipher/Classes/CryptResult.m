//
//  CryptResult.m
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import "CryptResult.h"
#import "CryptCoder.h"

@implementation CryptResult
@synthesize data = _data;

#pragma mark - Init
- (id)initWithBytes:(unsigned char[])initData length:(NSUInteger)length
{
    self = [super init];
    if (self) {
        _data = [NSData dataWithBytes:initData length:length];
    }
    return self;
}

#pragma mark UTF8 String
// convert to UTF8 string
- (NSString *)utf8String
{
    return [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
}

#pragma mark HEX string
// convert to HEX string
- (NSString *)hex
{
    return [_data cc_hexString];
}

- (NSString *)hexLower
{
    return [_data cc_hexStringLower];
}

#pragma mark Base64
// convert to Base64 string
- (NSString *)base64
{
    return [_data cc_base64EncodedString];
}
@end
