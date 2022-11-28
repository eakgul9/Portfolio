//
//  iTunesListView.swift
//  iTunesSearch
//
//  Created by izabela on 3/9/22.
//

import SwiftUI

struct iTunesListView: View {
    var searchTerm: String?
    var searchEntity: String?
    var searchExplicit : String?
    
    @State var loading = false
    @State var errorOccurred = false
    @State var results: [iTunesSearchResult] = []
    
    var body: some View {
        NavigationView {
            List(results) { iTunesSearchResult in
                NavigationLink {
                    iTunesResultDetail(result: iTunesSearchResult)
                } label: {
                    iTunesResultRow(result: iTunesSearchResult)
                }
            }
        
        
        VStack {
            if loading {
                ProgressView()
            } else if errorOccurred {
                // Very bare bones of course; robust apps will do this better.
                Text("Sorry, something went wrong.")
            } else {
                List(results, id: \.trackId) { item in
                    iTunesResultRow(result: item)
                }.refreshable {

                    await loadSearchResults()
                }
                
            }
        }

        .task(id: searchEntity) {
            await loadSearchResults()
        }
        }
    }
    
    func loadSearchResults() async {
        errorOccurred = false
        loading = true
        
        do {
            let searchPage = try await searchITunes(term: searchTerm ?? "", entity: searchEntity ?? "")
            results = searchPage.results
        } catch {
            errorOccurred = true
            
            debugPrint("Unexpected error: \(error)")
        }
        
        loading = false
    }
}

struct iTunesListView_Previews: PreviewProvider {
    static var previews: some View {
        iTunesListView(searchTerm: "ryd", searchEntity: "song", searchExplicit: "Yes")
    }
}







