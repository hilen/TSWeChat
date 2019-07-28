<p align="center">
  <img src="https://raw.githubusercontent.com/yeahdongcn/UIColor-Hex-Swift/master/home-hero-swift-hero.png">
</p>

UIColor+Hex, now Swift.
[![Build Status](https://travis-ci.org/yeahdongcn/UIColor-Hex-Swift.svg?branch=master)](https://travis-ci.org/yeahdongcn/UIColor-Hex-Swift) [![codecov.io](https://codecov.io/gh/yeahdongcn/UIColor-Hex-Swift/branch/master/graphs/badge.svg)](https://codecov.io/gh/yeahdongcn/UIColor-Hex-Swift/branch/master) ![](https://img.shields.io/badge/Swift-4.0-blue.svg?style=flat) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)
=================
Convenience method for creating autoreleased color using RGBA hex string.

```swift
    // Solid color
    let strokeColor = UIColor("#FFCC00").CGColor 
    
    // Color with alpha
    let fillColor = UIColor("#FFCC00DD").CGColor 

    // Supports shorthand 3 character representation
    let backgroundColor = UIColor("#FFF") 

    // Supports shorthand 4 character representation (with alpha)
    let menuTextColor = UIColor("#013E") 

    // "#FF0000FF"
    let hexString = UIColor.redColor().hexString()

    // Convert shorthand 4 character representation (with alpha) from argb to rgba
    if let rgba = "#AFFF".argb2rgba() {            
        let androidBackgroundColor = UIColor(rgba)
    }

    // Convert 8 character representation (with alpha) from argb to rgba
    if let rgba = "#AAFFFFFF".argb2rgba() {        
        let androidFrontColor = UIColor(rgba)
    }
```

## Installation

### [CocoaPods](http://cocoapods.org)

Simply add the following lines to your `Podfile`:
```ruby
# required by CocoaPods 0.36.0.rc.1 for Swift Pods
use_frameworks! 

pod 'UIColor_Hex_Swift', '~> 5.0.0'
```

Then import it where you use it:
```swift
import UIColor_Hex_Swift
```

*(CocoaPods v0.36 or later required. See [this blog post](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/) for details.)*

### [Carthage](http://github.com/Carthage/Carthage)

Simply add the following line to your `Cartfile`:

```ruby
github "yeahdongcn/UIColor-Hex-Swift" >= 5.0.0
```

Then add the HexColor.framework to your frameworks list in the Xcode project.

Then import it where you use it:
```swift
import HEXColor
```

---

See more in [RSBarcodes_Swift](https://github.com/yeahdongcn/RSBarcodes_Swift) and [objc version](https://github.com/yeahdongcn/RSBarcodes) 
