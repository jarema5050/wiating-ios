//
//  AuthManagerTests.swift
//  wiatingTests
//
//  Created by Jedrzej Sokolowski on 25/11/2021.
//

import XCTest
@testable import wiating
import FirebaseAuth

class AuthManagerTests: XCTestCase {

    func testSetWithError() {
        let error: NSError = .init(domain: "", code: -1, userInfo: nil)
        AuthManager.shared.setWithError(error: error)
        XCTAssertFalse(AuthManager.shared.loggedIn)
        XCTAssertNotNil(AuthManager.shared.error)
    }
    
}
