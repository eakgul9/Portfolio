//
//  Review.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import Foundation

struct Review: Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var date: Date
    var body: String
    var url: String?
    var movieId: String?
    var movieTitle: String?
    var movieImage: String?
}

