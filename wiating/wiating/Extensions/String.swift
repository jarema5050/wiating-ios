//
//  String.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 03/09/2021.
//
import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
