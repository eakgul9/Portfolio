//
//  ReviewList.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import SwiftUI

struct ReviewList: View {
    @EnvironmentObject var auth: MelpAuth
    @EnvironmentObject var reviewService: MelpReview
    
    @Binding var requestLogin: Bool
    
    @State var reviews: [Review]
    @State var error: Error?
    @State var fetching = false
    @State var writing = false
    
    var body: some View {
        NavigationView {
            VStack {
                if fetching {
                    ProgressView()
                } else if error != nil {
                    Text("Something went wrong")
                } else if reviews.count == 0 {
                    VStack {
                        Spacer()
                        Text("There are no reviews currently")
                        Spacer()
                    }
                } else {
                    List(reviews) { review in
                        NavigationLink {
                            ReviewDetail(reviews: reviews, review: review)
                        } label: {
                            ReviewMetadata(review: review)
                        }
                        .swipeActions() {
                            if auth.user != nil {
                                Button(role: .destructive) {
                                    reviewService.deleteReview(reviewToDelete: review)
                                    if let index = reviews.firstIndex(where: {$0.id == review.id}){
                                        reviews.remove(at: index)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Movie Reviews")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if auth.user != nil {
                        Button("Sign Out") {
                            do {
                                try auth.signOut()
                            } catch {
                                print("Uh oh something went wrong")
                            }
                        }
                    } else {
                        Button("Log In") {
                            requestLogin = true
                        }
                    }
                }
            }
        }
        
        .task {
            fetching = true
            do {
                reviews = try await reviewService.fetchReviews()
                fetching = false
            } catch {
                self.error = error
                fetching = false
            }
        }
    }
}

struct ReviewList_Previews: PreviewProvider {
    @State static var requestLogin = false
    
    static var previews: some View {
        ReviewList(requestLogin: $requestLogin, reviews: [])
            .environmentObject(MelpAuth())
        
        ReviewList(requestLogin: $requestLogin, reviews: [
            Review(
                id: "12345",
                title: "Preview",
                date: Date(),
                body: "Lorem ipsum dolor sit something something amet",
                url: "facebook.com"
            ),
            
            Review(
                id: "67890",
                title: "Some time ago",
                date: Date(timeIntervalSinceNow: TimeInterval(-604800)),
                body: "Duis diam ipsum, efficitur sit amet something somesit amet",
                url: "facebook.com"
            )
        ])
        .environmentObject(MelpAuth())
        .environmentObject(MelpReview())
    }
}
