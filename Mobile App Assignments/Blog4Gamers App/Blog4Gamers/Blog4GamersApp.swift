import SwiftUI

@main
struct Blog4GamersApp: App {

    @UIApplicationDelegateAdaptor(Blog4GamersAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Blog4GamersAuth())
                .environmentObject(Blog4GamersArticle())
        }
    }
}

