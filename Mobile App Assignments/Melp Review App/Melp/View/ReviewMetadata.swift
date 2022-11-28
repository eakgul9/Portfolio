//
//  ReviewMetadata.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import SwiftUI
import CachedAsyncImage

struct ReviewMetadata: View {
    var review: Review

    var body: some View {
        HStack() {
            if review.movieImage != nil {
                CachedAsyncImage(url: URL(string: review.movieImage!), urlCache: .imageCache) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 50, height: 75)
            }
            VStack (alignment: .leading) {
                Text(review.title)
                    .font(.headline)
                if review.movieTitle != nil {
                    Text(review.movieTitle!)
                    .font(.subheadline)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(review.date, style: .date)
                    .font(.caption)
                Text(review.date, style: .time)
                    .font(.caption)
            }
        }
    }
}

struct ReviewMetadata_Previews: PreviewProvider {
    static var previews: some View {
        ReviewMetadata(review: Review(
            id: "12345",
            title: "Preview",
            date: Date(),
            body: "Lorem ipsum dolor sit something something amet",
            url : "facebook.com"
        ))
    }
}
