//
//  CategoryNavigationLink.swift
//  Appetizers
//
//  Created by wadmin on 06/06/25.
//

import SwiftUI

struct CategoryNavigationLink<Destination: View>: View {
    private let imageUrl: String
    private let title: String
    private let destination: Destination

    init(imageUrl: String, title: String, destination: Destination) {
        self.imageUrl = imageUrl
        self.title = title
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 100)
                .clipped()
                .cornerRadius(8)

                Text(title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}
