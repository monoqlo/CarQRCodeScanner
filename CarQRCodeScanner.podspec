#
# Be sure to run `pod lib lint CarQRCodeScanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CarQRCodeScanner'
  s.version          = '1.0.0'
  s.summary          = 'Japanese car inspection certificate QR code scanner'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Japanese car inspection certificate QR code scanner.
                       DESC

  s.homepage         = 'https://github.com/monoqlo/CarQRCodeScanner'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "monoqlo" => "monoqlo44@gmail.com" }
  s.source           = { :git => "https://github.com/monoqlo/CarQRCodeScanner.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/monoqlo'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CarQRCodeScanner/Source/**/*.swift'
  s.resources = ['CarQRCodeScanner/**/*.xcassets', 'CarQRCodeScanner/**/*.storyboard', 'CarQRCodeScanner/**/*.xib']
  s.frameworks = 'UIKit', 'AudioToolbox', 'ZXingObjC', 'QuartzCore'
  s.dependency 'ZXingObjC', '3.2.2'
end
