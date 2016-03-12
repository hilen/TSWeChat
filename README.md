# TSWeChat
[![Travis](https://img.shields.io/travis/rust-lang/rust.svg)](https://github.com/hilen/TSWeChat)&nbsp;
![Program Language](https://img.shields.io/badge/Swift-compatible-orange.svg)&nbsp;
![Support](https://img.shields.io/badge/platform-iOS%208.0%2B-ff69b4.svg)&nbsp;
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/hilen/TSWeChat/blob/master/LICENSE)&nbsp;
[![codebeat](https://codebeat.co/badges/6eb4d97c-36f9-4b91-906f-ae4a8b38af30)](https://codebeat.co/projects/github-com-hilen-tswechat)


A [WeChat](https://itunes.apple.com/cn/app/wei/id414478124) alternative, written in Swift.

## Requirements
- [Cocoapods](https://github.com/CocoaPods/CocoaPods) 0.39.0
- iOS 8.0+ / Mac OS X 10.9+
- Xcode 7.2+


## Features
- Send your rich text, expression, image and voice.
- The cell image in `TSChatImageCell` is drawn by using `Mask Layer` . The chat background can be changed freely so that UI will look perfect.
- Custom expression keyboard, custom tool keyboard.
- Audio `wav` files can be automatically converted into `amr` files which facilite file transfer to Android devices. Both of the two type files have been doing cache.
- When you tap the `TSChatVoiceCell`. It will automatically check the cache and download it by [Alamofire](https://github.com/Alamofire/Alamofire). 
- When you send the image, it will be stored locally by using the caching mechanism of [Kingfisher](https://github.com/onevcat/Kingfisher). After successfully uploaded, it will be automatically modified to image link's `MD5` value file name.
- The data are loaded from the JSON file. All the `Models` are created via [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) which is easy to convert model objects (classes and structs) from JSON.


## Preview
![demo1](https://cloud.githubusercontent.com/assets/16911734/13484861/a72aedcc-e13c-11e5-8fa2-33679c1a4223.gif)

![demo2](https://cloud.githubusercontent.com/assets/16911734/13484978/e372c16e-e13d-11e5-84e0-d8df04ea17e8.gif)

## Directory

Directory name|Introduction
---|---
Classes| To deposit different folders like `ViewController`, `View`. Sub directories are divided based on business logic, Such as `Message`,`Address Book`,`Tabbar`,`Me`,`Login` and etc, divided according to their functions. 
Classes/CoreModule| To deposit encapsulation of business logic of basic classes, like HttpManager, Models, ApplicationManager and etc.
General|To deposit reused `View and Class` related with business logic, such as color extension.
Helpers|Non-business logic extension, such as: `UIView+Extension.swift`, `UIImage+Resize.swift` and etc.
Macro|To deposit macros and constant definitions used in the whole application, such as ` Notifications ` name , and  the third party librarie's keys.
Resources| Resources. Such as `Assets.xcassets`, `Media.xcassets`, `JSON files`, `media files`, `plist files` and etc
Vendor| To deposit the third party liabraries that cannot be installed by `Cocoapods`.
Supporting Files| To deposit the original files

## Vendor
- [See more details](https://github.com/hilen/TSWeChat/blob/master/Podfile)

## License

TSWeChat is released under the MIT license. See [LICENSE](https://github.com/hilen/TSWeChat/blob/master/LICENSE) for details.

## To Do
- The custom photo album
- WeChat custom ActionSheet
- Long press the chat cell
- The image viewer
- Address book
- GIF image cell in TSChatViewController
- QRCodeViewController
- ShakeViewController
- Send my address
- Video cell in TSChatViewController
- TimelineViewController
- Multilanguage support
- And so on...

## [中文说明](Chinese_README.md)
