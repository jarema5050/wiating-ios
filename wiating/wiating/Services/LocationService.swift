//
//  LocationService.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 06/09/2021.
//

import Foundation
import FirebaseFirestore
import Combine
import CoreLocation

public enum LocationError: Error {
    case apiError(String)
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}

public class LocationService {
    
    static let shared = LocationService()
    let db = Firestore.firestore()
    
    var locationResponse: [LocationData]?
    
    func download() -> Future<[LocationData], LocationError> {
        
        return Future { [weak self] promise in
            if let response = self?.locationResponse {
                promise(.success(response))
                return
            }
            self?.db.collection("places").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    promise(.failure(.apiError(err.localizedDescription)))
                    return
                } else {
                    self?.locationResponse = []
                    
                    querySnapshot?.documents.forEach { document in
                        print("\(document.documentID) => \(document.data())")
                        
                        guard let point = document.data()["location"] as? GeoPoint,
                              let timeStamp = document.data()["last_update"] as? Timestamp,
                              let name = document.data()["name"] as? String,
                              let photos = document.data()["photos"] as? [String],
                              let type = CategoryEnum(name: document.data()["type"] as? String)
                              else { return }
                        let photosUrls = photos.compactMap{ URL(string: $0) }
                        
                        let locationData = LocationData(description: document.data()["description"] as? String, fireplace: document.data()["fireplace"] as? String, hints: document.data()["hints"] as? String, lastUpdate: timeStamp.dateValue(), location:                     CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude), name: name, photos: photosUrls, type: type, water: document.data()["water"] as? String)
                        
                        self?.locationResponse?.append(locationData)
                    }
                    
                    guard let locationResponse = self?.locationResponse, !locationResponse.isEmpty else {
                        promise(.failure(.invalidResponse))
                        return
                    }
                    
                    promise(.success(locationResponse))
                }
            }
        }
    }
        
    private func handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
    
}
