//
//  CartManager.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import SwiftUI

class CartManager: ObservableObject {
    @Published var items: [MealDetails] = [] {
        didSet {
            saveToStorage()
        }
    }

    private let storageKey = "cart_items"

    init() {
        loadFromStorage()
    }

    private func saveToStorage() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadFromStorage() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedItems = try? JSONDecoder().decode([MealDetails].self, from: data) {
            self.items = savedItems
        }
    }

    func add(_ meal: MealDetails) -> Bool {
         if items.contains(where: { $0.idMeal == meal.idMeal }) {
             return false // already exists
         }
         items.append(meal)
         return true // newly added
     }

    func remove(_ item: MealDetails) {
        items.removeAll { $0.idMeal == item.idMeal }
    }

    func isInCart(_ item: MealDetails) -> Bool {
        items.contains { $0.idMeal == item.idMeal }
    }
}
