<p align="center">
  <img src="https://raw.githubusercontent.com/yeahdongcn/UIColor-Hex-Swift/master/home-hero-swift-hero.png">
</p>

UIColor+Hex, now Swift.
=================
Convenience method for creating autoreleased color using RGBA hex string.

    var strokeColor = UIColor(rgba: "#ffcc00").CGColor // Solid color
    
    var fillColor = UIColor(rgba: "#ffcc00dd").CGColor // Color with alpha

    var backgroundColor = UIColor(rgba: "#FFF") // Supports shorthand 3 character representation

    var menuTextColor = UIColor(rgba: "#013E") // Supports shorthand 4 character representation (with alpha)

    var hexString = UIColor.redColor().hexString(false) // "#FF0000"

##Installation

###[CocoaPods](http://cocoapods.org)

Simply add the following lines to your `Podfile`:
```ruby
# required by CocoaPods 0.36.0.rc.1 for Swift Pods
use_frameworks! 

pod 'UIColor_Hex_Swift', '~> 1.9'
```

Then import it where you use it:
```
import UIColor_Hex_Swift
```

*(CocoaPods v0.36 or later required. See [this blog post](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/) for details.)*

###[Carthage](http://github.com/Carthage/Carthage)

Simply add the following line to your `Cartfile`:

```ruby
github "yeahdongcn/UIColor-Hex-Swift" >= 1.9
```
=================
See more in [RSBarcodes_Swift](https://github.com/yeahdongcn/RSBarcodes_Swift) and [objc version](https://github.com/yeahdongcn/RSBarcodes) 
