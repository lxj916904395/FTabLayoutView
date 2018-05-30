Pod::Spec.new do |s|
  s.name         = "FTabLayoutView"
  s.version      = "0.0.1"
  s.summary      = "A view for tabs"
  s.description  = "A view for tabs show with cocoapod support."
  s.homepage     = "https://github.com/lxj916904395/FTabLayoutView"
  s.license= { :type => "MIT", :file => "LICENSE" }
  s.author       = { "lxj916904395" => "916904395@qq.com" }
  s.source       = { :git => "https://github.com/lxj916904395/FTabLayoutView.git", :tag => s.version.to_s }
  s.source_files = 'FTabLayoutView/*.{h,m}'
  s.ios.deployment_target = '6.0'
  s.frameworks   = 'UIKit'
  s.requires_arc = true
  s.public_header_files = 'FTabLayoutView/FTabLayoutView.h'
  s.dependency  = 'YYKit'


end
