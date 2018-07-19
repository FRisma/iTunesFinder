//
//  IFLandingMainViewPresenterTests.swift
//  iTunesFinderTests
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import XCTest

@testable import iTunesFinder

class IFLandingMainViewPresenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPresenterIsCallingService() {
        class MockIFSearchService: IFSearchService {
            var serviceWasCalled = false
            override func getData(_ request: IFSearchRequest, onSuccess: @escaping ([IFElementModel]) -> Void, onFailure: @escaping (Error) -> Void) {
                self.serviceWasCalled = true
                let anElement = IFElementModel(artistName: "SomeArtist", trackName: "SomeTrack", longDesc: "SomeVeryLongDescription", previewURL: "previewURL", artWorkURL: "imageURL")
                
                onSuccess([anElement])
            }
        }
        
        let mockedService = MockIFSearchService()
        
        // Init presenter
        let presenter = IFLandingMainViewPresenter(witService: mockedService)
        presenter.switchedCategory(.tvShow)
        
        // Presenter gets called
        presenter.retrieveData(forText: "text")
        
        // Assert that the presenter is calling the service
        XCTAssertTrue(mockedService.serviceWasCalled)
    }
    
}
