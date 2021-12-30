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
                  self?.dataSource = array.compactMap {
                      guard let documentId = $0.documentId else { return nil }
                      let annotation = MapAnnotation(coordinate: $0.location, id: documentId, type: $0.type)
                      return annotation
                }
            })
            .store(in: &disposables)
    }
}

