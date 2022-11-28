//
//  APITabs.swift
//  iTunesSearch
//
//  Created by izabela on 3/10/22.
//

import SwiftUI

// Find out more about SF Symbols, the source of systemImage, here:
// https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
struct APITabs: View {
    var body: some View {
        TabView {
            
            iTunesAPIView()
                .tabItem {
                    Label("iTunes", systemImage: "tv.and.mediabox")
                }

        }
    }
}

struct APITabs_Previews: PreviewProvider {
    static var previews: some View {
        APITabs()
    }
}

