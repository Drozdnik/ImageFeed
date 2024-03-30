//
//  WebViewViewControllerSpy.swift
//  imageFeed
//
//  Created by Михаил  on 23.03.2024.
//

import Foundation


final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var viewDidLoadRequest = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        viewDidLoadRequest = true
    }
    
    func setProgressValue(_ newValue: Float) {   }
    
    func setProgressHidden(_ isHidden: Bool) {   }
    
    
}
