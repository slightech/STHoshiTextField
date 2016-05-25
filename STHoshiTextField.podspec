Pod::Spec.new do |s|

  s.name         = "STHoshiTextField"
  s.version      = "1.0.0"
  s.summary      = "STHoshiTextField for ios"
  s.homepage     = 'https://github.com/slightech/STHoshiTextField'
  s.author       = { 'robinge' => 'robinge@slightech.com' }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = { :git => 'https://github.com/slightech/STHoshiTextField.git', :tag => "#{s.version}"}

  s.ios.deployment_target = '7.0'

  s.source_files = 'STHoshiTextField/*.{h,m}'
  s.framework = 'UIKit'
  s.requires_arc = true

end
