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
import FirebaseStorage


public enum ImageError: Error {
    case apiError(String)
    case invalidResponse
}


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
    
    public func uploadAllImages(images: [Data], name: String) -> AnyPublisher<[URL], ImageError> {
        let requests = images.enumerated().map { (index, imageData) in
            return uploadImage(image: imageData, name: name + String(index + 1))
        }
        
        return Publishers.MergeMany(requests)
            .collect()
            .eraseToAnyPublisher()
    }
    
    public func uploadImage(image: Data, name: String) -> AnyPublisher<URL, ImageError> {
        return Future { promise in
            let storage = Storage.storage()
            let storageRef = storage.reference()

            let riversRef = storageRef.child("images/\(name).jpg")

            riversRef.putData(image, metadata: nil) { (_, error) in
                if let error = error {
                    promise(.failure(.apiError(error.localizedDescription)))
                    return
                }
                
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        if let error = error {
                            promise(.failure(.apiError(error.localizedDescription)))
                        }
                        return
                    }
                    
                    promise(.success(downloadURL))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func addNewLocationData(locationData: [String: Any]) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            self?.db.collection("places").addDocument(data: locationData) { err in
                if let err = err {
                    promise(.failure(err))
                } else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
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
        guard let data = document.data(),
              let point = data["location"] as? GeoPoint,
              let timeStamp = data["lastUpdate"] as? Timestamp,
              let name = data["name"] as? String,
              let photos = data["photos"] as? [String],
              let type = CategoryEnum(name: data["type"] as? String),
              let fireplaceAccess = FireAccess(name: data["fireplaceAccess"] as? String),
              let waterAccess = WaterAccess(name: data["waterAccess"] as? String),
              let destroyed = data["destroyedNotAccessible"] as? Bool
        else {
            return nil
        }
        let photosUrls = photos.compactMap { URL(string: $0) }
        
        return LocationData (
            documentId: document.documentID,
            description: data["description"] as? String,
            fireplaceAccess: fireplaceAccess,
            fireplaceDescription: fireplaceAccess == .egsist ? data["fireplaceDescription"] as? String : nil,
            hints: data["hints"] as? String,
            lastUpdate: timeStamp.dateValue(),
            location: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude),
            name: name,
            photos: photosUrls,
            type: type,
            waterDescription: waterAccess == .egsist ? data["waterDescription"] as? String : nil,
            waterAccess: waterAccess,
            destroyedNotAccessible: destroyed
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
