#
# Be sure to run `pod lib lint CryptCipher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CryptCipher'
  s.version          = '0.5.1'
  s.summary          = 'A short description of CryptCipher.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/luohuasheng/CryptCipher'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luohuasheng' => 'luohuasheng0225@gmail.com' }
  # s.source           = { :svn => 'https://10.7.12.91/repo/EHDiOS/trunk/EHDComponentRepo/CryptCipher', :tag => s.version.to_s }
  s.source           = { :git => 'http://gitlab.tf56.lo/tfic-frontend-client/ios-components-repo/common/cryptcipher.git', :tag => s.version.to_s }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.subspec "Coder" do |ss|
  ss.source_files = ['CryptCipher/Classes/CryptCoder.{m,mm,h}',]
  end

  s.subspec "Utils" do |ss|
  ss.source_files = ['CryptCipher/Classes/CryptResult.{m,mm,h}']
  ss.dependency 'CryptCipher/Coder'
  end

  s.subspec "SHA" do |ss|
    ss.source_files = ['CryptCipher/Classes/SHACrypt.{m,mm,h}']
    ss.dependency 'CryptCipher/Utils'
  end

  s.subspec "MD5" do |ss|
    ss.source_files = ['CryptCipher/Classes/MD5Crypt.{m,mm,h}']
    ss.dependency 'CryptCipher/Utils'
  end

  s.subspec "AES" do |ss|
  ss.source_files = ['CryptCipher/Classes/AESCipher.{m,mm,h}','CryptCipher/Classes/AESCrypt.{m,mm,h}']
  ss.dependency 'CryptCipher/Utils'
  ss.dependency 'CryptCipher/SHA'
  end

  s.subspec "DES" do |ss|
    ss.source_files = ['CryptCipher/Classes/DESCrypt.{m,mm,h}']
    ss.dependency 'CryptCipher/Utils'
  end

  s.subspec "RSA" do |ss|
    ss.source_files = ['CryptCipher/Classes/RSACipher.{m,mm,h}','CryptCipher/Classes/RSACrypt.{m,mm,h}']
    ss.dependency 'CryptCipher/Utils'
  end

  # s.resource_bundles = {
  #   'CryptCipher' => ['CryptCipher/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
