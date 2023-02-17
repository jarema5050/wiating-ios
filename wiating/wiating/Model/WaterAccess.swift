//
//  WaterAccess.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 14/12/2021.
//

import Foundation

enum WaterAccess: AccessEnum, CaseIterable {
    case egsist
    case notEgsist
    case notSpecified
    
    init?(name: String?) {
        guard let name = name else {
            return nil
        }
        
        switch name {
        case "EGSIST": self = .egsist
        case "NOT_EGSIST": self = .notEgsist
        case "NOT_SPECIFIED": self = .notSpecified
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .egsist: return "water-access-egsist".localized
        case .notEgsist: return "water-access-notEgsist".localized
        case .notSpecified: return "water-access-notSpecified".localized
        }
    }
    
    var key: String {
        switch self {
        case .egsist: return "EGSIST"
        case .notEgsist: return "NOT_EGSIST"
        case .notSpecified: return "NOT_SPECIFIED"
        }
    }
}

enum FireAccess: AccessEnum, CaseIterable {
    case egsist
    case notEgsist
    case notSpecified
    
    init?(name: String?) {
        guard let name = name else {
            return nil
        }
        
        switch name {
        case "EGSIST": self = .egsist
        case "NOT_EGSIST": self = .notEgsist
        case "NOT_SPECIFIED": self = .notSpecified
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .egsist: return "fire-access-egsist".localized
        case .notEgsist: return "fire-access-notEgsist".localized
        case .notSpecified: return "fire-access-notSpecified".localized
        }
    }
    
    var key: String {
        switch self {
        case .egsist: return "EGSIST"
        case .notEgsist: return "NOT_EGSIST"
        case .notSpecified: return "NOT_SPECIFIED"
        }
    }
}

protocol AccessEnum {
    init?(name: String?)
    
    var name: String { get }
    var key: String { get }
}
