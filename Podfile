# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'ZhihuDaily' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ZhihuDaily
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'NSObject+Rx'
  pod 'Kingfisher'
  pod 'MJRefresh'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['SWIFT_WHOLE_MODULE_OPTIMIZATION'] = 'YES'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
    end
  end
end
