# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WidgetsCollection' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WidgetsCollection
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift'
  pod 'Reveal-SDK', :configurations => ['Debug']
  pod 'SnapKit'
  pod 'Tiercel'
  pod 'TZImagePickerController'
  pod 'HandyJSON'
  pod 'SDWebImage'
  pod 'MBProgressHUD'
  pod 'MJRefresh'
  pod 'WCDB.swift'
  pod 'MJRefresh'	
  pod 'SwiftyJSON'
  pod 'R.swift'
  pod 'ActiveLabel'

  target 'WidgetsCollectionTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WidgetsCollectionUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
       end
    end
  end
end