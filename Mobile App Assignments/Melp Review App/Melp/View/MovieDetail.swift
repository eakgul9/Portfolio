//
//  MovieDetail.swift
//  Melp
//
//  Created by Arusha Ramanathan on 4/27/22.
//

import SwiftUI
struct MovieDetail: View {
    @EnvironmentObject var melpReview: MelpReview
    @EnvironmentObject var auth: MelpAuth
    @Binding var requestLogin: Bool
    
    var id: String
    var title: String
    var image: String
    
    @State var loading = true
    @State var errorOccurred = false
    @State var detail: MovieDetailPage?
    @State var reviews: [Review] = []
    
    
    
    
    var body: some View {
            ScrollView{
                VStack {
                    if errorOccurred {
                        Text("Sorry, something went wrong.")
                    } else {
                        VStack {
                            Text(title)
                                .font(.largeTitle)
                            HStack{
                                AsyncImage(url: URL(string: image)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 200, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            }
                            if loading {
                                ProgressView()
                            }else{
                                if detail?.plot != nil {
                                    Text(detail!.plot)
                                        .padding()
                                }
                                HStack{
                                    if detail?.year != nil {
                                        Text("Year Released: " + detail!.year)
                                            .padding()
                                    }
                                    if detail?.runtimeStr != nil {
                                        Text("Runtime: " + detail!.runtimeStr!)
                                            .padding()
                                    }
                                }
                                Text("Reviews: ")
                                if reviews.count == 0 {
                                    Text("No reviews yet")
                                }else{
                                    List(reviews) { review in
                                        NavigationLink {
                                            ReviewDetail(reviews: reviews, review: review)
                                        } label: {
                                            ReviewMetadata(review: review)
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            }
            
            
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                if auth.user != nil {
                    Button("Sign Out") {
                        do {
                            try auth.signOut()
                        } catch {
                            print("Something went wrong")
                        }
                    }
                } else {
                    Button("Log In") {
                        requestLogin = true
                    }
                }
            }
        }
        .task() {
            await loadMovieDetails()
        }.task(){
            if auth.user != nil {
                await loadMovieReviews()
            }
        }
    }
    func loadMovieReviews() async {
        errorOccurred = false
        loading = true
        
        do {
            reviews = try await melpReview.fetchReviewsByMovie(movieId: id)
            
        } catch {
            errorOccurred = true
            debugPrint("Unexpected error: \(error)")
        }
        
        loading = false
    }
    
    func loadMovieDetails() async {
        errorOccurred = false
        loading = true
        
        do {
            detail = try await getMovieDetails(id1: id)
            
        } catch {
            errorOccurred = true
            debugPrint("Unexpected error: \(error)")
        }
        
        loading = false
    }
}

struct MovieDetail_Previews: PreviewProvider {
    
    @State static var requestLogin = false
    
    static var previews: some View {
        MovieDetail(requestLogin: $requestLogin, id: "xyz", title: "Harry Potter and the Prizoner of Azkaban", image: "")
            .environmentObject(MelpAuth())
    }
}
