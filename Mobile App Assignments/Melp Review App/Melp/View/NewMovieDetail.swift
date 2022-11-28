//
//  newMovieDetail.swift
//  Melp
//
//  Created by Arusha Ramanathan on 5/4/22.
//

import SwiftUI
import CachedAsyncImage

let ART_HEIGHT = 410.0

struct NewMovieDetail: View {
    var id1: String
    
    @EnvironmentObject var melpReview: MelpReview
    @EnvironmentObject var auth: MelpAuth
    @Binding var requestLogin: Bool
    
    @State var addReview = false
    @State var loading = false
    @State var errorOccurred = false
    @State var movieDetails: MovieDetailPage = MovieDetailPage(
        id: "",
        title: "",
        image: "",
        runtimeStr: "",
        year: "",
        plot: "",
        contentRating: "",
        genreList: [])
    @State var genres: [GenreList] = []
    @State var reviews: [Review] = []
    
    var body: some View {
        ScrollView {
            if loading {
                ProgressView()
            } else if errorOccurred {
                Text("Sorry, something went wrong.")
            } else {
                CachedAsyncImage(url: URL(string: movieDetails.image), urlCache: .imageCache) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: ART_HEIGHT)
                .cornerRadius(15)
                VStack (alignment: .leading) {
                    Text(movieDetails.title)
                        .font(.title).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        Spacer()
                    HStack {
                        Text(movieDetails.runtimeStr ?? "")
                            .padding(.leading, 20)
                        Text("|")
                        Text(movieDetails.year)
                        Text("|")
                        Text("Content Rating:")
                        Text(movieDetails.contentRating ?? "")
                    }
                    HStack {
                        Text("")
                            .padding(.leading, 10)
                        ForEach(genres, id: \.key) {result in
                            GenreButton(genre: result.key, isSet: .constant(true))
                        }
                    }
                    Spacer()
                    Spacer()
                    Text("Plot")
                        .font(.title2)
                        .bold()
                        .padding(.leading, 20)
                    Text(movieDetails.plot)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.top, 1)
                    Text("Reviews")
                        .font(.title3)
                        .bold()
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        
                    if reviews.count == 0 {
                        Text("No reviews yet")
                            .padding(.leading, 20)
                    }else{
                        VStack{
                            ForEach(reviews, id: \.id) {review in
                                NavigationLink {
                                    ReviewDetail(reviews: reviews, review: review)
                                } label: {
                                    ReviewMetadata(review: review)
                                }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
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
            ToolbarItem() {
                if auth.user != nil{
                    Button("Add Review") {
                        addReview = true
                    }
                    .sheet(isPresented: $addReview) {
                        ReviewEntry(reviews: $reviews, writing: $addReview, movieId: id1, movieTitle: movieDetails.title, movieImage: movieDetails.image)
                        
                    }
                }
            }
            
        }
        
        .task() {
            await loadMovieDetails()
        }
        .task(){
            await loadMovieReviews()
        }
    }
    
    func loadMovieDetails() async {
        errorOccurred = false
        loading = true
        
        do {
            let movieDetailPage = try await getMovieDetails(id1: id1)
            movieDetails = movieDetailPage
            genres = movieDetailPage.genreList
        } catch {
            errorOccurred = true
            debugPrint("Unexpected error: \(error)")
        }
        
        loading = false
    }
    
    func loadMovieReviews() async {
        errorOccurred = false
        loading = true
        
        do {
            reviews = try await melpReview.fetchReviewsByMovie(movieId: id1)
            
        } catch {
            errorOccurred = true
            debugPrint("Unexpected error: \(error)")
        }
        
        loading = false
    }
}
