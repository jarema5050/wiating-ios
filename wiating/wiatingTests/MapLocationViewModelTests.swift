//
//  MapLocationViewModelTests.swift
//  wiatingTests
//
//  Created by Jedrzej Sokolowski on 04/01/2022.
//

import XCTest
import CoreLocation
import Combine
@testable import wiating

class MapLocationViewModelTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }

    var testSet = [0,1,17]
    
    func test_dataSourcePopulatedOnInit() throws {
        for locationsCount in testSet {
            let vm = MapLocationViewModel(fetcher: MockLocationsFetcher(locationsCount))
            
            XCTAssertTrue(vm.dataSource.isEmpty, "Data source is not empty on init")

            let promise = expectation(description: "loading \(locationsCount) locations")
            
            vm.$dataSource
                .sink(receiveCompletion: { _ in XCTFail() },
                      receiveValue: { locations in
                        if locations.count == locationsCount {
                            promise.fulfill()
                        }
                })
                .store(in: &subscriptions)
            
            wait(for: [promise], timeout: 1)
        }
    }

    func test_dataSourceEmptyOnError() throws {
        let vm = MapLocationViewModel(fetcher: MockErrorLocationsFetcher())
        
        XCTAssertTrue(vm.dataSource.isEmpty, "Data source is not empty on init")

        let promise = expectation(description: "empty data source at the end")
        
        vm.$dataSource
            .sink(receiveValue: { value in
                if value.isEmpty { promise.fulfill() } else { XCTFail() }
            }).store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
    }
}
