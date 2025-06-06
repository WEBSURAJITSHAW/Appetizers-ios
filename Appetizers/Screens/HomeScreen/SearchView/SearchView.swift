//
//  SearchView.swift
//  Appetizers
//
//  Created by wadmin on 06/06/25.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var query = ""
    @State private var searchResults: [MealDetails] = []
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search meals...", text: $query)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .onChange(of: query) {
                        Task {
                            await performSearch()
                        }
                    }


                if searchResults.isEmpty {
                    Spacer()
                    Text("No results found.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(searchResults) { meal in
                        NavigationLink(destination: AppetizerDetailsView(mealId: meal.idMeal)) {
                            HStack {
                                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)

                                Text(meal.strMeal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    func performSearch() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        if let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)") {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
                searchResults = response.meals
            } catch {
                print("Search error: \(error)")
            }
        }
    }
}


#Preview {
    SearchView()
}
