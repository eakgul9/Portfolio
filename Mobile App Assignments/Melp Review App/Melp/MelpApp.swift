//
//  MelpApp.swift
//  Melp
//
//  Created by Arusha Ramanathan on 4/27/22.
//

import SwiftUI

@main
struct MelpApp: App {
    @UIApplicationDelegateAdaptor(MelpAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MelpAuth())
                .environmentObject(MelpReview())
        }
    }
}
