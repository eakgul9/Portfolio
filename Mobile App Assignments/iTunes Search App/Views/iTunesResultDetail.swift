//
//  iTunesResultDetail.swift
//  iTunesSearch
//
//  Created by izabela on 3/14/22.
//

import SwiftUI

let COVER = 100.0

struct iTunesResultDetail: View {
    var result: iTunesSearchResult
    
    var body: some View {
        ScrollView{
            VStack {
                AsyncImage(url: URL(string: result.artworkUrl100 ?? "")) { image in
                    image
                } placeholder: {
                    ProgressView()
                }
                Text(result.trackName)
                Text(result.collectionName ?? "")
                Text(result.artistName ?? "")
                Text(result.primaryGenreName ?? "")
            }
            .offset(y: 30)
        }
    }
}

struct iTunesResultDetail_Previews: PreviewProvider {
    static var previews: some View {
        iTunesResultDetail(result: iTunesSearchResult(
            trackId: 1207820257,
            artistId: 1210275020,
            artistName: "Steve Lacy",
            trackName: "Ryd",
            collectionName: "Steve Lacy's Demo - EP",
            primaryGenreName: "R&B/Soul",
            artworkUrl100: "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/0d/99/f8/0d99f872-4fde-f348-39f6-6b0b1f6987a3/source/100x100bb.jpg"
        ))
    }
}
