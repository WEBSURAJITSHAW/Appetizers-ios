//
//  MealDetails.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import Foundation

struct MealDetails: Codable, Identifiable {
    let idMeal: String
    var strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String
    
    
    var id: String {
        idMeal
    }
}

struct MealDetailsResponse: Codable {
    let meals: [MealDetails]
}
