//
//  MelpAppDelegate.swift
//  Melp
//
//  Created by eakgul9 on 4/28/22.
//

import Foundation
import UIKit

import Firebase

class MelpAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
