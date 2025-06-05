//
//  HomeScreenVM.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import Foundation

@MainActor
final class HomeScreenVM: ObservableObject {
    
    @Published var randomMealDetails: MealDetails?
    @Published var fetchedTrendingMeals: [Meal] = []
    @Published var fetchedCategories: [Category] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?

    @MainActor
    func fetchRandomMealDetails() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await ApiManager.shared.getRandomMeal()
            self.randomMealDetails = response.meals.first
        } catch {
            self.errorMessage = "Failed to load a random meal."
        }

        isLoading = false
    }


    func fetchTrendingMeals() {
        isLoading = true
        errorMessage = nil

        ApiManager.shared.getMeals(forArea: "indian") { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let mealsResponse):
                    self.fetchedTrendingMeals = mealsResponse.meals
                case .failure:
                    self.errorMessage = "Failed to load trending meals."
                }
                self.isLoading = false
            }
        }
    }

    func fetchCategories() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let _ = error {
                    self.errorMessage = "Something went wrong"
                    self.isLoading = false
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    self.isLoading = false
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    self.fetchedCategories = decoded.categories
                } catch {
                    self.errorMessage = "Failed to decode categories"
                }

                self.isLoading = false
            }
        }.resume()
    }
}
