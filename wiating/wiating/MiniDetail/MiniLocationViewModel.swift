//
//  MiniLocationViewModel.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 09/12/2021.
//

import Foundation
import Combine

class MiniLocationViewModel: ObservableObject, Identifiable {
    @Published var location: MiniLocation?
    var locationData: LocationData?
    
    private var disposables = Set<AnyCancellable>()
    
    init(id: String? = nil) {
        guard let id = id else { return }
        LocationsFetcher.shared.getLocation(id: id).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                switch value {
                case .failure:
                    self?.location = nil
                case .finished:
                  break
                }
              }, receiveValue: { [weak self] (model) in
                  guard let documentId = model.documentId else {
                      self?.location = nil
                      return
                  }
                  self?.location = MiniLocation(title: model.name, subtitle: model.description, type: model.type, imageURL: model.photos.first, id: documentId)
                  self?.locationData = model
            })
            .store(in: &disposables)
    }
}
