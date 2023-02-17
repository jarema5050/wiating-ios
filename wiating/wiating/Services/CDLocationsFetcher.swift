//
//  CDLocationsFetcher.swift
//  wiating
//
//  Created by Jędrzej Sokołowski on 16/01/2023.
//

import Combine
import CoreData
import CoreLocation

struct CDLocationsFetcher: LocationsFetchable {
    private let context: NSManagedObjectContext
    
    func fetchLocations() -> AnyPublisher<Locations, LocationError> {
//        Future<Locations, LocationError>() { promise in
//            let locations = await context.perform {
//                CDLocation.fetchRequest().execute()
//            }
//        }
        
        Empty<Locations, LocationError>().eraseToAnyPublisher()
    }
    
    func getLocation(id: String) -> AnyPublisher<LocationData, LocationError> {
        Empty<LocationData,LocationError>().eraseToAnyPublisher()
    }
    
//    private func mapToLocationData(cdLocation: CDLocation) -> LocationData? {
//        LocationData(fireplaceAccess: FireAccess(name: cdLocation.fireplaceAccess), lastUpdate: cdLocation.lastUpdate, location: CLLocationCoordinate2D(latitude: cdLocation.latitude, longitude: cdLocation.longitude), name: cdLocation.name, photos:, type: CategoryEnum(name: cdLocation.category), waterAccess: WaterAccess(name: cdLocation.waterAccess), destroyedNotAccessible: cdLocation.destroyed)
//    }
}
