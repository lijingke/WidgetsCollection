# Uncomment the next line to define a global platform for your project
platform :ios, '17.5'
source 'https://github.com/CocoaPods/Specs.git'
target 'WidgetsCollection' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WidgetsCollection
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift'
  pod 'LookinServer', :configurations => ['Debug']
  pod 'SnapKit'
  pod 'Tiercel'
  pod 'TZImagePickerController'
  pod 'HandyJSON', :git => 'https://github.com/Miles-Matheson/HandyJSON.git'
  pod 'SDWebImage'
  pod 'MBProgressHUD'
  pod 'MJRefresh'
  pod 'WCDB.swift'
  pod 'MJRefresh'	
  pod 'SwiftyJSON'
  pod 'R.swift'
  pod 'ActiveLabel'
  # 权限管理
  pod 'PermissionsKit/CameraPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  pod 'PermissionsKit/PhotoLibraryPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  pod 'PermissionsKit/MediaLibraryPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  pod 'PermissionsKit/BluetoothPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  pod 'PermissionsKit/HealthPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  # FLEX
  pod 'FLEX', :configurations => ['Debug']
  pod 'atlantis-proxyman'
  # 设别信息
  pod 'DeviceKit'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.5'
       end
    end
  end
end