//
//  setupProjectTests.swift
//  setupProjectTests
//
//  Created by Михаил  on 31.12.2023.
//

import XCTest
@testable import imageFeed

final class WebViewTests: XCTestCase{
    //given
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.viewDidLoadRequest)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne(){
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        if let url = authHelper.authURL(){
            let urlString = url.absoluteString
            XCTAssertTrue(urlString.contains(configuration.authURLString))
            XCTAssertTrue(urlString.contains(configuration.accessKey))
            XCTAssertTrue(urlString.contains(configuration.redirectURI))
            XCTAssertTrue(urlString.contains("code"))
            XCTAssertTrue(urlString.contains(configuration.accessScope))
        }
    }
        func testCodeFromURL() {
            var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
            urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
            let url = urlComponents.url!
            let authHelper = AuthHelper()
            
            //when
            let code = authHelper.code(from: url)
            
            //then
            XCTAssertEqual(code, "test code")
        
    }
}

// ImageListTests
final class ImagesListTests: XCTestCase {
    func testImageListPresenterCalledViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        // given
        
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
