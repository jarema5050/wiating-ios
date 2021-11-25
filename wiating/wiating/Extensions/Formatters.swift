//
//  Formatters.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 25/11/2021.
//

import Foundation

class NewDateFormatter: DateFormatter {
    override init() {
        super.init()
        self.dateFormat = "d MMM yyyy"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
