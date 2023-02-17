//
//  LoginButtonViewModel.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 07/12/2021.
//

import Foundation
import Combine

struct LoginButtonModel {
    var name: String?
    var image: URL?
    var loggedIn: Bool = false
}

class LoginButtonViewModel: ObservableObject, Identifiable {
    @Published var buttonData: LoginButtonModel?
    
    private var disposables = Set<AnyCancellable>()
    
    init() {
        reload()
    }
    
    func reload() {
        AuthManager.shared.publisher(for: \.loggedIn).receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoggedIn in
                self?.buttonData?.loggedIn = isLoggedIn
                if isLoggedIn {
                    self?.setupDetailsSubscription()
                } else {
                    self?.buttonData?.name = nil
                    self?.buttonData?.image = nil
                }
            })
            .store(in: &disposables)
    }
    
    func setupDetailsSubscription() {
        AuthManager.shared.getUserDetails().receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                switch value {
                case .failure:
                    self?.buttonData = nil
                case .finished:
                  break
                }
              }, receiveValue: { [weak self] (model) in
                  self?.buttonData = LoginButtonModel(name: model.name, image: model.picture, loggedIn: true)
            })
            .store(in: &disposables)
    }
}
