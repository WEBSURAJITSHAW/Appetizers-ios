//
//  AppetizersVM.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

final class AppetizersVM: ObservableObject {
    
    @Published var fetchedMeals: [Meal] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading: Bool = false
    
    func fetchMeals(forCategory: String) {
        self.isLoading = true
        ApiManager.shared.getMeals(forCategory: forCategory) { [weak self] response in
    
            guard let self = self else { return }
    
            
            DispatchQueue.main.async {
                switch response {
                case .success(let mealsResponse):
                    self.fetchedMeals = mealsResponse.meals
                    self.isLoading = false
                    
                case .failure(let error):
                    switch error {
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .decodingFailed:
                        self.alertItem = AlertContext.decodingFailed
                    case .unknown:
                        self.alertItem = AlertContext.unknown
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    }
                    self.isLoading = false

                }
            }
            
        }
    }
    
    
}
