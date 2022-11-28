//
//  ContentView.swift
//  Melp
//
//  Created by Arusha Ramanathan on 4/27/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: MelpAuth
    @State var requestLogin = false
    @EnvironmentObject var reviewService: MelpReview
    @State private var selection: Tab = .browse
    
    enum Tab {
        case reviews
        case browse
    }
    
    var body: some View {
        TabView(selection: $selection) {
            Browse(requestLogin: $requestLogin)
                .sheet(isPresented: $requestLogin) {
                    if let authUI = auth.authUI {
                        AuthenticationViewController(authUI: authUI)
                    }
                }
                .tabItem {
                        Label("Movies", systemImage: "film")
                }
                .tag(Tab.browse)
            ReviewList(requestLogin: $requestLogin, reviews: [])
                .sheet(isPresented: $requestLogin) {
                    if let authUI = auth.authUI {
                        AuthenticationViewController(authUI: authUI)
                    }
                }
                .tabItem {
                        Label("Reviews", systemImage: "pencil.and.outline")
                }
                .tag(Tab.reviews)
            
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MelpAuth())
    }
}
