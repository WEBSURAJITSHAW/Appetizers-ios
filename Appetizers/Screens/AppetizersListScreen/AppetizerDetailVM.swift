//
//  AppetizerDetailVM.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import Foundation

final class AppetizerDetailVM: ObservableObject {
    @Published var mealDetails: MealDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchMealDetails(mealId: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await ApiManager.shared.getMealDetails(forMealId: mealId)
                mealDetails = response.meals.first
            } catch {
                errorMessage = "Failed to load meal details"
                print("Error: \(error)")
            }
            isLoading = false
        }
    }
}
