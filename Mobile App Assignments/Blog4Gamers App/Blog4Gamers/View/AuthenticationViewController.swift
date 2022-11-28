/**
 * AuthenticationViewController is a SwiftUI “wrapper” around the view controller object
 * provided by FirebaseUI. The mechanism shown here is actually pretty standardized
 * and can be use to “SwiftUI-ize” any other code that is implemented as a view
 * conroller rather than as a SwiftUI View.
 */
import SwiftUI
import UIKit

import FirebaseAuthUI

struct AuthenticationViewController: UIViewControllerRepresentable {
    var authUI: FUIAuth

    func makeUIViewController(context: Context) -> UINavigationController {
        return authUI.authViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}

