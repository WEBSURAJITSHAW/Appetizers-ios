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
    func getMealsURL(forCategory category: String) -> URL? {
        var components = URLComponents(string: baseStringURL + "filter.php")
        components?.queryItems = [
            URLQueryItem(name: "c", value: category)
        ]
        return components?.url
    }
    func getMeals(forCategory category: String, completion: @escaping (Result<MealsResponse, APError>) -> Void) {
        guard let url = getMealsURL(forCategory: category) else {
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
                print(error)
            }
        }

        task.resume()
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
                print(error)
            }
        }
        task.resume()
        
    }
    
    func getMealDetails(forMealId id: String) async throws -> MealDetailsResponse {
        let urlString = baseStringURL + "lookup.php?i=\(id)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, resposne) = try await URLSession.shared.data(from: url)
        
        if let response = resposne as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkError.unknown
        }
        
        do {
            let mealDetailsResponse = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
            return mealDetailsResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    func getRandomMeal() async throws -> MealDetailsResponse {
        let urlString = baseStringURL + "random.php"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw NetworkError.unknown
        }

        do {
            let mealDetailsResponse = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
            return mealDetailsResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }

}
