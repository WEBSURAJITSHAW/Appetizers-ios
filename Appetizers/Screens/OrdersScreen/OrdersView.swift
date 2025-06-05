//
//  OrdersView.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

struct OrdersView: View {
    
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        NavigationView {
            VStack {
                if cartManager.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        Text("Your cart is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(cartManager.items) { item in
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: item.strMealThumb)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading) {
                                    Text(item.strMeal)
                                        .font(.headline)
                                    Text(item.strCategory)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("🛒 My Cart")
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = cartManager.items[index]
            cartManager.remove(item)
        }
    }
}

