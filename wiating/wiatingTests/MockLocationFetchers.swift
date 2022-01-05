//
//  MockLocationFetchers.swift
//  wiatingTests
//
//  Created by Jedrzej Sokolowski on 05/01/2022.
//

import Foundation
import CoreLocation
@testable import wiating
import Combine

class MockLocationsFetcher: LocationsFetchable {
    let locationsCount: Int
    
    var locData = LocationData(documentId: "", description: "Hello", fireplaceAccess: .egsist, fireplaceDescription: "Hello", hints: "Hello", lastUpdate: Date.now, location: CLLocationCoordinate2D(), name: "Test Obj", photos: [], type: .cave, waterDescription: "Hello", waterAccess: .egsist, destroyedNotAccessible: false)
    
    init(_ locationsCount: Int = 0) {
        self.locationsCount = locationsCount
    }
    
    func getLocation(id: String) -> AnyPublisher<LocationData, LocationError> {
        return Just(locData)
            .setFailureType(to: LocationError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchLocations() -> AnyPublisher<Locations, LocationError> {
        let array = [LocationData] (repeating: locData, count: locationsCount)

        return Just(array)
            .setFailureType(to: LocationError.self)
            .eraseToAnyPublisher()
    }
}

class MockErrorLocationsFetcher: LocationsFetchable {
    func getLocation(id: String) -> AnyPublisher<LocationData, LocationError> {
        let locData = LocationData(documentId: "", description: "Hello", fireplaceAccess: .egsist, fireplaceDescription: "Hello", hints: "Hello", lastUpdate: Date.now, location: CLLocationCoordinate2D(), name: "Test Obj", photos: [], type: .cave, waterDescription: "Hello", waterAccess: .egsist, destroyedNotAccessible: false)

        return Just(locData)
            .setFailureType(to: LocationError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchLocations() -> AnyPublisher<Locations, LocationError> {
        Fail<Locations, LocationError>(error: LocationError.testError).eraseToAnyPublisher()
    }
}
