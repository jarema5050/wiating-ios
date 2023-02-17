//
//  AuthManager.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 25/11/2021.
//

import Foundation
import FirebaseAuth
import Auth0
import Combine

class AuthManager: NSObject, ObservableObject {
    static let shared = AuthManager()
    
    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    @objc dynamic var loggedIn: Bool
    
    let uidKey = "UID"
    
    var userInfo: Auth0.UserInfo?
    
    var userId: String? {
        didSet {
            UserDefaults.standard.set(userId, forKey: uidKey)
        }
    }
    var error: String?
    
    init(loggedIn: Bool = false) {
        self.loggedIn = loggedIn
    }
    
    func setWithError(error: Error) {
        loggedIn = false
        self.error = error.localizedDescription
    }
    
    func anonymousSignIn() {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            if let error = error {
                self?.setWithError(error: error)
            } else if let userId = authResult?.user.uid {
                self?.userId = userId
            }
        }
    }
    
    func auth0Login() {
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://jarema5050.eu.auth0.com/userinfo")
            .start { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.setWithError(error: error)
                case .success(let credentials):
                    self?.loggedIn = true
                    let _ = self?.credentialsManager.store(credentials: credentials)
                }
        }
    }
    
    func auth0Logout() {
        Auth0
            .webAuth()
            .clearSession(federated: false) { [weak self] result in
                if result {
                    self?.credentialsManager.revoke { error in
                        guard error == nil else { return }
                        self?.loggedIn = false
                    }
                }
            }
    }
    
    func getUserDetails() -> AnyPublisher <Auth0.UserInfo, AuthError> {
        return Future { [weak self] promise in
            self?.credentialsManager.credentials { error, credentials in
                guard let accessToken = credentials?.accessToken else {
                    promise(.failure(.noAccessToken(error?.localizedDescription ?? "error not detected")))
                    return
                }
                
                Auth0.authentication().userInfo(withAccessToken: accessToken).start { result in
                    switch result {
                    case .success(let profile):
                        self?.userInfo = profile
                        promise(.success(profile))
                    case .failure(let error):
                        promise(.failure(.networkError(error.localizedDescription)))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    enum AuthError: Error {
        case networkError(String)
        case noAccessToken(String)
    }
}
