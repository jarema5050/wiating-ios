//
//  wiatingApp.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 02/09/2021.
//

import SwiftUI
import Firebase

@main
struct wiatingApp: App {
    
    init() {
        FirebaseApp.configure()
        
        AuthManager.shared.anonymousSignIn()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
