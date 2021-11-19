//
//  LocationsFetcher.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 14/10/2021.
//

import Foundation
import CoreLocation
import Combine
import FirebaseFirestore

protocol LocationsFetchable {
    typealias Locations = [LocationData]
    func fetchLocations() -> AnyPublisher<Locations, LocationError>
}

class LocationsFetcher: LocationsFetchable {
    public static var shared = LocationsFetcher()
    let db = Firestore.firestore()
    
    func fetchLocations() -> AnyPublisher<Locations, LocationError> {
        return download()
    }
    
    private func download() -> AnyPublisher<Locations, LocationError> {
        return Future { [weak self] promise in
            self?.db.collection("places").addSnapshotListener() { (querySnapshot, err) in
                if let err = err {
                    promise(.failure(.apiError(err.localizedDescription)))
                    return
                } else {
                    var locationResponse: Locations = []
                    querySnapshot?.documents.forEach { document in
                        
                        guard let location = self?.decode(document: document) else { return }
                        
                        locationResponse.append(location)
                    }
                    
                    guard !locationResponse.isEmpty else {
                        promise(.failure(.invalidResponse))
                        return
                    }
                    
                    promise(.success(locationResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func decode(document: DocumentSnapshot) -> LocationData? {
        
        guard let data = document.data(), let point = data["location"] as? GeoPoint,
            let timeStamp = data["last_update"] as? Timestamp,
            let name = data["name"] as? String,
            let photos = data["photos"] as? [String],
            let type = CategoryEnum(name: data["type"] as? String)
        else {
            return nil
        }
        let photosUrls = photos.compactMap { URL(string: $0) }
        
        return LocationData (
            documentId: document.documentID,
            description: data["description"] as? String,
            fireplace: data["fireplace"] as? String,
            hints: data["hints"] as? String,
            lastUpdate: timeStamp.dateValue(),
            location: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude),
            name: name,
            photos: photosUrls,
            type: type,
            water: data["water"] as? String
        )
    }
    
    public func getLocation(id: String) -> AnyPublisher<LocationData, LocationError> {
        return Future { [weak self] promise in
            self?.db.collection("places").document(id).addSnapshotListener() { (querySnapshot, err) in
                if let err = err {
                    promise(.failure(.apiError(err.localizedDescription)))
                    return
                } else {
                    guard let snapshot = querySnapshot, let location = self?.decode(document: snapshot) else {
                        promise(.failure(.invalidResponse))
                        return
                    }
                    
                    promise(.success(location))
                }
            }
        }.eraseToAnyPublisher()
    }}
