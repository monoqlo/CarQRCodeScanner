# CarQRCodeScanner

CarQRCodeScanner is Japanese car inspection certificate QR code scanner.

[![Version](https://img.shields.io/cocoapods/v/CarQRCodeScanner.svg?style=flat)](http://cocoapods.org/pods/CarQRCodeScanner)
[![License](https://img.shields.io/cocoapods/l/CarQRCodeScanner.svg?style=flat)](http://cocoapods.org/pods/CarQRCodeScanner)
[![Platform](https://img.shields.io/cocoapods/p/CarQRCodeScanner.svg?style=flat)](http://cocoapods.org/pods/CarQRCodeScanner)

![screenshot1](https://github.com/monoqlo/CarQRCodeScanner/blob/master/imgs/screenshot1.jpg)
![screenshot2](https://github.com/monoqlo/CarQRCodeScanner/blob/master/imgs/screenshot2.jpg)
![screenshot3](https://github.com/monoqlo/CarQRCodeScanner/blob/master/imgs/screenshot3.jpg)

## Requirements

- iOS 10.0+
- Swift 4.0+
- Xcode 9.2+

## Installation

### Carthage

You can install [Carthage](https://github.com/Carthage/Carthage) with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ExpandingMenu into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "monoqlo/CarQRCodeScanner" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `CarQRCodeScanner.framework` into your Xcode project.

Add runscript to your Xcode target.

```
Shell /bin/sh
/usr/local/bin/carthage copy-frameworks

Input Files
$(SRCROOT)/Carthage/Build/iOS/CarQRCodeScanner.framework
```

### CocoaPods

You can install [CocoaPods](http://cocoapods.org) with the following command:

```bash
$ gem install cocoapods
```

To integrate ExpandingMenu into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'CarQRCodeScanner', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

1. Instantiate `CarQRCodeScannerController`.
2. Set delegate to the instance.
3. You can get scan result from the delegate method.

### Sample

```swift
import CarQRCodeScanner

class ViewController: UIViewController {

    func showQRCodeScanner() {
        let scanner = CarQRCodeScannerController()
        scanner.scannerDelegate = self
        self.presentViewController(scanner, animated: true, completion: nil)
    }
}

extension ViewController: CarQRCodeScannerControllerDelegate {
    
    func qrScannerControllerDidCancel(scanner: CarQRCodeScannerController) {
        print("canceld!")
    }
    
    func qrScannerController(scanner: CarQRCodeScannerController, didFinishScanning certificate: CarInspectionCertificate) {
        print(certificate)
    }
    
}

```

### Result example
![example](https://github.com/monoqlo/CarQRCodeScanner/blob/master/imgs/example.jpg)
