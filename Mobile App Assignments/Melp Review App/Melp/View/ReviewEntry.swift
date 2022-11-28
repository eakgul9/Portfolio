//
//  ReviewEntry.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import SwiftUI
import CachedAsyncImage

struct ReviewEntry: View {
    @EnvironmentObject var reviewService: MelpReview

    @Binding var reviews: [Review]
    @Binding var writing: Bool
    
    @State var title = ""
    @State var reviewBody = ""
    @State var inputURL = "https://"
    var movieId: String
    var movieTitle: String
    var movieImage: String
    

    func submitReview() {
        let reviewId = reviewService.createReview(review: Review(
            id: UUID().uuidString,
            title: title,
            date: Date(),
            body: reviewBody,
            url: inputURL,
            movieId: movieId,
            movieTitle: movieTitle,
            movieImage: movieImage
            
        ))
        reviews.append(Review(
            id: reviewId,
            title: title,
            date: Date(),
            body: reviewBody,
            url: inputURL,
            movieId: movieId,
            movieTitle: movieTitle,
            movieImage: movieImage
        ))
        writing = false
    }

    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    CachedAsyncImage(url: URL(string: movieImage), urlCache: .imageCache) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 75)
                    Text(movieTitle)
                }
                List {
                    Section(header: Text("Title for my Review")) {
                        TextField("", text: $title)
                    }
                    
                    Section(header: Text("My Review")) {
                        TextEditor(text: $reviewBody)
                            .frame(minHeight: 100, maxHeight: .infinity)
                    }
                    Section(header: Text("My URL")) {
                        TextEditor(text: $inputURL)
                    }
                }
            }
            .navigationTitle("New Review")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        writing = false
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        submitReview()
                    }
                    .disabled(title.isEmpty || reviewBody.isEmpty)
                }
            }
        }
    }
}

struct ReviewEntry_Previews: PreviewProvider {
    @State static var reviews: [Review] = []
    @State static var writing = true
    
    static var previews: some View {
        ReviewEntry(reviews: $reviews, writing: $writing, movieId: "", movieTitle: "", movieImage: "")
            .environmentObject(MelpReview())
    }
}
