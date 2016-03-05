# TSWeChat
A WeChat alternative, written in Swift.

## Requirements

- iOS 8.0+ / Mac OS X 10.9+
- Xcode 7.2+

## Preview
![demo1](https://cloud.githubusercontent.com/assets/16911734/13484861/a72aedcc-e13c-11e5-8fa2-33679c1a4223.gif)

![demo2](https://cloud.githubusercontent.com/assets/16911734/13484978/e372c16e-e13d-11e5-84e0-d8df04ea17e8.gif)

## Directory structure interpretation

Directory name|Introduction
---|---
Classes| Deposite different folders like `ViewController`, `View`. Sub directories are divided based on business logic, Such as `Message`,`Address Book`,`Tabbar`,`Me`,`Login` and etc, divided according to their functions. 
Classes/CoreModule| To deposite encapsulation of business logic of basic classes, like HttpManager, Models, ApplicationManager and etc.
General|To deposite reused `View and Class` related with business logic, such as color extension.
Helpers|Non-business logic extension, such as: `UIView+Extension.swift`, `UIImage+Resize.swift` and etc.
Macro|To deposite macros and constant definitions used in the whole application, such as ` Notifications ` name , and  the third party librarie's keys.
Resources| Resources. Such as `Assets.xcassets`, `Media.xcassets`, `JSON files`, `media files`, `plist files` and etc
Vendor| To deposite the third party liabraries that cannot be installed by `Cocoapods`.
Supporting Files| To deposite the original files

## Vendor
- [See more details](https://github.com/hilen/TSWeChat/blob/master/Podfile)

## License

TSWeChat is released under the MIT license. See LICENSE for details.

## To Do
- The custom photo album
- WeChat custom ActionSheet
- Long press the chat cell
- The image viewer
- GIf image cell in TSChatViewController
- QRCodeViewController
- ShakeViewController
- Send my address
- Viedo cell in TSChatViewController
- TimelineViewController
- And so on...

## [中文说明](Chinese_README.md)
