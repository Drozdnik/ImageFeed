import UIKit
import WebKit

class WebViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func addSubview(){
        
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
        ])
    }
    
    private lazy var backButton:UIButton = {
        let backButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(didTapButton)
        )
        
    }()
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.backgroundColor =  customWhiteBackGrounds
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private func didTapBackButton(){
        print ("Back")
    }
}
