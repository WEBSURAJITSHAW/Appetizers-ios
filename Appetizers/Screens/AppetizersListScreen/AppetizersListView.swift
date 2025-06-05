//
//  AppetizersListView.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

struct AppetizersListView: View {
    @StateObject private var viewModel = AppetizersVM()
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    List {
                        ForEach(viewModel.fetchedMeals) { meal in
                            
                            NavigationLink(destination: AppetizerDetailsView(mealId: meal.idMeal)) {
                                HStack {
                                    APImage(imageURL: meal.strMealThumb)
                                        .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(meal.strMeal)
                                            .font(.headline)
                                        Text(meal.idMeal)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("🍔 Appetizers")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: alertItem.dismissButton
                )
            }
        }
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
                viewModel.fetchMeals()
            }
        }
    }
}


#Preview {
    AppetizersListView()
}
