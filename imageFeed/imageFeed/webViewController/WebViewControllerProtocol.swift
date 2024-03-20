import Foundation

public protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
}
