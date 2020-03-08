//
//  AESCrypt.h
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import <Foundation/Foundation.h>
#import "CryptResult.h"

@interface AESCrypt : NSObject
#pragma mark - AES Encrypt
+ (CryptResult *)aesEncrypt:(NSString *)data key:(NSString *)key;
+ (CryptResult *)aesEncrypt:(NSString *)data key:(NSData *)key iv:(NSData *)iv;
+ (CryptResult *)aesEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
#pragma mark AES Decrypt
+ (CryptResult *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key;
+ (CryptResult *)aesDecryptWithBase64:(NSString *)data key:(NSData *)key iv:(NSData *)iv;
+ (CryptResult *)aesDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
@end
