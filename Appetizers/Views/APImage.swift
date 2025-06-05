//
//  APImage.swift
//  Appetizers
//
//  Created by wadmin on 04/06/25.
//

import SwiftUI

struct APImage: View {
    let imageURL: String
    let dimen: CGFloat?

    init(imageURL: String, dimen: CGFloat? = 75) {
        self.imageURL = imageURL
        self.dimen = dimen
    }

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty, .failure:
                Color.gray
                    .frame(width: dimen, height: dimen)
                    .cornerRadius(5)

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: dimen, height: dimen)
                    .cornerRadius(5)

            @unknown default:
                EmptyView()
            }
        }
    }
}
