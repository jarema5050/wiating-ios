//
//  LocationData.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 08/09/2021.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import CodableFirebase

struct LocationData: Encodable, Identifiable {
    var documentId: String?
    var id = UUID()
    var description: String?
    var fireplaceAccess: FireAccess
    var fireplaceDescription: String?
    var hints: String?
    var lastUpdate: Date
    var location: CLLocationCoordinate2D
    var name: String
    var photos: [URL]
    var type: CategoryEnum
    var waterDescription: String?
    var waterAccess: WaterAccess
    var destroyedNotAccessible: Bool
    
    enum CodingKeys: CodingKey {
        case name
        case description
        case locationHints
        case type
        case waterAccess
        case fireplaceAccess
        case waterDescription
        case firePlaceDescription
        case destroyedNotAccessible
        case location
        case photos
        case lastUpdate
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(hints, forKey: .locationHints)
        try container.encode(destroyedNotAccessible, forKey: .destroyedNotAccessible)
        try container.encode(photos, forKey: .photos)
        try container.encode(type.key, forKey: .type)

        try container.encode(waterAccess.key, forKey: .waterAccess)
        if let waterDescription = waterDescription {
            try container.encode(waterDescription, forKey: .waterDescription)
        }
        
        try container.encode(fireplaceAccess.key, forKey: .fireplaceAccess)
        
        if let fireplaceDescription = fireplaceDescription {
            try container.encode(fireplaceDescription, forKey: .firePlaceDescription)
        }
    }
    
    var fullDict: Dictionary<String, Any> {
        var dict = self.dictionary
        dict.updateValue(GeoPoint(latitude: location.latitude, longitude: location.longitude), forKey: CodingKeys.location.stringValue)
        dict.updateValue(Timestamp(seconds: Int64(Date.now.timeIntervalSince1970), nanoseconds: 0), forKey: CodingKeys.lastUpdate.stringValue)
        return dict
    }
}

extension Timestamp: TimestampType {}
extension GeoPoint: GeoPointType {}
