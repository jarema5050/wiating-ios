//
//  GeoPoint+Codable.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 27/12/2021.
//
import FirebaseFirestore
import Foundation

private protocol CodableGeoPoint: Codable {
  var latitude: Double { get }
  var longitude: Double { get }

  init(latitude: Double, longitude: Double)
}

/** The keys in a GeoPoint. Must match the properties of CodableGeoPoint. */
private enum GeoPointKeys: String, CodingKey {
  case latitude
  case longitude
}

/**
 * An extension of GeoPoint that implements the behavior of the Codable protocol.
 *
 * Note: this is implemented manually here because the Swift compiler can't synthesize these methods
 * when declaring an extension to conform to Codable.
 */
extension CodableGeoPoint {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: GeoPointKeys.self)
    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    self.init(latitude: latitude, longitude: longitude)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: GeoPointKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
  }
}

/** Extends GeoPoint to conform to Codable. */
extension GeoPoint: CodableGeoPoint {}
