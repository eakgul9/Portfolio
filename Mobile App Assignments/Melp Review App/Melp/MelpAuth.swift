//
//  MelpAuth.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import Foundation

import FirebaseAuthUI
import FirebaseEmailAuthUI

class MelpAuth: NSObject, ObservableObject, FUIAuthDelegate {
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
