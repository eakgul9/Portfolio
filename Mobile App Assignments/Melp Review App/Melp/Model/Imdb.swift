//
//  Imdb.swift
//  Melp
//
//  Created by Arusha Ramanathan on 4/27/22.
//

/*

 Models the data from the IMDb API (https://imdb-api.com/api).

 */

import Foundation

struct MostPopularMoviesResult: Hashable, Codable {
    var id: String
    var title: String
    var image: String
}

struct MostPopularMoviesPage: Hashable, Codable {
    var items: [MostPopularMoviesResult]
}

struct SearchMoviePage: Hashable, Codable {
    var results: [MostPopularMoviesResult]
}

struct GenreList: Hashable, Codable {
    var key: String
}

struct MovieDetailPage: Hashable, Codable {
    var id: String
    var title: String
    var image: String
    var runtimeStr: String?
    var year: String
    var plot: String
    var contentRating: String?
    var genreList: [GenreList]
}
