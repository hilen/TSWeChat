# BSGridCollectionViewLayout

[![CI Status](http://img.shields.io/travis/mikaoj/BSGridCollectionViewLayout.svg?style=flat)](https://travis-ci.org/mikaoj/BSGridCollectionViewLayout)
[![Version](https://img.shields.io/cocoapods/v/BSGridCollectionViewLayout.svg?style=flat)](http://cocoapods.org/pods/BSGridCollectionViewLayout)
[![License](https://img.shields.io/cocoapods/l/BSGridCollectionViewLayout.svg?style=flat)](http://cocoapods.org/pods/BSGridCollectionViewLayout)
[![Platform](https://img.shields.io/cocoapods/p/BSGridCollectionViewLayout.svg?style=flat)](http://cocoapods.org/pods/BSGridCollectionViewLayout)

BSGridCollectionViewLayout is a simple UICollectionViewLayout. It simply displays the items in a grid. It doesn't have a concept of sections. So even if the items are in different data source / sections. They will be displayed as being in one continuous grid without any section breaks. I highly doubt that anyone besides me will use this, but I'm using it in [BSImagePicker](https://github.com/mikaoj/BSImagePicker).

## Usage

There are 3 properties for you to tweak:
* itemsPerRow - Number of items per row
* itemSpacing - Spacing between items (vertical and horizontal)
* itemHeightRatio - The item height ratio relative to it's width

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 8

## Installation

BSGridCollectionViewLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BSGridCollectionViewLayout", "~> 1.0"
```

## Author

Joakim Gyllstrom, joakim@backslashed.se

## License

BSGridCollectionViewLayout is available under the MIT license. See the LICENSE file for more info.
