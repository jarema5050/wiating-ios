//
//  LocationError.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 15/10/2021.
//

import Foundation

public enum LocationError: Error {
    case apiError(String)
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
