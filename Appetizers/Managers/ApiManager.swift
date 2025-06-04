//
//  ApiManager.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import Foundation

final class ApiManager {
    static let shared = ApiManager()
    private init() {}
    
    private let baseStringURL = "https://www.themealdb.com/api/json/v1/1/"
    
    func getMealsURL(forArea area: String) -> URL? {
        var components = URLComponents(string: baseStringURL + "filter.php")
        components?.queryItems = [
            URLQueryItem(name: "a", value: area)
        ]
        return components?.url
    }
    
    func getMeals(forArea area: String, completion: @escaping (Result<MealsResponse, APError>) -> Void) {
        guard let url = getMealsURL(forArea: area) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
                completion(.success(mealsResponse))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        task.resume()
        
    }
    
}
