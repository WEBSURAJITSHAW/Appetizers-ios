//
//  AppetizersApp.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

@main
struct AppetizersApp: App {
    
    @StateObject var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            AppetizersTabView()
                .environmentObject(cartManager)
        }
    }
}
