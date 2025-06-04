//
//  APError.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import Foundation

enum APError: String, Error {
    case invalidURL = "Invalid URL"
    case invalidResponse =  "Invalid Response"
    case decodingFailed = "Decoding Failed"
    case invalidData = "Invalid Data"
    case unknown =  "Unknown Error"
}
