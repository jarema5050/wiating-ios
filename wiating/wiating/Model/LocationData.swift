//
//  LocationData.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 08/09/2021.
//

import Foundation
import CoreLocation

struct LocationData {
    var description: String?
    var fireplace: String?
    var hints: String?
    var lastUpdate: Date
    var location: CLLocationCoordinate2D
    var name: String
    var photos: [URL]
    var type: CategoryEnum
    var water: String?
}
