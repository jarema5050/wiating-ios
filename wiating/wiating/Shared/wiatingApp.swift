//
//  wiatingApp.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 02/09/2021.
//

import SwiftUI
import Firebase
import FirebaseAppCheck

@main
struct wiatingApp: App {
    
    init() {
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
        
        FirebaseApp.configure()
        
        AuthManager.shared.anonymousSignIn()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
