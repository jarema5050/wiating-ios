//
//  ChooseLocationViewModel.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 13/12/2021.
//

import Foundation
import CoreLocation

class ChooseLocationViewModel: ObservableObject {
    @Published var centerCoordinate: CLLocationCoordinate2D?
    
    var shouldUpdateView: Bool = true
    @Published var submitted: Bool = false
    
    var latitude: String {
        get {
            return String(format: "%f", centerCoordinate?.latitude ?? "")
        }
        
        set {
            if let latitude = Double(newValue) {
                centerCoordinate?.latitude = latitude
            }
        }
    }
    
    var longitude: String {
        get {
            return String(format: "%f", centerCoordinate?.longitude ?? "")
        }
        
        set {
            if let longitude = Double(newValue) {
                centerCoordinate?.longitude = longitude
            }
        }
    }
    
    init(_ centerCoordinate: CLLocationCoordinate2D? = nil) { self.centerCoordinate = centerCoordinate }
}

extension ChooseLocationViewModel: Equatable {
    static func == (lhs: ChooseLocationViewModel, rhs: ChooseLocationViewModel) -> Bool {
        lhs.centerCoordinate?.latitude == rhs.centerCoordinate?.latitude && lhs.centerCoordinate?.longitude == rhs.centerCoordinate?.longitude
    }
}
