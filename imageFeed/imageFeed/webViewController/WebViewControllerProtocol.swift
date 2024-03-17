//
//  WebViewControllerProtocol.swift
//  imageFeed
//
//  Created by Михаил  on 17.03.2024.
//

import Foundation

public protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
}
