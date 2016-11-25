Pod::Spec.new do |s|
  s.name = 'PPAsyncDrawingKit'
  s.version = '1.0.0'

  s.ios.deployment_target = '7.0'

  s.license = 'MIT'
  s.summary = 'Asynchronous image downloader with cache support with an UIImageView category.'
  s.homepage = 'https://github.com/DSKcpp/PPAsyncDrawingKit'
  s.author = { 'DSKcpp' => 'dskcpp@gmail.com' }
  s.source = { :git => 'https://github.com/DSKcpp/PPAsyncDrawingKit.git', :tag => s.version.to_s }

  s.description = 'iOS async drawing kit'

  s.requires_arc = true
  s.framework = 'CoreText'
end