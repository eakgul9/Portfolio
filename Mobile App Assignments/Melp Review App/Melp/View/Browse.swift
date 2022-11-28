//
//  Browse.swift
//  Melp
//
//  Created by Arusha Ramanathan on 4/27/22.
//

import SwiftUI
import CachedAsyncImage

struct Browse: View {
    @EnvironmentObject var auth: MelpAuth
    @Binding var requestLogin: Bool
    @StateObject private var searchList = SearchListModelView()
    
    
    var body: some View {
    
        NavigationView {
            VStack {
                if searchList.loading {
                    ProgressView()
                } else if searchList.errorOccurred {
                    Text("Sorry, something went wrong.")
                } else {
                        List {
                            ForEach(searchList.results, id: \.id) {result in
                                NavigationLink(destination: NewMovieDetail(id1: result.id, requestLogin: $requestLogin)) {
                                    HStack{
                                        CachedAsyncImage(url: URL(string: result.image), urlCache: .imageCache) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 50, height: 75)
                                        Text(result.title)
                                    }
                                }
                            }
                        }
                }
            }
            .navigationTitle("Browse Movies")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if auth.user != nil {
                        Button("Sign Out") {
                            do {
                                try auth.signOut()
                            } catch {
                                print("Something went wrong")
                            }
                        }
                    } else {
                        Button("Log In") {
                            requestLogin = true
                        }
                    }
                }
            }
            .searchable(text: $searchList.SearchText, prompt: "Movie Title")
        }
        
    }
    
}

struct Browse_Previews: PreviewProvider {
    @State static var requestLogin = false

    static var previews: some View {
        Browse(requestLogin: $requestLogin)
            .environmentObject(MelpAuth())
    }
}
