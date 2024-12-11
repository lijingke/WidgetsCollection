//
//  AppSidebarNavigation.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import SwiftUI

struct AppSidebarNavigation: View {
    @EnvironmentObject var model: ContentViewModel

    var body: some View {
        NavigationView {
            CategoriesList()
            InitialDetailsView(symbols: model.symbols)
        }
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
    }
}
