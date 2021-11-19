//
//  CategoryEnum.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 03/09/2021.
//

import Foundation
import SwiftUI
enum CategoryEnum: CaseIterable, Identifiable {
        
    case emergencyShelter
    case cabin
    case cabinWithFirePlace
    case campSite
    case cave
    case cabinWithKeeper
    case marine
    case observationTower
    case shelter
    case spring
    case temple
    case urbex
    
    init?(name: String?) {
        guard let name = name else {
            return nil
        }
        switch name {
        case "CAVE":
            self = .cave
        case "SHELTER":
            self = .shelter
        case "CABIN":
            self = .cabin
        case "CABIN_WITH_FIREPLACE":
            self = .cabinWithFirePlace
        case "CABIN_WITH_KEEPER":
            self = .cabinWithKeeper
        case "CAMPSITE":
            self = .campSite
        case "MARINE":
            self = .marine
        case "OBSERVATION_TOWER":
            self = .observationTower
        case "SPRING":
            self = .spring
        case "TEMPLE":
            self = .temple
        case "URBEX":
            self = .urbex
        default:
            return nil
        }
    }
    
    var image: Image? {
        switch self {
        case .emergencyShelter: return Image("emergencyShelter")
        case .cabin: return Image("cabin")
        case .cabinWithFirePlace: return Image("cabinWithFirePlace")
        case .campSite: return Image("campSite")
        case .cave: return Image("cave")
        case .cabinWithKeeper: return Image("cabinWithKeeper")
        case .marine: return Image("marine")
        case .observationTower: return Image("observationTower")
        case .shelter: return Image("shelter")
        case .spring: return Image("spring")
        case .temple: return Image("temple")
        case .urbex: return Image("urbex")
        }
    }
    
    var imageUI: UIImage? {
        switch self {
        case .emergencyShelter: return UIImage(named: "emergencyShelter")
        case .cabin: return UIImage(named: "cabin")
        case .cabinWithFirePlace: return UIImage(named: "cabinWithFirePlace")
        case .campSite: return UIImage(named: "campSite")
        case .cave: return UIImage(named: "cave")
        case .cabinWithKeeper: return UIImage(named: "cabinWithKeeper")
        case .marine: return UIImage(named: "marine")
        case .observationTower: return UIImage(named: "observationTower")
        case .shelter: return UIImage(named: "shelter")
        case .spring: return UIImage(named: "spring")
        case .temple: return UIImage(named: "temple")
        case .urbex: return UIImage(named: "urbex")
        }
    }

    
    var title: String {
        switch self {
        case .emergencyShelter: return "categories-emergencyShelter".localized
        case .cabinWithFirePlace: return "categories-cabinWithFirePlace".localized
        case .campSite: return "categories-campSite".localized
        case .cave: return "categories-cave".localized
        case .cabinWithKeeper: return "categories-cabinWithKeeper".localized
        case .marine: return "categories-marine".localized
        case .observationTower: return "categories-observationTower".localized
        case .shelter: return "categories-shelter".localized
        case .spring: return "categories-spring".localized
        case .temple: return "categories-temple".localized
        case .urbex: return "categories-urbex".localized
        case .cabin: return "categories-cabin".localized
        }
    }
    
    var color: Color {
        switch self {
        case .emergencyShelter: return Color(red: 212/255, green: 0, blue: 0)
        case .cabinWithFirePlace: return Color(red: 1, green: 0, blue: 0)
        case .campSite: return Color(red: 0, green: 0, blue: 128/255)
        case .cave: return Color(red: 117/255, green: 117/255, blue: 117/255)
        case .cabinWithKeeper: return Color(red: 191/255, green: 55/255, blue: 55/255)
        case .marine: return Color(red: 128/255, green: 158/255, blue: 1)
        case .observationTower: return Color(red: 128/255, green: 0, blue: 0)
        case .shelter: return Color(red: 22/255, green: 129/255, blue: 0)
        case .spring: return Color(red: 29/255, green: 82/255, blue: 1)
        case .temple: return Color(red: 153/255, green: 85/255, blue: 1)
        case .urbex: return Color(red: 51/255, green: 51/255, blue: 51/255)
        case .cabin: return Color(red: 252/255, green: 126/255, blue: 47/255)
        }
    }

    var id: UUID { UUID() }

}
