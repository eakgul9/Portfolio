//
//  iTunesResultRow.swift
//  iTunesSearch
//
//  Created by izabela on 3/9/22.
//

import SwiftUI

let COVER_ART = 60.0

struct iTunesResultRow: View {
    var result: iTunesSearchResult
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: result.artworkUrl60 ?? "")) { image in
                image
            } placeholder: {
                ProgressView()
            }
            .frame(height: COVER_ART)
            .padding(.trailing, 5.0)
            
            Text(result.trackName)
            Text(result.artistName ?? "")
                .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xSmall/*@END_MENU_TOKEN@*/)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct iTunesResultRow_Previews: PreviewProvider {
    static var previews: some View {
        iTunesResultRow(result: iTunesSearchResult(
            trackId: 1207820257,
            artistId: 1210275020,
            artistName: "Steve Lacy",
            trackName: "Ryd",
            collectionName: "Steve Lacy's Demo - EP",
            primaryGenreName: "R&B/Soul",
            artworkUrl60: "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/0d/99/f8/0d99f872-4fde-f348-39f6-6b0b1f6987a3/source/60x60bb.jpg"
        ))
    }
}
