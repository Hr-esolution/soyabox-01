# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics disabled
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
