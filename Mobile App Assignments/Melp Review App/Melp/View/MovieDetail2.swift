//
//  MovieDetail2.swift
//  Melp
//
//  Created by Arusha Ramanathan on 5/4/22.
//

import SwiftUI

let ART_HEIGHT = 410.0

struct MovieDetail2: View {
    var id1: String
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
    
    var body: some View {
        ScrollView {
            if loading {
                ProgressView()
            } else if errorOccurred {
                Text("Sorry, something went wrong.")
            } else {
                AsyncImage(url: URL(string: movieDetails.image)) { image in
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
                }
            }
        }
        .task() {
            await loadMovieDetails()
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
            
            // Only a dev will be able to see this, of course.
            debugPrint("Unexpected error: \(error)")
        }
        
        loading = false
    }
}

struct MovieDetail2_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail2(id1: "tt8718158")
    }
}

