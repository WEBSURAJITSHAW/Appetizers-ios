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
    
    @State private var alertMessage: String? = nil
    @State private var showingCartAlert = false

    
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
                                let wasAdded = cartManager.add(meal)
                                alertMessage = wasAdded ? "Added to Cart!" : "Already in Cart!"
                                showingCartAlert = true
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
                            .alert(alertMessage ?? "", isPresented: $showingCartAlert) {
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
                .navigationTitle(meal.strMeal)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar) 
            } else {
                Text("No meal details found.")
            }
            
            
        }
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


