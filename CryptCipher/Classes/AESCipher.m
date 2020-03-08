//
//  AESCipher.m
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import "AESCipher.h"
#import "CryptCoder.h"
#import "AESCrypt.h"

@implementation AESCipher
{
    NSUInteger _cryptDataOdd;
}
@synthesize aesKey = _aesKey;

+ (instancetype)initWithAesKey:(NSString *)aesKey
{
    return [[[self class] alloc] initWithAesKey:aesKey];
}

- (id)init
{
    return [self initWithAesKey:nil];
}

- (id)initWithAesKey:(NSString *)aesKey
{
    self = [super init];
    if (self){
        self.aesKey = [aesKey length]?aesKey:[[self getKey:128] cc_base64EncodedString];
        _cryptDataOdd = 10;
    }
    return self;
}

- (void)setAesKey:(NSString *)aesKey
{
    if ([aesKey length]){
        _aesKey = [aesKey copy];
    }
}

- (NSData *)getKey:(NSUInteger)size
{
    static const uint8_t kKeychainIdentifier[] = "com.apple.hz.tf.security.crypt.cipher";
    NSData *tag = [[NSData alloc] initWithBytesNoCopy:(void *)kKeychainIdentifier
                                               length:sizeof(kKeychainIdentifier)
                                         freeWhenDone:NO];
    
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassKey,
                            (__bridge id)kSecAttrApplicationTag: tag,
                            (__bridge id)kSecAttrKeySizeInBits: @512,
                            (__bridge id)kSecReturnData: @YES};
    
    CFTypeRef dataRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataRef);
    if (status == errSecSuccess) {
        return (__bridge NSData *)dataRef;
    }
    
    size = size<64?64:size;
    uint8_t buffer[size];
    __unused int secReturnValue = SecRandomCopyBytes(kSecRandomDefault, size, buffer);
    NSData *keyData = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
    
    query = @{(__bridge id)kSecClass: (__bridge id)kSecClassKey,
              (__bridge id)kSecAttrApplicationTag: tag,
              (__bridge id)kSecAttrKeySizeInBits: @512,
              (__bridge id)kSecValueData: keyData};
    
    status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    NSAssert(status == errSecSuccess, @"Failed to insert new key in the keychain");
    
    return keyData;
}

- (NSString *)decryptWithBase64String:(NSString *)string
{
    NSData *d = [string cc_base64DecodedData];
    d = [[d cc_removeOddLocation] cc_shiftValue:-_cryptDataOdd];
    CryptResult *cryptResult = [AESCrypt aesDecryptWithBase64:[d cc_base64EncodedString] key:self.aesKey];
    return [cryptResult utf8String];
}

- (NSString *)encryptString:(NSString *)string
{
    CryptResult *cryptResult = [AESCrypt aesEncrypt:string key:self.aesKey];
    return [[[cryptResult.data cc_addRandomValueAtOddLocation] cc_shiftValue:_cryptDataOdd] cc_base64EncodedString];
}

- (NSData *)decryptData:(NSData *)data
{
    if ([data length]){
        NSString *base64 = [data cc_base64EncodedString];
        NSString *string = [self decryptWithBase64String:base64];
        return [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (NSData *)encryptData:(NSData *)data
{
    if ([data length]){
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *base64 = [self encryptString:string];
        return [base64 cc_base64DecodedData];
    }
    return nil;
}
@end
