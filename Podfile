# ios/Podfile

# Définit la plateforme cible (iOS 13 minimum requis pour Firebase, etc.)
platform :ios, '13.0'

# Désactive les statistiques de CocoaPods
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

# Ne modifie pas cette partie — elle est utilisée par Flutter
plugin 'cocoapods-deep-lint'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  # Si tu utilises Firebase ou des plugins natifs, ajoute-les ici
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
