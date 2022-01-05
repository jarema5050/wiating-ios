//
//  MiniLocationViewModelTests.swift
//  wiatingTests
//
//  Created by Jedrzej Sokolowski on 04/01/2022.
//

import XCTest
import Combine
@testable import wiating

class MiniLocationViewModelTests: XCTestCase {
    var disposables = Set<AnyCancellable>()
    
    func testLoadingDataOnInit() throws {
        let vm = MiniLocationViewModel(fetcher: MockLocationsFetcher(), id: "id")
        
        XCTAssertNil(vm.location)
        XCTAssertNil(vm.locationData)
        
        let promise = expectation(description: "location property not nil and locationData not nil")
        
        vm.$location
            .sink(
                receiveCompletion: { _ in XCTFail() },
                receiveValue: { value in
                    guard value != nil else { return }
                    promise.fulfill()
                }
            )
            .store(in: &disposables)
        
        wait(for: [promise], timeout: 1)
        
        XCTAssertNotNil(vm.location)
        XCTAssertNotNil(vm.locationData)
    }
    
    func testLoadingDataWithError() throws {
        let vm = MiniLocationViewModel(fetcher: MockErrorLocationsFetcher(), id: "id")
        
        XCTAssertNil(vm.location)
        XCTAssertNil(vm.locationData)
        
        let promise = expectation(description: "location property and locationData should be nil after loading with errors")
        
        vm.$location
            .sink(
                receiveValue: { value in
                    if value == nil { promise.fulfill() } else { XCTFail() }
                }
            )
            .store(in: &disposables)
        
        wait(for: [promise], timeout: 1)
        
        XCTAssertNil(vm.location)
        XCTAssertNil(vm.locationData)
    }
    
    func test_dataSourceEmptyWhenReceivedLocationsDocumentIdIsNil() throws {
        let fetcher = MockLocationsFetcher()
        fetcher.locData.documentId = nil
        
        let vm = MiniLocationViewModel(fetcher: fetcher, id: "id")
        
        XCTAssertNil(vm.location, "Location should be nil at initialization")
        XCTAssertNil(vm.locationData, "Location should be nil at initialization")

    
        let promise = expectation(description: "empty data source at the end")
        
        vm.$location
            .sink(receiveValue: { value in
                if value == nil { promise.fulfill() } else { XCTFail() }
            })
            .store(in: &disposables)
    
        
        wait(for: [promise], timeout: 1)
        
        XCTAssertNil(vm.location, "Location should be nil after loading")
        XCTAssertNil(vm.locationData, "Location should be nil after loading")
    }
}
