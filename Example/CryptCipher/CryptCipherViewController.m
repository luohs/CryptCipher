//
//  CryptCipherViewController.m
//  CryptCipher
//
//  Created by luohuasheng on 09/12/2017.
//  Copyright (c) 2017 luohuasheng. All rights reserved.
//

#import "CryptCipherViewController.h"

#import <CryptCipher/RSACipher.h>
#import <CryptCipher/AESCipher.h>
#import <CryptCipher/DESCrypt.h>
#import <CryptCipher/MD5Crypt.h>
#import <CryptCipher/CryptCoder.h>
#import <CryptCipher/CryptResult.h>
#import <MJExtension/MJExtension.h>

@interface model : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSNumber *jobcard;
@end

@implementation model
- (id)init
{
    self = [super init];
    if (self) {
        self.name = @"**胜";
        self.nick = @"花生";
        self.account = @"luohuasheng";
        self.password = @"123456";
        self.address = @"杭州";
        self.job = @"iOS";
        self.jobcard = @1000;
    }
    return self;
}
@end
@interface CryptCipherViewController ()

@end

@implementation CryptCipherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *plain = @"transfar";
    NSString *key = @"$&%@.!^~1234567812345678";
    
    Byte iv[] = {7, 0, 1, 2, 1, 4, 5, 5};
    NSData *data = [NSData dataWithBytes:iv length:8];
    NSData *keydata = [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    CryptResult *desen2 = [DESCrypt desEncrypt:plain key:keydata iv:data];
    CryptResult *desor2 = [DESCrypt desDecryptWithBase64:[desen2 base64] key:keydata iv:data];
    NSLog(@"-------------------------------DES----------------------------\n");
    NSLog(@"DES明文:");
    NSLog(@"%@\n", plain);
    NSLog(@"DES加密:");
    NSLog(@"%@\n", [desen2 base64]);
    NSLog(@"DES解密:");
    NSLog(@"%@\n", [desor2 utf8String]);
    
    CryptResult *md52 = [MD5Crypt md5:plain];
    NSLog(@"-------------------------------MD5----------------------------\n");
    NSLog(@"MD5明文:");
    NSLog(@"%@\n", plain);
    NSLog(@"MD5密文:");
    NSLog(@"%@\n", [md52 base64]);

    
    AESCipher *cipher = [[AESCipher alloc] init];
    cipher.aesKey = key;
    NSString *data2 = [cipher encryptString:plain];
    NSString *s2 = [cipher decryptWithBase64String:data2];
    NSLog(@"-------------------------------AES----------------------------\n");
    NSLog(@"AES明文:");
    NSLog(@"%@\n", plain);
    NSLog(@"AES密钥:");
    NSLog(@"%@\n", cipher.aesKey);
    NSLog(@"AES加密:");
    NSLog(@"%@\n", data2);
    NSLog(@"AES解密:");
    NSLog(@"%@\n", s2);
    
    model *m = [[model alloc] init];
    NSString *json = [m mj_JSONString];
    NSData *plainData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainEN = [cipher encryptData:plainData];
    NSData *plainDE = [cipher decryptData:plainEN];
    NSString *string = [[NSString alloc] initWithData:plainDE encoding:NSUTF8StringEncoding];
    NSLog(@"AES明文:");
    NSLog(@"%@\n", json);
    NSLog(@"AES密钥:");
    NSLog(@"%@\n", cipher.aesKey);
    NSLog(@"AES加密:");
    NSLog(@"%@\n", [plainEN cc_base64EncodedString]);
    NSLog(@"AES解密:");
    NSLog(@"%@\n", string);
    
    
    RSACipher *rsa = [RSACipher cipher];
    NSString *pub_en1 = [rsa publicEncrypt:plain];
    NSString *plain1 = [rsa privateDecrypt:pub_en1];
    NSLog(@"-------------------------------RSA----------------------------\n");
    NSLog(@"RSA明文:");
    NSLog(@"%@\n", plain);
    NSLog(@"RSA公钥加密:");
    NSLog(@"%@\n", pub_en1);
    NSLog(@"RSA私钥解密:");
    NSLog(@"%@\n", plain1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
