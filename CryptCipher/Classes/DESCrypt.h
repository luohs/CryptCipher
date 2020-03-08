//
//  DESCrypt.h
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import <Foundation/Foundation.h>
#import "CryptResult.h"

@interface DESCrypt : NSObject
#pragma mark - DES Encrypt
+ (CryptResult *)desEncrypt:(NSString *)data key:(NSString *)key;
+ (CryptResult *)desEncrypt:(NSString *)data key:(NSData *)key iv:(NSData *)iv;
+ (CryptResult *)desEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
#pragma mark DES Decrypt
+ (CryptResult *)desDecryptWithBase64:(NSString *)data key:(NSString *)key;
+ (CryptResult *)desDecryptWithBase64:(NSString *)data key:(NSData *)key iv:(NSData *)iv;
+ (CryptResult *)desDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;
@end
