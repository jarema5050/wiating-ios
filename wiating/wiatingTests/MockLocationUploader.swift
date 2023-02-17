//
//  MockLocationUploader.swift
//  wiatingTests
//
//  Created by Jędrzej Sokołowski on 17/01/2023.
//

import Foundation
@testable import wiating
import Combine

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
