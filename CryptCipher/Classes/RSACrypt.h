//
//  RSACrypt.h
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import <Foundation/Foundation.h>
#import "CryptResult.h"

@interface RSACrypt : NSObject
+ (SecKeyRef)publicKeyRef:(NSData *)certData;
+ (SecKeyRef)privateKeyRef:(NSData *)p12Data password:(NSString*)password;
+ (CryptResult *)rsaEncrypt:(NSString *)data publicKeyRef:(SecKeyRef)publicKeyRef;
+ (CryptResult *)rsaDecryptWithBase64:(NSString *)data publicKeyRef:(SecKeyRef)publicKeyRef;
+ (CryptResult *)rsaEncrypt:(NSString *)data privateKeyRef:(SecKeyRef)privateKeyRef;
+ (CryptResult *)rsaDecryptWithBase64:(NSString *)data privateKeyRef:(SecKeyRef)privateKeyRef;
@end
