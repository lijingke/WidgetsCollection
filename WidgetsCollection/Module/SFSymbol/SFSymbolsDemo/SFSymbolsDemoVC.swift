//
//  SFSymbolsDemoVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation
import SwiftUI

class SFSymbolsDemoVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Loading.showLoading(to: view)
        DispatchQueue.global().async {
            let model = ContentViewModel()
            DispatchQueue.main.async {
                Loading.hideLoading(from: self.view)
                _ = self.addSwiftUIView(ContentView().environmentObject(model))
            }
        }
    }
}
