//
//  SHACrypt.h
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import <Foundation/Foundation.h>
#import "CryptResult.h"

@interface SHACrypt : NSObject
#pragma mark - SHA
+ (CryptResult *)sha1:(NSString *)hashString;
+ (CryptResult *)sha1WithData:(NSData *)hashData;
+ (CryptResult *)sha224:(NSString *)hashString;
+ (CryptResult *)sha224WithData:(NSData *)hashData;
+ (CryptResult *)sha256:(NSString *)hashString;
+ (CryptResult *)sha256WithData:(NSData *)hashData;
+ (CryptResult *)sha384:(NSString *)hashString;
+ (CryptResult *)sha384WithData:(NSData *)hashData;
+ (CryptResult *)sha512:(NSString *)hashString;
+ (CryptResult *)sha512WithData:(NSData *)hashData;
#pragma mark HMAC-SHA
+ (CryptResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha1WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha224WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha256WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha384WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key;
+ (CryptResult *)hmacSha512WithData:(NSData *)hashData hmacKey:(NSString *)key;
@end
