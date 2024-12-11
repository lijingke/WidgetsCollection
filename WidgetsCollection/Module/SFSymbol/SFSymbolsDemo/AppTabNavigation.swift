//
//  AppTabNavigation.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

#if os(iOS)
import SFSymbols
import SwiftUI

struct AppTabNavigation: View {
    @State private var tabSelection = Tab.home
    @EnvironmentObject var model: ContentViewModel

    enum Tab {
        case home, categories
    }

    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                InitialDetailsView(symbols: model.symbols)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Home", symbol: .house)
                    .accessibility(label: Text("Home"))
            }
            .tag(Tab.home)

            NavigationView {
                CategoriesList()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Categories", symbol: .squareGrid2X2)
                    .accessibility(label: Text("Categories"))
            }
            .tag(Tab.categories)
        }
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
#endif
