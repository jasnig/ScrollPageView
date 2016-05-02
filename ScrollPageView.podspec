Pod::Spec.new do |s|
  s.name        = "ScrollPageView"
  s.version     = "0.1.1"
  s.summary     = "ScrollPageView is written in Swift and it is useful."
  s.homepage    = "https://github.com/jasnig/ScrollPageView"
  s.license     = { :type => "MIT" }
  s.authors     = { "ZeroJ" => "854136959@qq.com" }

  s.requires_arc = true
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.source   = { :git => "https://github.com/jasnig/ScrollPageView.git", :tag => s.version }
  s.framework  = "UIKit"
  s.source_files = "ScrollPageView/*.swift"

end
