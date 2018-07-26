source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target 'SimpleRocketChat' do
  # Code utilities
  pod "SwiftyJSON"

  # UI
  pod "SlackTextViewController", :git => 'https://github.com/CocoaBob/SlackTextViewController.git', :commit => '4542e7e2f545b92724954e4276fde9a672f63d92'
  pod "MobilePlayer", :git => 'https://github.com/CocoaBob/mobileplayer-ios.git', :commit => '3f2d70ee1f6aeb1d1948ff360a150f2bfef6f013'
  pod "SimpleImageViewer", :git => 'https://github.com/CocoaBob/SimpleImageViewer.git', :commit => 'b204125b9bb39949c380fd3bcc756312d2680d36'
  
  # Text Processing
  pod "RCMarkdownParser", :git => 'https://github.com/CocoaBob/RCMarkdownParser.git', :branch => 'chore/swift-4', :commit => 'de5fb68a498259d53ceab6dc729a5a30770fef14'

  # Database
  pod "RealmSwift"

  # Network
  pod "SDWebImage", '~> 4'
  pod "SDWebImage/GIF"
  pod "Starscream"
  pod "ReachabilitySwift"
end
