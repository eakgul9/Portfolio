//
//  AuthenticationViewController.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

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

