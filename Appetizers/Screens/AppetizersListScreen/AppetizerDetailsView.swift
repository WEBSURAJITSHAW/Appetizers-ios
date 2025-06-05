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
    
    @EnvironmentObject var cartManager: CartManager
    @State private var showAlert = false
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let meal = viewModel.mealDetails {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        ZStack(alignment: .bottomTrailing) {
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

                            Button(action: {
                                cartManager.add(meal)
                                showAlert = true

                            }) {
                                Image(systemName: "cart.badge.plus")
                                    .font(.title2)
                                    .padding(12)
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding(8)
                            .offset(x: -12, y: 30)
                            .alert("Added to Cart!", isPresented: $showAlert) {
                                Button("OK", role: .cancel) {}
                            }
                        }

                        
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
        
//        // 🛒 Floating Add to Cart Button
//        if let meal = viewModel.mealDetails {
//            Button(action: {
//                cartManager.add(meal)
//            }) {
//                Image(systemName: "cart.badge.plus")
//                    .font(.title)
//                    .padding()
//                    .background(Color.accentColor)
//                    .foregroundColor(.white)
//                    .clipShape(Circle())
//                    .shadow(radius: 4)
//            }
//            .padding()
//        }
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
