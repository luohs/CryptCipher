//
//  RSACipher.m
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import "RSACipher.h"
#import "RSACrypt.h"

@implementation RSACipher
+ (instancetype)cipher
{
    RSACipher *cipher = [[self alloc] init];
    cipher.password = @"123456";
    return cipher;
}

+ (NSSet *)certificatesInBundle:(NSBundle *)bundle ofType:(NSString *)ext
{
    NSArray *paths = [bundle pathsForResourcesOfType:ext inDirectory:@"."];
    if (paths.count<=0) {
        paths = [[NSBundle mainBundle] pathsForResourcesOfType:ext inDirectory:@"."];
    }
    NSMutableSet *certificates = [NSMutableSet setWithCapacity:[paths count]];
    for (NSString *path in paths) {
        NSData *certificateData = [NSData dataWithContentsOfFile:path];
        [certificates addObject:certificateData];
    }
    
    return [NSSet setWithSet:certificates];
}

+ (NSSet *)defaultPublicCertificates
{
    static NSSet *_defaultPublicCertificates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _defaultPublicCertificates = [self certificatesInBundle:bundle ofType:@"der"];
    });
    
    return _defaultPublicCertificates;
}

+ (NSSet *)defaultPrivateCertificates
{
    static NSSet *_defaultPrivateCertificates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _defaultPrivateCertificates = [self certificatesInBundle:bundle ofType:@"p12"];
    });
    
    return _defaultPrivateCertificates;
}

- (NSString *)publicEncrypt:(NSString *)plainData
{
    for (NSData *cert in [RSACipher defaultPublicCertificates]){
        SecKeyRef publicKeyRef = [RSACrypt publicKeyRef:cert];
        if (publicKeyRef){
            return [[RSACrypt rsaEncrypt:plainData publicKeyRef:publicKeyRef] base64];
        }
    }
    return nil;
}

- (NSString *)privateDecrypt:(NSString *)cipherData
{
    for (NSData *cert in [RSACipher defaultPrivateCertificates]){
        SecKeyRef privateKeyRef = [RSACrypt privateKeyRef:cert password:self.password];
        if (privateKeyRef){
            return [[RSACrypt rsaDecryptWithBase64:cipherData privateKeyRef:privateKeyRef] utf8String];
        }
    }
    return nil;
}

- (NSString *)privateEncrypt:(NSString *)plainData
{
    for (NSData *cert in [RSACipher defaultPrivateCertificates]){
        SecKeyRef privateKeyRef = [RSACrypt privateKeyRef:cert password:self.password];
        if (privateKeyRef){
            return [[RSACrypt rsaEncrypt:plainData privateKeyRef:privateKeyRef] base64];
        }
    }
    return nil;
}

- (NSString *)publicDecrypt:(NSString *)cipherData
{
    for (NSData *cert in [RSACipher defaultPublicCertificates]){
        SecKeyRef publicKeyRef = [RSACrypt publicKeyRef:cert];
        if (publicKeyRef){
            return [[RSACrypt rsaDecryptWithBase64:cipherData publicKeyRef:publicKeyRef] utf8String];
        }
    }
    return nil;
}
@end
