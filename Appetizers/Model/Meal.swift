//
//  Meal.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import Foundation

struct Meal: Codable, Identifiable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String {
        idMeal
    }
}


class AppMockData {
    static let singleMeal = Meal(
        strMeal: "Bread omelette",
        strMealThumb: "https://www.themealdb.com/api/json/v1/1/filter.php?a=indian#:~:text=https%3A//www.themealdb.com/images/media/meals/hqaejl1695738653.jpg",
        idMeal: "52972"
    )
    
    static let meals: [Meal] = [
        singleMeal, singleMeal, singleMeal
    ]
        
}
