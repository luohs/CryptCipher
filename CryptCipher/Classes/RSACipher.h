//
//  RSACipher.h
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import <Foundation/Foundation.h>

@interface RSACipher : NSObject
@property (nonatomic, copy) NSString *password;
+ (instancetype)cipher;
- (NSString *)publicEncrypt:(NSString *)plainData;
- (NSString *)privateDecrypt:(NSString *)cipherData;
//- (NSString *)privateEncrypt:(NSString *)plainData;
//- (NSString *)publicDecrypt:(NSString *)cipherData;
@end
