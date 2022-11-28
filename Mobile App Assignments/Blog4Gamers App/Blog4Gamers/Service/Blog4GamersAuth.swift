/**
 * Blog4GamersAuth is an object that interacts with Firebase Authentication, allowing
 * it to keep track of user activities relating to login. It publishes its `user` variable
 * so that SwiftUI views will update when this variable changes.
 */
import Foundation

import FirebaseAuthUI
import FirebaseEmailAuthUI

class Blog4GamersAuth: NSObject, ObservableObject, FUIAuthDelegate {
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()

    let providers: [FUIAuthProvider] = [
        FUIEmailAuth()
    ]

    @Published var user: User?


    override init() {
        super.init()

        authUI?.delegate = self
        authUI?.providers = providers
    }


    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let actualResult = authDataResult {
            user = actualResult.user
        }
    }

    func signOut() throws {
        try authUI?.signOut()

        user = nil
    }
}
