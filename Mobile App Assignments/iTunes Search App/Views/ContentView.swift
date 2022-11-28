//
//  ContentView.swift
//  iTunesSearch
//
//  Created by izabela on 3/7/22.
//
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .homePage
    
    enum Tab {
        case homePage
        case search
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomePage()
                .tabItem {
                    Label("Home", systemImage: "house")

                }
                .tag(Tab.homePage)
            
            iTunesAPIView()
                .tabItem {
                        Label("Search", systemImage: "magnifyingglass.circle.fill")
                }
                .tag(Tab.search)

        }
 
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
