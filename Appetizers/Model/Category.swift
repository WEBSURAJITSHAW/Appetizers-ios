//
//  Category.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import Foundation

struct Category: Codable, Identifiable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
    
    var id: String {
        idCategory
    }
}

struct CategoryResponse: Codable {
    let categories: [Category]
}
