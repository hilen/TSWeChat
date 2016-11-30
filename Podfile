source 'https://github.com/CocoaPods/Specs.git'

platform:ios,'8.0'
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

def pods
    #Swift
    pod 'Alamofire', '~> 4.0'
    pod 'Kingfisher', '3.2.1'
    pod 'ObjectMapper', '~> 2.2'
    pod 'SwiftyJSON', '3.1.3'
    pod 'Dollar', '6.1.0'
    pod 'Cent', '6.0.3'
    pod 'KeychainAccess', '3.0.1'
    pod 'UIColor_Hex_Swift', '~> 3.0.2'
    pod 'RxSwift', '~> 3.0'
    pod 'RxCocoa', '~> 3.0'
    pod 'RxBlocking', '~> 3.0'
    pod 'XCGLogger', '4.0.0'
    pod 'SnapKit', '3.0.2'
    pod 'BSImagePicker', '~> 2.5.0'
    pod 'TSVoiceConverter', '0.1.3'
    pod 'XLActionController', '3.0.1'
    pod 'TimedSilver', '1.0.0'

    #Objective-C
    pod 'YYText', '1.0.7'
    pod 'SVProgressHUD', '2.0.4'
    pod 'INTULocationManager', '4.2.0'
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
