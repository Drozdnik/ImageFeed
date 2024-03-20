import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
}

final class WebViewController: UIViewController & WebViewViewControllerProtocol{
    var presenter: WebViewPresenterProtocol?
    private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    weak var delegate: WebViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        addSubview()
        configureConstraints()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
              options: [],
             changeHandler: {[weak self] _, _ in
                 guard let self = self else {return}
                 self.updateProgress()
             }
        )
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
               URLQueryItem(name: "redirect_uri", value: redirectURI),
               URLQueryItem(name: "response_type", value: "code"),
               URLQueryItem(name: "scope", value: acessScope)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Added Observer
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)
    }

    private func addSubview(){
        view.addSubview(webView)
        view.addSubview(backButton)
        view.addSubview(progressView)
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 4),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = customBlack
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
   @objc private func didTapBackButton(){
       delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            updateProgress()
        } else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress(){
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}
    
extension WebViewController: WKNavigationDelegate{
    func webView(_ webView:WKWebView,
                         decidePolicyFor navigationAction: WKNavigationAction,
                         decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ){
        if let code = code(from: navigationAction){
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code (from navigationAction: WKNavigationAction) -> String?{
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
