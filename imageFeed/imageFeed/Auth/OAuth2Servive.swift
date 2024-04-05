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
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code{
                task?.cancel()
            } else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        guard let request = self.authTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    let token = responseBody.accessToken
                        self?.authToken = token
                    completion(.success(responseBody))
                case .failure(let error):
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
   
    private func authTokenRequest(code: String) -> URLRequest? {
        guard let baseUrl = URL(string: "https://unsplash.com") else { 
            return nil
        }
        let fullPath = "/oauth/token"
        + "?client_id=\(Constants.accessKey)"
        + "&&client_secret=\(Constants.secretKey)"
        + "&&redirect_uri=\(Constants.redirectURI)"
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
