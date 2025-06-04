//
//  ContentView.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

struct AppetizersTabView: View {
    var body: some View {
        TabView {
            AppetizersListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            OrdersView()
                .tabItem {
                    Label("Orders", systemImage: "cart")
                }
        }
    }
}
#Preview {
    AppetizersTabView()
}
