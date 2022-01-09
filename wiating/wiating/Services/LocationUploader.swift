//
//  LocationUploader.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 04/01/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseStorage

public enum ImageError: Error {
    case apiError(String)
    case invalidResponse
}

protocol LocationUploadable {
    func uploadAllImages(images: [Data], name: String) -> AnyPublisher<[URL], ImageError>
    func addNewLocationData(locationData: [String: Any]) -> AnyPublisher<Bool, Never>
}

struct LocationUploader: LocationUploadable {
    let db = Firestore.firestore()
    
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
    
    public func addNewLocationData(locationData: [String: Any]) -> AnyPublisher<Bool, Never> {
        return Future { promise in
            db.collection("places").addDocument(data: locationData) { err in
                if let _ = err {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
}
