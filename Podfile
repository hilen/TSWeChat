source 'https://github.com/CocoaPods/Specs.git'

platform:ios,'8.0'
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

def pods
    #Swift
    pod 'Alamofire', '~> 4.0'
    pod 'Kingfisher'
    pod 'ObjectMapper', '~> 2.2'
    pod 'SwiftyJSON'
    pod 'Dollar'
    pod 'Cent'
    pod 'KeychainAccess'
    pod 'UIColor_Hex_Swift', '~> 3.0.2'
    pod 'RxSwift', '~> 3.0'
    pod 'RxCocoa', '~> 3.0'
    pod 'RxBlocking', '~> 3.0'
    pod 'XCGLogger'
    pod 'SnapKit'
    pod 'BSImagePicker', '~> 2.5.0'
    pod 'TSVoiceConverter', '0.1.3'
    pod 'XLActionController'
    pod 'TimedSilver', '1.0.0'

    #Objective-C
    pod 'YYText'
    pod 'SVProgressHUD'
    pod 'INTULocationManager'
end

target 'TSWeChat' do
    pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'YES'
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
