//
//  ContentView.swift
//  Assignment0210
//
//  Created by eylul on 2/1/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ThemeParksList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
