import Foundation

final class OAuth2Service{
    private init() {}
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        guard let request = self.authTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            completion(result)
        }
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        guard let baseUrl = URL(string: "https://unsplash.com") else {
            return nil
        }
        let fullPath = "/oauth/token"
        + "?client_id=\(accessKey)"
        + "&&client_secret=\(secretKey)"
        + "&&redirect_uri=\(redirectURI)"
        + "&&code=\(code)"
        + "&&grant_type=authorization_code"
        
        return URLRequest.makeHTTPRequest(path: fullPath, httpMethod: "POST", baseURL: baseUrl)
    }
    
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
    }
}
