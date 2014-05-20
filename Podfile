workspace 'TSMiniWebBrowser'

xcodeproj 'TSMiniWebBrowserDemo.xcodeproj'

pod 'TSMiniWebBrowser@dblock', :path => 'TSMiniWebBrowser@dblock.podspec'

target 'TSMiniWebBrowserDemoTests' do
  pod 'TSMiniWebBrowser@dblock', :path => 'TSMiniWebBrowser@dblock.podspec'
  pod 'Specta', '0.2.1'
  pod 'Expecta', '0.3.0'
  pod 'FBSnapshotTestCase', '1.1'
  pod 'EXPMatchers+FBSnapshotTest', '1.1.0'
  xcodeproj 'TSMiniWebBrowserDemo.xcodeproj'
end

target 'EmbeddedYoutubePatch' do
  pod 'TSMiniWebBrowser@dblock', :path => 'TSMiniWebBrowser@dblock.podspec'
  xcodeproj 'EmbeddedYoutubePatch.xcodeproj'
end
