//
//  itunesAPI.swift
//  iTunesSearch
//
//  Created by izabela on 3/8/22.
//

import Foundation
import Combine

let ITUNES_API_ROOT = "https://itunes.apple.com"
let SEARCH_ENDPOINT = "\(ITUNES_API_ROOT)/search"

enum iTunesAPIError: Error {
    case unsuccessfulDecode
}

func searchITunes(term: String, entity: String) async throws -> iTunesSearchPage {
    // There are more structured ways to construct a URL with query parameters but
    // this suffices for this fixed pair.
    guard let url = URL(string: "\(SEARCH_ENDPOINT)?term=\(term)&entity=\(entity)") else {
        fatalError("URL did not work.")
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    if let decodedPage = try? JSONDecoder().decode(iTunesSearchPage.self, from: data) {
        return decodedPage
    } else {
        throw iTunesAPIError.unsuccessfulDecode
    }
}
