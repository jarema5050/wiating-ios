//
//  ViewExt.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 16/12/2021.
//

import Foundation
import SwiftUI

extension View {
    public func endEditing() {
        UIApplication.shared.endEditing()
    }
}
