//
//  ThemeParksApp.swift
//  Assignment0210
//
//  Created by eylul on 2/1/22.
//

import SwiftUI

@main
struct ThemeParksApp: App {
    
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
