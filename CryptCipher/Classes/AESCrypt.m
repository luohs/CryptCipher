//
//  AESCrypt.m
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import "AESCrypt.h"
#import "SHACrypt.h"
#import "CryptCoder.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation AESCrypt
#pragma mark - AES Encrypt
// default AES Encrypt, key -> SHA384(key).sub(0, 32), iv -> SHA384(key).sub(32, 16)
+ (CryptResult *)aesEncrypt:(NSString *)data key:(NSString *)key
{
    CryptResult * sha = [SHACrypt sha384:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 32)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(32, 16)];
    
    return [self aesEncrypt:data key:aesKey iv:aesIv];
}
#pragma mark AES Encrypt 128, 192, 256
+ (CryptResult *)aesEncrypt:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    return [self aesEncrypt:data key:[key cc_hexData] iv:[iv cc_hexData]];
}
+ (CryptResult *)aesEncrypt:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    return [self aesEncryptWithData:[data dataUsingEncoding:NSUTF8StringEncoding] key:key iv:iv];
}
+ (CryptResult *)aesEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    // Length of iv should be the same lenth with block size(128bits)
    if ([iv length] != kCCBlockSizeAES128) {
        return nil;
    }
    //Length of key should be 16, 24 or 32(128, 192 or 256bits)
    if ([key length] != kCCKeySizeAES128 &&
        [key length] != kCCKeySizeAES192 &&
        [key length] != kCCKeySizeAES256 ) {
        return nil;
    }
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],      // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        CryptResult *result = [[CryptResult alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        
        return result;
    }
    else {
        free(buffer);
        return nil;
    }
}
#pragma mark - AES Decrypt
// default AES Decrypt, key -> SHA384(key).sub(0, 32), iv -> SHA384(key).sub(32, 16)
+ (CryptResult *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key
{
    CryptResult *sha = [SHACrypt sha384:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 32)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(32, 16)];
    
    return [self aesDecryptWithBase64:data key:aesKey iv:aesIv];
}
#pragma mark AES Decrypt 128, 192, 256
+ (CryptResult *)aesDecryptWithBase64:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    return [self aesDecryptWithBase64:data key:[key cc_hexData] iv:[iv cc_hexData]];
}
+ (CryptResult *)aesDecryptWithBase64:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    return [self aesDecryptWithData:[data cc_base64DecodedData] key:key iv:iv];
}
+ (CryptResult *)aesDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    // Length of iv should be the same lenth with block size(128bits)
    if ([iv length] != kCCBlockSizeAES128) {
        return nil;
    }
    //Length of key should be 16, 24 or 32(128, 192 or 256bits)
    if ([key length] != kCCKeySizeAES128 &&
        [key length] != kCCKeySizeAES192 &&
        [key length] != kCCKeySizeAES256 ) {
        return nil;
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],      // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        CryptResult *result = [[CryptResult alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        
        return result;
    }
    else {
        free(buffer);
        return nil;
    }
}
@end
