//
//  CategoriesList.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/12/11.
//

import SFSymbols
import SwiftUI

struct CategoriesList: View {
    @EnvironmentObject var model: ContentViewModel
    @State private var searchText = String()
    
    var searchResults: [SFCategory] {
        if searchText.isEmpty {
            return model.categories
        }
        
        return model.categories.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        List(searchResults) { category in
            NavigationLink(destination: SymbolList(category: category)) {
                Label(category.title, systemImage: category.icon)
            }
        }
        .navigationTitle("Categories")
        .searchable(text: $searchText, placement: .sidebar)
        .animation(.default, value: searchText)
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesList()
    }
}
