platform :ios, '13.0'

target 'Board' do
  use_frameworks!
  pod 'YogaKit'
#  pod 'PinLayout'
  pod 'SnapKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
