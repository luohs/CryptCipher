//
//  CryptResult.h
//  Pods
//
//  Created by luohs on 2017/9/11.
//
//

#import <Foundation/Foundation.h>

@interface CryptResult : NSObject
@property (strong, nonatomic, readonly) NSData *data; //orignal data
@property (strong, nonatomic, readonly) NSString *utf8String; //get plaintext
@property (strong, nonatomic, readonly) NSString *hex;//get md5 uper
@property (strong, nonatomic, readonly) NSString *hexLower; //get md5 lower
@property (strong, nonatomic, readonly) NSString *base64;//get ciphertext
- (id)initWithBytes:(unsigned char[])initData length:(NSUInteger)length;
@end
