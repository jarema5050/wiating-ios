//
//  NewPlaceFormViewModelTest.swift
//  wiatingTests
//
//  Created by Jedrzej Sokolowski on 05/01/2022.
//

import XCTest
import Combine
import CoreLocation
@testable import wiating

struct MockLocationUploader: LocationUploadable {
    
    var imagesResult: Result<[URL], ImageError>
    var locationResult: Result<Bool, Never>
    
    func uploadAllImages(images: [Data], name: String) ->
    AnyPublisher<[URL], ImageError> {
        imagesResult.publisher.eraseToAnyPublisher()
    }
    
    func addNewLocationData(locationData: [String : Any]) -> AnyPublisher<Bool, Never> {
        locationResult.publisher.eraseToAnyPublisher()    }
}

class NewPlaceFormViewModelTest: XCTestCase {
    var disposables = Set<AnyCancellable>()
    
    struct VMFields {
        var placeName: String
        var desc: String
        var hints: String
        var coords: CLLocationCoordinate2D?
        var expectation: Bool
     }
    
    var testCases: [VMFields] = [
        VMFields(placeName: "Nazwa", desc: "Opis", hints: "Wskazowki", coords: CLLocationCoordinate2D(), expectation: true),
        VMFields(placeName: "", desc: "Opis", hints: "Wskazowki", coords: CLLocationCoordinate2D(), expectation: false),
        VMFields(placeName: "Nazwa", desc: "", hints: "Wskazowki", coords: CLLocationCoordinate2D(), expectation: false),
        VMFields(placeName: "Nazwa", desc: "Opis", hints: "Wskazowki", coords: nil, expectation: false),
        VMFields(placeName: "", desc: "", hints: "", coords: nil, expectation: false),
        VMFields(placeName: "", desc: "", hints: "Wskazowki", coords: CLLocationCoordinate2D(), expectation: false),
    ]
    
    func testIsReadyToSendSetsFormIsReady() throws {
        testCases.forEach({ testCase in
            let vm = NewPlaceFormViewModel(sender: MockLocationUploader(imagesResult: .success([]), locationResult: .success(true)))
            
            vm.placeName = testCase.placeName
            vm.description = testCase.desc
            vm.locationHints = testCase.hints
            vm.centralCoordinate = testCase.coords

            let promise = expectation(description: "form is ready on \(testCase) returns \(testCase.expectation)")
            
            vm.$formIsReady.sink(receiveValue: {
                if $0 == testCase.expectation { promise.fulfill() }
            })
                .store(in: &disposables)
            
            wait(for: [promise], timeout: 1.5)
        })
    }
    
