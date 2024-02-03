import UIKit
import WebKit

class WebViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        configureConstraints()
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
               URLQueryItem(name: "redirect_uri", value: redirectURI),
               URLQueryItem(name: "response_type", value: "code"),
               URLQueryItem(name: "scope", value: acessScope)
        ]
        
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func addSubview(){
        view.addSubview(webView)
        view.addSubview(backButton)
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
    }
    
    private lazy var backButton:UIButton = {
        let backButton = UIButton.systemButton(
            with: UIImage(systemName: "chevron.backward")!,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButton.tintColor = customBlack
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.backgroundColor =  customWhiteBackGrounds
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
   @objc private func didTapBackButton(){
        print ("Back")
    }
}
