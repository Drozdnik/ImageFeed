import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else {return}
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
        view?.load(request: request)
    }
}
