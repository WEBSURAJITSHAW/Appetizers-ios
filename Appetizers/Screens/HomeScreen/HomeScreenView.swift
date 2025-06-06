//
//  HomeScreenView.swift
//  Appetizers
//
//  Created by wadmin on 05/06/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    @StateObject private var viewModel = HomeScreenVM()
    @State private var isShowingSearch = false
    
    var isLoading: Bool {
        viewModel.randomMealDetails == nil || viewModel.fetchedCategories.isEmpty || viewModel.fetchedTrendingMeals.isEmpty
    }
    
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Header
                        HStack {
                            Text("Home")
                                .font(.title)
                                .bold()
                                .foregroundColor(.accent)
                            Spacer()
                            
                            Button{
                              isShowingSearch = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                            }
                            .fullScreenCover(isPresented: $isShowingSearch) {
                                SearchView()
                            }
                        }
                        .padding(.horizontal)
                        
                        // Discover Section
                        Text("Discover Delicious Recipes")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if let meal = viewModel.randomMealDetails {
                            NavigationLink(destination: AppetizerDetailsView(mealId: meal.idMeal)) {
                                ZStack(alignment: .bottomLeading) {
                                    AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                        image.resizable().aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(height: 200)
                                    .clipped()
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    
                                    Text(meal.strMeal)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(8)
                                        .padding(.leading, 24)
                                        .padding(.bottom, 16)
                                }
                            }
                        }
                        
                        // Trending Now
                        Text("Trending Now")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.fetchedTrendingMeals) { meal in
                                    NavigationLink(destination: AppetizerDetailsView(mealId: meal.idMeal)) {
                                        VStack(alignment: .leading) {
                                            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                                image.resizable().aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                Color.gray
                                            }
                                            .frame(width: 150, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                            
                                            Text(meal.strMeal)
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        // Browse by Category
                        Text("Browse by Category")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.fetchedCategories) { category in
                                CategoryNavigationLink(
                                    imageUrl: category.strCategoryThumb,
                                    title: category.strCategory,
                                    destination: AppetizersListView(categoryName: category.strCategory)
                                )
                            }
                        }
//                        .padding(.horizontal)

                    }
                    .padding(.top)
                }
            }
            
            
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchRandomMealDetails()
            viewModel.fetchTrendingMeals()
            viewModel.fetchCategories()
        }
    }
}

#Preview {
    HomeScreenView()
}
