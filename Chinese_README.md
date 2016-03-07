# TSWeChat 中文说明
A [WeChat](https://itunes.apple.com/cn/app/wei/id414478124) alternative, written in Swift.

## 运行环境
- [Cocoapods](https://github.com/CocoaPods/CocoaPods) 0.39.0
- iOS 8.0+ / Mac OS X 10.9+
- Xcode 7.2+

### 文件目录

目录名称|介绍
---|---
Classes|主要存放项目中的不同业务的 `ViewController`，`View` ，`Model` 等文件，子文件夹按照业务逻辑划分。比如按照功能划分有 `Message`,`Address Book`,`Time`,`Me`,`Login` 子目录等
Classes/CoreModule|主要存放一些基础类库的业务逻辑的封装，比如`Network`,`Socket 引擎`,`Model文件夹`等
General|这个目录放会被重用的 Views/Classes 和 Categories，存放`和业务逻辑`相关的 `class`，比如颜色的分类，
Helpers|存放一些非业务逻辑的类或者 category
Macro|存放整个应用会用到的宏定义，常量名等，比如 `Notifications`名称，`页面 title 名称`，第三方库所使用的 key 等
Resources|存放资源文件，包括`Assets.xcassets`,`Media.xcassets`，`音频文件`，`plist 文件` 等
Vendor|存放一些第三方库，尽量使用`cocoapods`来管理，万不得已可以存放在这里
Supporting Files|项目原有的目录

## 第三方库
- [点击这里可以查看到 Podfile](https://github.com/hilen/TSWeChat/blob/master/Podfile)

## License

MIT license. 可以点击目录中 LICENSE 文件查看