    var testModels: [(NewPlaceFormViewModel, Bool)] = [
        // (viewModel, errorPresented and formIsPresented)
        ({
            let imagesCount = 3
            let url = URL(string: "https://www.google.com/")!
            
            var vm = NewPlaceFormViewModel(sender: MockLocationUploader(imagesResult:.success([URL] (repeating: url, count: imagesCount)), locationResult: .success(true)))
            
            let image = UIImage(systemName: "plus")!
            
            vm.imgArray = [UIImage] (repeating: image, count: imagesCount)
            
            vm.placeName = "Place name"
            vm.description = "Description"
            vm.locationHints = "Location hints"
            
            vm.waterAccess = .egsist
            vm.waterDescription = "Water description"
            
            vm.firePlaceAccess = .egsist
            vm.fireplaceDescription = "Fireplace description"
            
            vm.centralCoordinate = CLLocationCoordinate2D()
            vm.formIsReady = true
            
            return vm
        }(), false),
        
        ({
            let imagesCount = 3
            let url = URL(string: "https://www.google.com/")!
            
            var vm = NewPlaceFormViewModel(sender: MockLocationUploader(imagesResult: .success([URL] (repeating: url, count: imagesCount)), locationResult: .success(true)))
            
            vm.placeName = "Place name"
            vm.description = "Description"
            vm.locationHints = "Location hints"
            
            vm.waterAccess = .egsist
            vm.waterDescription = "Water description"
            
            vm.firePlaceAccess = .egsist
            vm.fireplaceDescription = "Fireplace description"
            
            vm.centralCoordinate = CLLocationCoordinate2D()
            
            return vm
        }(), true),
        
        ({
            let imagesCount = 5
            let url = URL(string: "https://www.google.com/")!
            
            var vm = NewPlaceFormViewModel(sender: MockLocationUploader(imagesResult: .success([URL] (repeating: url, count: imagesCount)), locationResult: .success(true)))
            
            let image = UIImage(systemName: "plus")!
            
            vm.imgArray = [UIImage] (repeating: image, count: imagesCount)
            
            vm.placeName = "Place name"
            vm.description = "Description"
            vm.locationHints = "Location hints"
            
            vm.waterAccess = .notEgsist
            
            vm.firePlaceAccess = .egsist
            vm.fireplaceDescription = "Fireplace description"
            
            vm.centralCoordinate = CLLocationCoordinate2D()

            return vm
        }(), false),
        
        ({
            let imagesCount = 5
            let url = URL(string: "https://www.google.com/")!
            
            var vm = NewPlaceFormViewModel(sender: MockLocationUploader(imagesResult:.success([URL] (repeating: url, count: imagesCount-2)), locationResult: .success(true)))
            
            let image = UIImage(systemName: "plus")!
            
            vm.imgArray = [UIImage] (repeating: image, count: imagesCount)
            
            vm.placeName = "Place name"
            vm.description = "Description"
            vm.locationHints = "Location hints"
            
            vm.waterAccess = .notEgsist
            
            vm.firePlaceAccess = .notEgsist
            
            vm.centralCoordinate = CLLocationCoordinate2D()
            
            return vm
        }(), true),
        
        ({
            let imagesCount = 1
            let url = URL(string: "https://www.google.com/")!
            
            var vm = NewPlaceFormViewModel(sender: MockLocationUploader(imagesResult: .failure(ImageError.invalidResponse), locationResult: .success(false)))
            
            let image = UIImage(systemName: "plus")!
            
            vm.imgArray = [UIImage] (repeating: image, count: imagesCount)
            
            vm.placeName = "Place name"
            vm.description = "Description"
            vm.locationHints = "Location hints"
            
            vm.waterAccess = .notEgsist
            
            vm.firePlaceAccess = .notEgsist
            
            vm.centralCoordinate = CLLocationCoordinate2D()
            
            return vm
        }(), true),
        
        ({
            let imagesCount = 5
            let url = URL(string: "https://www.google.com/")!
            
            var vm = NewPlaceFormViewModel(sender: MockLocationUploader(imagesResult: .success([URL] (repeating: url, count: imagesCount)), locationResult: .success(false)))
            
            let image = UIImage(systemName: "plus")!
            
            vm.imgArray = [UIImage] (repeating: image, count: imagesCount)
            
            vm.placeName = "Place name"
            vm.description = "Description"
            vm.locationHints = "Location hints"
            
            vm.waterAccess = .notEgsist
            
            vm.firePlaceAccess = .notEgsist
            
            vm.centralCoordinate = CLLocationCoordinate2D()
            
            return vm
        }(), true),
    ]
    
    func testUploadAll() throws {
        for index in 0..<testModels.count {
            print("TEST Model Index: \(index)")
            testUploadAll(vm: testModels[index].0, errorPresentedAndFormPresented: testModels[index].1)
        }
    }
    
    func testUploadAll(vm: NewPlaceFormViewModel, errorPresentedAndFormPresented: Bool){
        XCTAssertTrue(vm.isPresented, "Form view is presented - expected true")
        
        XCTAssertFalse(vm.errorToastIsPresented, "Error toast is presented - expected false")
        
        XCTAssertFalse(vm.progressPresented, "Progress should be presented on just on loading")
        
        let promise = expectation(description: "Is presented and error toast is presented --- expected: \(errorPresentedAndFormPresented)")
        
        vm.uploadAll()
        
        Publishers.CombineLatest3(vm.$isPresented, vm.$errorToastIsPresented, vm.$progressPresented)
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink(receiveValue: { (isPresented, errorToastIsPresented, progressPresented) in
                if isPresented == errorPresentedAndFormPresented,
                   errorToastIsPresented == errorPresentedAndFormPresented,
                   !progressPresented {
                    promise.fulfill()
                }
            })
            .store(in: &disposables)
        
        wait(for: [promise], timeout: 3.0)
    }
    
    override func tearDown() {
        disposables.removeAll()
    }
}
