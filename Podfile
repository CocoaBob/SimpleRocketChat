source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target 'SimpleRocketChat' do
  # Code utilities
  pod "SwiftyJSON"

  # UI
  pod "SlackTextViewController", :git => 'https://github.com/rafaelks/SlackTextViewController.git'
  pod "MobilePlayer"
  pod "SimpleImageViewer", :git => 'https://github.com/cardoso/SimpleImageViewer.git'
  
  # Text Processing
  pod "RCMarkdownParser", :git => 'https://github.com/RocketChat/RCMarkdownParser.git'

  # Database
  pod "RealmSwift"

  # Network
  pod "SDWebImage", '~> 4'
  pod "SDWebImage/GIF"
  pod "Starscream"
  pod "ReachabilitySwift"
end

post_install do |installer|
  swift4Targets = []
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.1'
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
    if swift4Targets.include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
end

