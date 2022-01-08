//
//  DetailSheetViewModel.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 09/12/2021.
//

import Foundation

class DetailSheetViewModel {
    var data: LocationData
    
    var locationStr: String {
        "\(data.location.latitude) N, \(data.location.longitude) E"
    }
    
    init(locationData: LocationData) {
        self.data = locationData
    }
}
