import Foundation

protocol WebViewControllerDelegate: AnyObject{
    func webViewViewController (_ vs: WebViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel (_ vc: WebViewController)
}
