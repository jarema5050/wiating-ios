//
//  MapLocationViewModel.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 14/10/2021.
//

import SwiftUI
import Combine
import MapKit

class MapAnnotation: NSObject, MKAnnotation, ObservableObject {
    var coordinate: CLLocationCoordinate2D
    var type: CategoryEnum
    
    @Published var id: String
    
    init(coordinate: CLLocationCoordinate2D, id: String, type: CategoryEnum) {
        self.coordinate = coordinate
        self.id = id
        self.type = type
    }
}


class MapLocationViewModel: ObservableObject, Identifiable {
    @Published var dataSource: [MapAnnotation] = []

    private var disposables = Set<AnyCancellable>()

    init() {
        prepareAnnotations()
    }
    
    func prepareAnnotations() {
        LocationsFetcher.shared.fetchLocations().receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                switch value {
                case .failure:
                  self?.dataSource = []
                case .finished:
                  break
                }
              }, receiveValue: { [weak self] (array) in
                self?.dataSource = array.map {
                    let annotation = MapAnnotation(coordinate: $0.location, id: $0.documentId, type: $0.type)
                    return annotation
                }
            })
            .store(in: &disposables)
    }
}

struct MiniLocation {
    var title: String
    var subtitle: String?
    var type: CategoryEnum
    var imageURL: URL?
}

class MiniLocationViewModel: ObservableObject, Identifiable {
    @Published var location: MiniLocation?
    
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
                  self?.location = MiniLocation(title: model.name, subtitle: model.description, type: model.type, imageURL: model.photos.first)
            })
            .store(in: &disposables)
    }
}
