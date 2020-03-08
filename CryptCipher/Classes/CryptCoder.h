//
//  CryptCoder.h
//  CryptCipher
//
//  Created by luohs on 2017/11/23.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)
- (NSString *)cc_base64EncodedString;
@end

@interface NSString (Base64)
- (NSString *)cc_base64EncodedString;
- (NSString *)cc_base64DecodedString;
- (NSData *)cc_base64DecodedData;
@end

@interface NSData (Hex)
- (NSString *)cc_hexString;
- (NSString *)cc_hexStringLower;
@end

@interface NSString (Hex)
- (NSData *)cc_hexData;
@end

@interface NSData (odd)
- (instancetype)cc_removeOddLocation;
- (instancetype)cc_addRandomValueAtOddLocation;
- (instancetype)cc_shiftValue:(NSInteger)value;
@end

#pragma mark - Deprecated
@interface NSData (Base64Deprecated)
- (NSString *)base64EncodedString DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_base64EncodedString instead");
@end

@interface NSData (HexDeprecated)
- (NSString *)hexString DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_hexString instead");
- (NSString *)hexStringLower DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_hexStringLower instead");
- (NSString *)tf_hexString DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_hexString instead");
- (NSString *)tf_hexStringLower DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_hexStringLower instead");
@end

@interface NSData (oddDeprecated)
- (instancetype)removeOddLocation DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_removeOddLocation instead");
- (instancetype)addRandomValueAtOddLocation DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_addRandomValueAtOddLocation instead");
- (instancetype)shiftValue:(NSInteger)value DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_shiftValue: instead");
@end

@interface NSString (Base64Deprecated)
- (NSString *)base64EncodedString DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_base64EncodedString instead");
- (NSString *)base64DecodedString DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_base64DecodedString instead");
- (NSData *)base64DecodedData DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_base64DecodedData instead");
@end

@interface NSString (HexDeprecated)
- (NSData *)hex DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_hexData instead");
- (NSData *)tf_hex DEPRECATED_MSG_ATTRIBUTE("0.5.0 Use cc_hexData instead");
@end
