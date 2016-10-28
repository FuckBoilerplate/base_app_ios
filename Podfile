source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

def shared_pods
    pod 'TPKeyboardAvoiding'
    
    pod 'SDWebImage', '~> 3.8'
    pod 'SnapKit', '~> 3.0.2'
    pod 'R.swift', '~> 3.1.0'
    
    pod 'OkDataSources'
    pod 'OkDataSources/RxSwift'
    
    pod 'SwiftGen'
    
    pod 'Alamofire', '~> 4.0'
    
    pod 'Google/CloudMessaging'
    
    pod 'PKHUD_Swift_3'
    
    pod 'Swinject', '2.0.0-beta.2'
    pod 'SwinjectStoryboard', '1.0.0-beta.2'
    
    pod 'RxSwift', '~> 3.0'
    
    pod 'ObjectMapper', '~> 2.0'
    
    pod 'RxCache', '~> 1.0.2'
    pod 'RxCache/ObjectMapper', '~> 1.0.2'
    
    pod 'Moya', '~> 8.0.0-beta.2'
    pod 'Moya/RxSwift'
    
    pod 'Moya-ObjectMapper', :git => 'https://github.com/ivanbruel/Moya-ObjectMapper'
    pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/ivanbruel/Moya-ObjectMapper'
end

target 'base-app-ios' do
    shared_pods
end

target 'base-app-iosTests' do
    shared_pods
    pod 'Nimble', '~> 5.0.0'
    pod 'RxTest', '~> 3.0'
end
