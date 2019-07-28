source 'https://github.com/CocoaPods/Specs.git'

platform:ios,'10.0'
use_frameworks!
# ignore all warnings from all pods
# inhibit_all_warnings!

def pods
    #Swift
    pod 'Alamofire', '~> 4.0'
    pod 'Kingfisher'
    pod 'ObjectMapper', '~> 3.4'
    pod 'SwiftyJSON', '~> 4.0'
    pod 'Dollar', '9.0.0'
    #pod 'Cent', :git => 'https://github.com/ashitanojoe/Cent.git'
    pod 'KeychainAccess', '3.2.0'
    pod 'UIColor_Hex_Swift', '~> 5.1.0'
    pod 'RxSwift', '~> 5'
    pod 'RxCocoa', '~> 5'
    pod 'RxBlocking', '~> 5'
    pod 'XCGLogger', '~> 7.0.0'
    pod 'SnapKit', '~> 5.0.0'
    pod "BSImagePicker", "~> 2.10.0"
    #pod 'ImagePicker'
    pod 'TSVoiceConverter', '0.1.6'
    pod 'XLActionController', '5.0.0'
    pod 'TimedSilver', '1.2.0'

    #Objective-C
    pod 'YYText', '1.0.7'
    pod 'SVProgressHUD', '2.0.4'
    pod 'INTULocationManager', '4.3.2'

    pod 'Reveal-SDK', '~> 4', :configurations => ['Debug']
end

target 'TSWeChat' do
    pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'YES'
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
