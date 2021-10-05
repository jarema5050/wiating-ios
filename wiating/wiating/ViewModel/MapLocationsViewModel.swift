//
//  MapLocationsViewModel.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 08/09/2021.
//

import Foundation
import MapKit
import Combine

struct MapLocationsViewModel {
    var location: CLLocationCoordinate2D
    var category: CategoryEnum
}

class MapCoordinates {
    var annotations: [MKPointAnnotation]
    private var observer: AnyCancellable?
    
    init() {
        observer = LocationService.shared.download().receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] (err) in
                self?.annotations = []
            }, receiveValue: { [weak self] (array) in
                print("hellofffffff")
                self?.annotations = array.map {
                    let annotation = MKPointAnnotation()
                    annotation.title = $0.name
                    annotation.subtitle = $0.description
                    annotation.coordinate = $0.location
                    return annotation
                }
            })
    }
}
