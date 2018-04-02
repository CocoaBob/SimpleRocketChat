Pod::Spec.new do |s|
  s.name              = "SimpleRocketChat"
  s.version           = "2.0.2"
  s.summary           = "A simpler version of RocketChat."
  s.homepage          = "https://github.com/CocoaBob/SimpleRocketChat"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "CocoaBob" => "mengke.wang@gmail.com" }
  s.social_media_url  = "http://twitter.com/CocoaBob"
  s.source            = { :git => "https://github.com/CocoaBob/SimpleRocketChat.git", :tag => "v#{s.version}" }
  s.platform          = :ios, '10.0'
  s.source_files      = "SimpleRocketChat/Sources/**/*.swift"
  s.resource          = "SimpleRocketChat/Resources/Assets.xcassets"
  s.resources         = "SimpleRocketChat/**/*.{png,xib,storyboard}"
  s.framework         = "Foundation", "UIKit", "UserNotifications"
  s.requires_arc      = true
  s.xcconfig          = { 'SWIFT_INCLUDE_PATHS' => '${PODS_ROOT}/SimpleRocketChat/ModuleMap/CommonCrypto' } 
  s.preserve_paths    = "ModuleMap/CommonCrypto/module.modulemap"
  s.dependency        "SwiftyJSON"
  s.dependency        "SlackTextViewController"
  s.dependency        "MobilePlayer"
  s.dependency        "SimpleImageViewer"
  s.dependency        "RCMarkdownParser"
  s.dependency        "RealmSwift"
  s.dependency        "SDWebImage"
  s.dependency        "SDWebImage/GIF"
  s.dependency        "Starscream"
  s.dependency        "ReachabilitySwift"
end