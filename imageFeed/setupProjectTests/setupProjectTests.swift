//
//  setupProjectTests.swift
//  setupProjectTests
//
//  Created by Михаил  on 31.12.2023.
//

import XCTest
@testable import imageFeed

final class ImageListServiceTest: XCTestCase {
    func testFetchPhotosNextPage() {
        let service = ImageListService()
        var resultPhotos: [Photo]?
        var resultError: Error?
        
       
        let expectation = self.expectation(description: "fetchPhotosNextPage completes")
        
        service.fetchPhotosNextPage { result in
            switch result {
            case .success(let photos):
                resultPhotos = photos
            case .failure(let error):
                resultError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(resultPhotos?.count, 10)
        
        
        XCTAssertNotNil(resultPhotos)
        XCTAssertNil(resultError)
    }
}
