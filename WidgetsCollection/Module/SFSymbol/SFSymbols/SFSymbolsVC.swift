//
//  SFSymbolsVC.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation
import SwiftUI

class SFSymbolsVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Loading.showLoading(to: view)
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                Loading.hideLoading(from: self.view)
                _ = self.addSwiftUIView(SymbolList())
            }
        }
    }
}
