Pod::Spec.new do |s|
  s.name = "UGDropDown"
  s.version = "1.1"
  s.summary = "A simple drop down functionality implemented using UITableView in Swift"
  s.homepage = "https://github.com/kerry/UGDropDown"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "kerry" => "me@prateekgrover.com" }
  s.social_media_url = "http://facebook.com/grover.kerry"
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.source = { :git => "https://github.com/kerry/UGDropDown.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*.{swift,h,m}"
  s.requires_arc = true
  s.swift_version = "5.0"
end
