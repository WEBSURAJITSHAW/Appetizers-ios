//
//  APImage.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

struct APImage: View {
    
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                // Placeholder while loading
                Color.gray
                    .frame(width: 75, height: 75)
                    .cornerRadius(5)
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 75)
                    .cornerRadius(5)
                
            case .failure:
                // Show a default “failed” placeholder
                Color.gray
                    .frame(width: 75, height: 75)
                    .cornerRadius(5)
                
            @unknown default:
                EmptyView()
            }
        }
    }
}
