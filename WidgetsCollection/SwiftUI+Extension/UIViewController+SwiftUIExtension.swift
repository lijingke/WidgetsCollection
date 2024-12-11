//
//  UIViewController+SwiftUIExtension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation
import SwiftUI
extension UIViewController {
    func addSwiftUIView(_ swiftUIView : some View,addSubController : Bool = false) -> UIView{
        let swiftUIHostingController = UIHostingController(rootView: swiftUIView)
        // 将UIHostingController的视图添加到当前视图控制器的视图层次结构中
        let uiView = swiftUIHostingController.view!
        view.addSubview(uiView)
        uiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        uiView.frame = view.bounds
        if addSubController{
            addChild(swiftUIHostingController)
            swiftUIHostingController.didMove(toParent: self)
        }
        return uiView
    }
}
