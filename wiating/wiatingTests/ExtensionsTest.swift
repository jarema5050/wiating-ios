//
//  ExtensionsTest.swift
//  wiatingTests
//
//  Created by Jedrzej Sokolowski on 25/11/2021.
//

import XCTest
@testable import wiating

class ExtensionsTest: XCTestCase {
    
    func testUIImageScalePreservingAspectRatio() {
        guard let image = UIImage(systemName: "cloud") else { return }
        let sizeArr = [CGSize(width: 20, height: 20), CGSize(width: 10, height: 50), CGSize(width: 2, height: 1), CGSize(width: 1000, height: 10)]
        
        for size in sizeArr {
            let newImage = image.scalePreservingAspectRatio(targetSize: size)
            
            XCTAssertLessThanOrEqual(newImage.size.height, size.height)
            XCTAssertLessThanOrEqual(newImage.size.width, size.width)
        }
    }
    
    func testNewDateFormatter() {
        let testSet: [(Double, String)] = [
            (946684800, "1 Jan 2000"), // saturday 1 january 2000 00:00:00
            (1222171861, "23 Sep 2008"), // tuesday 23 september 2008 12:11:01
            (1, "1 Jan 1970"), // czwartek 1 styczen 1970 00:00:01
        ]
        
        
        let formatter = NewDateFormatter()
        for example in testSet {
            XCTAssertEqual(formatter.string(from: Date(timeIntervalSince1970: example.0)), example.1)
        }
    }
}
