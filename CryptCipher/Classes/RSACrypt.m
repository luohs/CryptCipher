//
//  RSACrypt.m
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import "RSACrypt.h"
#import "CryptCoder.h"

@implementation RSACrypt
//获取公钥
+ (SecKeyRef)publicKeyRef:(NSData *)certData
{
    if (!certData) {
        return nil;
    }
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    SecKeyRef publicKeyRef = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    if (cert != NULL && policy) {
        if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
            SecTrustResultType result;
            if (SecTrustEvaluate(trust, &result) == noErr) {
                publicKeyRef = SecTrustCopyPublicKey(trust);
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return publicKeyRef;
}
//获取私钥
+ (SecKeyRef)privateKeyRef:(NSData *)p12Data password:(NSString*)password
{
    if (!p12Data) {
        return nil;
    }
    SecKeyRef privateKeyRef = NULL;
    CFStringRef CFPassword = (__bridge CFStringRef)password;
    const void *keys[] =   {kSecImportExportPassphrase};
    const void *values[] = {CFPassword};
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef)p12Data, options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    if (items) CFRelease(items);
    if (options) CFRelease(options);
    
    return privateKeyRef;
}

+ (CryptResult *)rsaEncrypt:(NSString *)data publicKeyRef:(SecKeyRef)publicKeyRef
{
    if (publicKeyRef == NULL){
        return nil;
    }
    
    if ([data length] <= 0){
        return nil;
    }
    
    NSData *buffer = [self encryptData:[data dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:publicKeyRef];
    if (buffer) {
        CryptResult *result = [[CryptResult alloc] initWithBytes:(void *)[buffer bytes] length:(int)[buffer length]];
        return result;
    }
    
    return nil;
}

+ (CryptResult *)rsaDecryptWithBase64:(NSString *)data publicKeyRef:(SecKeyRef)publicKeyRef
{
    if (publicKeyRef == NULL){
        return nil;
    }
    
    if ([data length] <= 0){
        return nil;
    }
    
    NSData *buffer = [self decryptData:[data cc_base64DecodedData] withKeyRef:publicKeyRef];
    if (buffer) {
        CryptResult *result = [[CryptResult alloc] initWithBytes:(void *)[buffer bytes] length:(int)[buffer length]];
        return result;
    }
    
    return nil;
}

+ (CryptResult *)rsaEncrypt:(NSString *)data privateKeyRef:(SecKeyRef)privateKeyRef
{
    if (privateKeyRef == NULL){
        return nil;
    }
    
    if ([data length] <= 0){
        return nil;
    }
    
    NSData *buffer = [self encryptData:[data dataUsingEncoding:NSUTF8StringEncoding] withKeyRef:privateKeyRef];
    if (buffer) {
        CryptResult *result = [[CryptResult alloc] initWithBytes:(void *)[buffer bytes] length:(int)[buffer length]];
        return result;
    }
    
    return nil;
}

+ (CryptResult *)rsaDecryptWithBase64:(NSString *)data privateKeyRef:(SecKeyRef)privateKeyRef
{
    if (privateKeyRef == NULL){
        return nil;
    }
    
    if ([data length] <= 0){
        return nil;
    }
    
    NSData *buffer = [self decryptData:[data cc_base64DecodedData] withKeyRef:privateKeyRef];
    if (buffer) {
        CryptResult *result = [[CryptResult alloc] initWithBytes:(void *)[buffer bytes] length:(int)[buffer length]];
        return result;
    }
    
    return nil;
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef
{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef)keyRef
{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}
@end
