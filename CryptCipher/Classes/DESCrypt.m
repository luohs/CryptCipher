//
//  DESCrypt.m
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import "DESCrypt.h"
#import "MD5Crypt.h"
#import "CryptCoder.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation DESCrypt
#pragma mark - DES Encrypt
// default DES Encrypt, key -> md5(key).sub(0, 8), iv -> md5(key).sub(8, 8)
+ (CryptResult *)desEncrypt:(NSString *)data key:(NSString *)key
{
    CryptResult * sha = [MD5Crypt md5:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 8)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(8, 8)];
    
    return [self desEncrypt:data key:aesKey iv:aesIv];
}
#pragma mark DES Encrypt
+ (CryptResult *)desEncrypt:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    return [self desEncrypt:data key:[key cc_hexData] iv:[iv cc_hexData]];
}
+ (CryptResult *)desEncrypt:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    return [self desEncryptWithData:[data dataUsingEncoding:NSUTF8StringEncoding] key:key iv:iv];
}
+ (CryptResult *)desEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    // Length of iv should be the same lenth with block size(DES, 3DES)
    if ([iv length] != kCCBlockSizeDES) {
        return nil;
    }
    //Length of key should be 8, 24(DES, 3DES)
    if ([key length] != kCCKeySizeDES &&
        [key length] != kCCKeySize3DES) {
        return nil;
    }
    
    CCAlgorithm alg = kCCAlgorithmDES;
    if ([key length] == kCCKeySize3DES){
        alg = kCCAlgorithm3DES;
    }
    
    size_t bufferSize = [data length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          alg,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeDES
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
#pragma mark - DES Decrypt
// default DES Decrypt, key -> md5(key).sub(0, 8), iv -> md5(key).sub(8, 8)
+ (CryptResult *)desDecryptWithBase64:(NSString *)data key:(NSString *)key
{
    CryptResult *sha = [MD5Crypt md5:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 8)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(8, 8)];
    
    return [self desDecryptWithBase64:data key:aesKey iv:aesIv];
}
#pragma mark DES Decrypt
+ (CryptResult *)desDecryptWithBase64:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    return [self desDecryptWithBase64:data key:[key cc_hexData] iv:[iv cc_hexData]];
}
+ (CryptResult *)desDecryptWithBase64:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    return [self desDecryptWithData:[data cc_base64DecodedData] key:key iv:iv];
}
+ (CryptResult *)desDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    // Length of iv should be the same lenth with block size, should be 8(DES, 3DES)
    if ([iv length] != kCCBlockSizeDES &&
        [iv length] != kCCBlockSize3DES) {
        return nil;
    }
    //Length of key should be 8, 24(DES, 3DES)
    if ([key length] != kCCKeySizeDES &&
        [key length] != kCCKeySize3DES) {
        return nil;
    }
    
    CCAlgorithm alg = kCCAlgorithmDES;
    if ([key length] == kCCKeySize3DES){
        alg = kCCAlgorithm3DES;
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          alg,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeDES
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
