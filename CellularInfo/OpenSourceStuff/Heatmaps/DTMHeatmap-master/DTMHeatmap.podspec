Pod::Spec.new do |s|
  s.name         = "DTMHeatmap"
  s.version      = "1.0"
  s.summary      = "An MKMapView overlay to visualize location data"
  s.homepage     = "https://github.com/dataminr/DTMHeatmap"
  s.license          = 'MIT'
  s.author             = { "Bryan Oltman" => "boltman@dataminr.com" }
  s.social_media_url = "http://twitter.com/moltman"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/dataminr/DTMHeatmap.git", :tag => '1.0' }
  s.source_files  = '*.{h,m}', 'Heatmaps/*', 'Color Providers/*'
  s.requires_arc = true
end
