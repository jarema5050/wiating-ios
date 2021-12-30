//
//  UIApplicationExt.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 16/12/2021.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
