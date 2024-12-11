//
//  ContentView.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import Foundation
import SwiftUI

struct ContentView: View {

#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif

    var body: some View {
#if os(iOS)

        if horizontalSizeClass == .compact {
            AppTabNavigation()
        } else {
            AppSidebarNavigation()
        }
#else
        AppSidebarNavigation()
            .frame(minWidth: 600, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
