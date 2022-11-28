//
//  ImdbAPI.swift
//  Melp
//
//  Created by Arusha Ramanathan on 4/27/22.
//

/*

 ImdbAPI is our abstraction layer for making API calls. It makes API calls using
 the IMDb API (https://imdb-api.com/api). This way, all other code just calls an
 asynchronous function. URL and other network-specific details are restricted to this module.

 */

import Foundation

let IMDB_API_ROOT = "https://imdb-api.com/en/API"
let MOST_POP_MOVIES = "\(IMDB_API_ROOT)/MostPopularMovies"
let SEARCH_MOVIE = "\(IMDB_API_ROOT)/AdvancedSearch"
let API_KEY = "k_fcq54axi"

enum IMDBAPIError: Error {
    case unsuccessfulDecode
}

func getMostPopMovies() async throws -> MostPopularMoviesPage {
    guard let url = URL(string: "\(MOST_POP_MOVIES)/\(API_KEY)") else {
        fatalError("Should never happen, but just in case…URL didn’t work 😔")
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    if let decodedPage = try? JSONDecoder().decode(MostPopularMoviesPage.self, from: data) {
        return decodedPage
    } else {
        throw IMDBAPIError.unsuccessfulDecode
    }
}
//https://api.themoviedb.org/3/search/movie?api_key=API_KEY_HERE&query=batman

func searchMovie(movie: String) async throws -> SearchMoviePage {
    let movieString :String = movie.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    guard let url = URL(string: "\(SEARCH_MOVIE)/\(API_KEY)/?title=\(movieString)") else {
        fatalError("Should never happen, but just in case…URL didn’t work 😔")
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    if let decodedPage = try? JSONDecoder().decode(SearchMoviePage.self, from: data) {
        return decodedPage
    } else {
        throw IMDBAPIError.unsuccessfulDecode
    }
}

func getMovieDetails(id1: String) async throws -> MovieDetailPage {
    guard let url = URL(string: "\(IMDB_API_ROOT)/Title/\(API_KEY)/\(id1)") else {
        fatalError("Should never happen, but just in case…URL didn’t work 😔")
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    if let decodedPage = try? JSONDecoder().decode(MovieDetailPage.self, from: data) {
        return decodedPage
    } else {
        throw IMDBAPIError.unsuccessfulDecode
    }
}
