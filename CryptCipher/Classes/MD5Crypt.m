//
//  MD5Crypt.m
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import "MD5Crypt.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation MD5Crypt
#pragma mark - MD5
+ (CryptResult *)md5:(NSString *)hashString
{
    return [self md5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (CryptResult *)md5WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([hashData bytes], (CC_LONG)[hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark - HMAC-MD5
+ (CryptResult *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacMd5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (CryptResult *)hmacMd5WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
@end
