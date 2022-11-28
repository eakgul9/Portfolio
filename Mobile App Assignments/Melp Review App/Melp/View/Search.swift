//
//  Search.swift
//  Melp
//
//  Created by Arusha Ramanathan on 5/4/22.
//

import SwiftUI

struct Search: View {
    @State var loading = false
    @State var errorOccurred = false
    @State var searchMovies: [MostPopularMoviesResult] = []
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            if loading {
                ProgressView()
            } else if errorOccurred {
                // Very bare bones of course; robust apps will do this better.
                Text("Sorry, something went wrong.")
            } else {
                NavigationView {
                    List {
                        ForEach(searchResults, id: \.id) {result in
                            NavigationLink(destination: MovieDetail2(id1: result.id)) {
                                Text(result.title)
                            }
                        }
                    }
                    .navigationTitle("Movies")
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Any Movie")
                    
                }
            }
        }
        
        .task(id: searchText) {
            if searchText != "" {
                await loadSearchResults()
            }
        }
    }
    
    var searchResults: [MostPopularMoviesResult] {
            return searchMovies.filter { $0.title.contains(searchText) }
        }
    
    
    func loadSearchResults() async {
        errorOccurred = false
        loading = true
        
        do {
            let searchMoviesPage = try await searchMovie(movie: searchText)
            searchMovies = searchMoviesPage.results
        } catch {
            errorOccurred = true
            
            // Only a dev will be able to see this, of course.
            debugPrint("Unexpected error: \(error)")
        }
        
        loading = false
    }
    
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
