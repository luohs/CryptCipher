# CryptCipher

[![CI Status](http://img.shields.io/travis/luohuasheng/CryptCipher.svg?style=flat)](https://travis-ci.org/luohuasheng/CryptCipher)
[![Version](https://img.shields.io/cocoapods/v/CryptCipher.svg?style=flat)](http://cocoapods.org/pods/CryptCipher)
[![License](https://img.shields.io/cocoapods/l/CryptCipher.svg?style=flat)](http://cocoapods.org/pods/CryptCipher)
[![Platform](https://img.shields.io/cocoapods/p/CryptCipher.svg?style=flat)](http://cocoapods.org/pods/CryptCipher)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CryptCipher is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CryptCipher'
```

## Author

luohuasheng, luohuasheng0225@gmail.com

## License

CryptCipher is available under the MIT license. See the LICENSE file for more info.

## 更新说明-0.5.0
废弃一些分类相关的接口，如下：
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

## 更新说明-0.5.1
去除警告
