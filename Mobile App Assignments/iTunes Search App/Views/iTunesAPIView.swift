//
//  iTunesAPIView.swift
//  iTunesSearch
//
//  Created by izabela on 3/9/22.
//

import SwiftUI

// Helper struct, for connecting picker choices and API entities.
struct iTunesEntity {
    let label: String
    let type: String
}

//struct theText {
//    static var searchText = ""
//}

struct iTunesAPIView: View {
    
//    @EnvironmentObject var itunesAPI: itunesAPI
//    var displayedItems: [iTunesSearchResult]
    
    let SEARCHABLE_ENTITIES = [
        iTunesEntity(label: "Songs", type: "song"),
        iTunesEntity(label: "Movies", type: "movie"),
        iTunesEntity(label: "TV Shows", type: "tvEpisode")
    ]

    @State public var searchText = ""
    //turn user string into one word

    @State var entity = "song"

    var body: some View {
        NavigationView {
        VStack {
                Text("iTunes Library")
                    .font(.title)
                    .bold()
                    .foregroundColor(.accentColor)
            
            Picker("", selection: $entity) {
                ForEach(SEARCHABLE_ENTITIES, id: \.type) { searchableEntity in
                    Text(searchableEntity.label)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .searchable(text: $searchText, placement: /*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
            iTunesListView(searchTerm: searchText, searchEntity: entity)

        }
        }
        .ignoresSafeArea(edges: .top)
        }
    }

struct iTunesAPIView_Previews: PreviewProvider {
    static var previews: some View {
        iTunesAPIView()
    }
}

