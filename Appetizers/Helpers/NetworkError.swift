//
//  NetworkError.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case invalidURL
    case decodingFailed
    case unknown
}
