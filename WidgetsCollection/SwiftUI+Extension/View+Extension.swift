//
//  View+Extension.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation
import SwiftUI

extension View {
//    func commonShadow(color: Color = Color.color(hex: "#8CA2D2", alpha: 0.37), radius: CGFloat = fixSize(3.67), x: CGFloat = 0, y: CGFloat = fixSize(3.33)) -> some View {
//        self.shadow(color: color, radius: radius, x: x, y: y)
//    }

    func tranformToUIView() -> UIView {
        let hostingController = UIHostingController(rootView: self)
        let view = hostingController.view!
        view.backgroundColor = .clear
        return view
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
