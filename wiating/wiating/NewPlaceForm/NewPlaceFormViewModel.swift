//
//  NewPlaceFormViewModel.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 16/12/2021.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import UIKit
import Combine
import SwiftUI

struct NewPlaceResult {
    var newPlaceAdded: Bool
}

class NewPlaceFormViewModel: ObservableObject {
    @Published var placeName: String = ""
    @Published var description: String = ""
    @Published var locationHints: String = ""
    
    @Published var type: CategoryEnum = .cabin
    @Published var waterAccess: WaterAccess = .notSpecified
    @Published var firePlaceAccess: FireAccess = .notSpecified
    
    var waterDescription: String = ""
    var fireplaceDescription: String = ""
    
    var destroyedNotAccessible: Bool = false
    
    @Published var centralCoordinate: CLLocationCoordinate2D?
    @Published var progressPresented: Bool = false
    
    @Published var imgArray: [UIImage] = []
    @Published var isPresented: Bool = true
    @Published var formIsReady: Bool = false
    @Published var errorToastIsPresented: Bool = false
    
    var imgDataArray: [Data] { imgArray.compactMap({ $0.pngData() }) }
    
    private var isReadyToSend: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4($placeName, $description, $locationHints, $centralCoordinate)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { name, desc, hints, coords in
                guard !name.isEmpty,
                      !desc.isEmpty,
                      !hints.isEmpty,
                      coords != nil
                else { return false }
                return true
            }.eraseToAnyPublisher()
    }
    
    private var disposables = Set<AnyCancellable>()
    private var sender: LocationUploadable
    
    lazy var locationData: LocationData? = {
        guard let centralCoordinate = centralCoordinate else {
            return nil
        }
        
        let fireDesc = firePlaceAccess == .egsist ? fireplaceDescription : nil
        let waterDesc = waterAccess == .egsist ? fireplaceDescription : nil
        
        return LocationData(description: description, fireplaceAccess: firePlaceAccess, fireplaceDescription: fireDesc, hints: locationHints, lastUpdate: .now, location: centralCoordinate, name: placeName, photos: [], type: type, waterDescription: waterDesc, waterAccess: waterAccess, destroyedNotAccessible: destroyedNotAccessible)
    }()
    
    init(sender: LocationUploadable) {
        self.sender = sender
        isReadyToSend.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isReady in
                self?.formIsReady = isReady
            })
            .store(in: &disposables)
    }
    
    public func uploadAll() {
        guard formIsReady else { return }
        progressPresented = true
        
        sender.uploadAllImages(images: imgDataArray, name: placeName.trimmingCharacters(in: .whitespacesAndNewlines))
            .catch({ error -> Future<[URL], Never> in return Future { $0(.success([])) } })
            .flatMap({ [weak self] urls -> AnyPublisher<Bool, Never> in
                self?.locationData?.photos = urls
                if let strongSelf = self {
                    return strongSelf.sender.addNewLocationData(locationData: self?.locationData?.fullDict ?? [:])
                } else { return Just(false).eraseToAnyPublisher() }
            })
            .sink( receiveValue: { [weak self] success in
                self?.isPresented = false
                if !success {
                    self?.errorToastIsPresented = true
                }
            })
            .store(in: &disposables)
    }
}

extension CLLocationCoordinate2D {
    var description: String {
        "\(self.latitude), \(self.longitude)"
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
