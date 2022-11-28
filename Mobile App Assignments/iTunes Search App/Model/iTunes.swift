//
//  iTunesApp.swift
//  iTunesSearch
//
//  Created by izabela on 3/7/22.
//

import Foundation
import SwiftUI

struct iTunesSearchResult: Hashable, Codable, Identifiable {
    var id: Int {trackId}
    var trackId: Int
    var artistId: Int?
    var artistName: String?
    var trackName: String
    var collectionName: String?
    var primaryGenreName: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    }



struct iTunesSearchPage: Hashable, Codable {
    var resultCount: Int
    var results: [iTunesSearchResult]
}

//struct iTunesSearchResult: Hashable, Codable {
//    var trackId: Int
//    var artistId: Int
//    var artistName: String
//    var trackName: String
//    var collectionName: String?
//    var artworkUrl60: String?
//    // var isFeatured: Bool
//    // var isFavorite: Bool
//}
//this is our iTunes item, we want to make a list of iTunesSearchResult and display them based on data fetched from the API

//struct iTunesSearchResult: Hashable, Codable {
//    var trackId: Int
//    var trackName: String
//    var collectionName: String?
//    var artworkUrl60: String?
//}
//

//struct iTunesSearchPage: Hashable, Codable {
//    var resultCount: Int
//    var results: [iTunesSearchPage]
//}


//example code
//struct iTunesSearchResult: Hashable, Codable, Identifiable {
//    var category: Category
//    enum Category: String, CaseIterable, Codable {
//        case lakes = "Lakes"
//        case rivers = "Rivers"
//        case mountains = "Mountains"
//    }
//}
