//
//  SHACrypt.m
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import "SHACrypt.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation SHACrypt
#pragma mark - SHA1
+ (CryptResult *)sha1:(NSString *)hashString
{
    return [self sha1WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (CryptResult *)sha1WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CC_SHA1([hashData bytes], (CC_LONG)[hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA224
+ (CryptResult *)sha224:(NSString *)hashString
{
    return [self sha224WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (CryptResult *)sha224WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA224_DIGEST_LENGTH);
    
    CC_SHA224([hashData bytes], (CC_LONG)[hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA224_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA256
+ (CryptResult *)sha256:(NSString *)hashString
{
    return [self sha256WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (CryptResult *)sha256WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    
    CC_SHA256([hashData bytes], (CC_LONG)[hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA384
+ (CryptResult *)sha384:(NSString *)hashString
{
    return [self sha384WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (CryptResult *)sha384WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA384_DIGEST_LENGTH);
    
    CC_SHA384([hashData bytes], (CC_LONG)[hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA384_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA512
+ (CryptResult *)sha512:(NSString *)hashString
{
    return [self sha512WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (CryptResult *)sha512WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA512_DIGEST_LENGTH);
    
    CC_SHA512([hashData bytes], (CC_LONG)[hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    free(digest);
    
    return result;
}


#pragma mark - HMAC-SHA1
+ (CryptResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha1WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (CryptResult *)hmacSha1WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA224
+ (CryptResult *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha224WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (CryptResult *)hmacSha224WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA224_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA224, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA224_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA256
+ (CryptResult *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha256WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (CryptResult *)hmacSha256WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA384
+ (CryptResult *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha384WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (CryptResult *)hmacSha384WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA384_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA384, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA384_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA512
+ (CryptResult *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha512WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (CryptResult *)hmacSha512WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA512_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CryptResult *result = [[CryptResult alloc] initWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
@end
