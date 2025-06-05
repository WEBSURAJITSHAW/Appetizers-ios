//
//  AppetizerDetailsView.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

struct AppetizerDetailsView: View {
    let mealId: String
    @StateObject private var viewModel = AppetizerDetailVM()
    @State private var showAlert = false

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let meal = viewModel.mealDetails {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ZStack {
                                Color.gray.opacity(0.1)
                                ProgressView()
                            }
                                
                        }
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(meal.strMeal)
                                .font(.title)
                                .fontWeight(.bold)

                            HStack {
                                Text("Category: \(meal.strCategory)")
                                Spacer()
                                Text("Origin: \(meal.strArea)")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                            if !meal.strTags.isEmpty {
                                Text("Tags: \(meal.strTags)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }

                        Divider()

                        Text("Instructions")
                            .font(.headline)

                        Text(meal.strInstructions)
                            .font(.body)

                        Divider()

//                        if !meal.strYoutube.isEmpty {
//                            Text("Watch Tutorial")
//                                .font(.headline)
//
//                            Link(destination: URL(string: meal.strYoutube)!) {
//                                HStack {
//                                    Image(systemName: "play.rectangle.fill")
//                                        .font(.title2)
//                                        .foregroundColor(.red)
//                                    Text("Watch on YouTube")
//                                }
//                                .padding(8)
//                                .background(Color(.systemGray6))
//                                .cornerRadius(8)
//                            }
//                        }
                        
                        if let videoID = extractYouTubeID(from: meal.strYoutube) {
                            Text("Watch Tutorial")
                                .font(.headline)
                                .padding(.top)

                            YouTubeWebView(videoID: videoID)
                                .frame(height: 200)
                                .cornerRadius(12)
                        }

                    }
                    .padding()
                }
            } else {
                Text("No meal details found.")
            }
        }
        .navigationTitle(viewModel.mealDetails?.strMeal ?? "Meal Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchMealDetails(mealId: mealId)
        }
        .alert("Error", isPresented: $showAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        })
        .onChange(of: viewModel.errorMessage) { newValue in
            showAlert = newValue != nil
        }
    }
    
    func extractYouTubeID(from urlString: String) -> String? {
        guard let url = URLComponents(string: urlString),
              url.host?.contains("youtube.com") == true,
              let queryItems = url.queryItems,
              let idItem = queryItems.first(where: { $0.name == "v" }) else {
            return nil
        }
        return idItem.value
    }

}

#Preview {
    NavigationStack {
        AppetizerDetailsView(mealId: "52772")
    }
}
