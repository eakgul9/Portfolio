//
//  ReviewDetail.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import SwiftUI

struct ReviewDetail: View {

    @EnvironmentObject var ref: MelpReview
    @EnvironmentObject var auth: MelpAuth
    
    @State var reviews: [Review]
    @State var updating = false
    
    var review: Review

    var body: some View {
        VStack (alignment: .leading) {
//            ReviewMetadata(review: review)
//                .padding()
//            Text(review.body).padding()
            Text(review.title)
                .font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            Text(review.movieTitle ?? "")
                .font(.title3)
                .padding(.leading, 20)
            Spacer()
            HStack {
                Text(review.date, style: .date)
                    .font(.caption)
                    .padding(.leading, 20)
                Text(review.date, style: .time)
                    .font(.caption)
            }
            Divider()
                .padding(.bottom, 10)
            Text(review.body)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            if let finalURL = review.url {
                if let urlObject = URL(string: finalURL) {
                    Link(destination: urlObject, label: {
                        Text("View URL")
                            .padding(.leading, 150)
                            .foregroundColor(.pink)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    })
                }
            }

            Spacer()
            HStack{
            if auth.user != nil {
                Button(action: {
                    updating = true
                    }, label: {
                        Image(systemName: "pencil.circle.fill")
                    })
                .padding(.leading, 160)
                    .foregroundColor(.pink)
                Button(action: {
                    ref.deleteReview(reviewToDelete: review)
                    updating = false
                    }, label: {
                        Image(systemName: "trash.circle.fill")
                    })
                    .foregroundColor(.pink)
                }
            }

        }
        .sheet(isPresented: $updating) {
            ReviewUpdate(updating: $updating, currentReview: review, title: review.title, reviewBody: review.body, inputURL: review.url ?? "https://")
        }
    }
}

struct ReviewDetail_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetail(reviews: [], review: Review(
            id: "12345",
            title: "Preview",
            date: Date(),
            body: "Lorem ipsum dolor sit something something amet",
            url: "facebook.com"
        ))
    }
}
