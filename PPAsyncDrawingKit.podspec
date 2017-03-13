Pod::Spec.new do |s|

  s.name = 'PPAsyncDrawingKit'
  s.version = '1.0.2'

  s.ios.deployment_target = '7.0'

  s.license = 'MIT'
  s.summary = 'iOS asynchronously drawing view Kit. '
  s.homepage = 'https://github.com/DSKcpp/PPAsyncDrawingKit'
  s.author = { 'DSKcpp' => 'dskcpp@gmail.com' }
  s.source = { :git => 'https://github.com/DSKcpp/PPAsyncDrawingKit.git', :tag => s.version.to_s }

  s.description = 'This is a kit for asynchronously drawing view, implementation of the ImageView, Label, Button.'
  
  s.source_files = "PPAsyncDrawingKit/*.{h,m}"
  s.requires_arc = true
  s.framework = 'CoreText'
end