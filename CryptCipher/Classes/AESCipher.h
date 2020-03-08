//
//  AESCipher.h
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import <Foundation/Foundation.h>

@interface AESCipher : NSObject
@property(nonatomic, copy) NSString *aesKey;
- (NSString *)decryptWithBase64String:(NSString *)data;
- (NSString *)encryptString:(NSString *)data;
- (NSData *)encryptData:(NSData *)data;
- (NSData *)decryptData:(NSData *)data;
@end
