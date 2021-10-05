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
        
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            let uid = user.uid
            UserDefaults.standard.set(uid, forKey: "UID")
        }

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
