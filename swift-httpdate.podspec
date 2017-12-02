Pod::Spec.new do |s|
  s.name         = "swift-httpdate"
  s.version      = "0.0.1"
  s.summary      = "provides functions that deal the date formats used by the HTTP protocol (and then some more)."
  s.homepage     = "https://github.com/hiroraba/swift-httpdate"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Hiroki Matsuo" => "xornelius0313@gmail.com" }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/hiroraba/swift-httpdate.git", :tag => s.version.to_s }
  s.source_files  = "Sources/*.swift"
end
