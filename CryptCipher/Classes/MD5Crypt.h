//
//  MD5Crypt.h
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import <Foundation/Foundation.h>
#import "CryptResult.h"

@interface MD5Crypt : NSObject
#pragma mark - MD5
+ (CryptResult *)md5:(NSString *)hashString;
+ (CryptResult *)md5WithData:(NSData *)hashData;
#pragma mark HMAC-MD5
+ (CryptResult *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key;
+ (CryptResult *)hmacMd5WithData:(NSData *)hashData hmacKey:(NSString *)key;
@end
