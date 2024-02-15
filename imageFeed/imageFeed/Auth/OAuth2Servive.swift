import Foundation

fileprivate let defaultURL = URL(string: "https://api.unsplash.com")!

final class OAuth2Service{
    private init() {}
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void ){
            if let request = authTokenRequest(code: code){
                let task = object(for: request) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let body):
                        let authToken = body.accessToken
                        self.authToken = authToken
                        completion(.success(authToken))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                task.resume()
            } else {
                assertionFailure("Request failed")
            }
        }
}
    extension OAuth2Service {
        private func object(
            for request: URLRequest,
            completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
        ) -> URLSessionTask {
            let decoder = JSONDecoder()
            return urlSession.data(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                    Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
    }
                completion(response)
            }
    }
        
        private func authTokenRequest(code: String) -> URLRequest? {
                let path = "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code"
            return URLRequest.makeHTTPRequest(path: path, httpMethod: "POST", baseURL: defaultBaseURL)
    }
        
        private struct OAuthTokenResponseBody: Decodable {
            let accessToken: String
            let tokenType: String
            let scope: String
            let createdAt: Int
            enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case tokenType = "token_type"
                case scope
                case createdAt = "created_at"
            }
    } }

    // MARK: - HTTP Request
           extension URLSession {
               func data(
                   for request: URLRequest,
                   completion: @escaping (Result<Data, Error>) -> Void
               ) -> URLSessionTask {
                   let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
                       DispatchQueue.main.async {
                           completion(result)
                       }
           }
                   
                   let task = dataTask(with: request, completionHandler: { data, response, error in
                       if let data = data,
                           let response = response,
                           let statusCode = (response as? HTTPURLResponse)?.statusCode
                       {
                           if 200 ..< 300 ~= statusCode {
                               fulfillCompletion(.success(data))
                           } else {
                               fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                           }
                       } else if let error = error {
                           fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                       } else {
                           fulfillCompletion(.failure(NetworkError.urlSessionError))
                       }
                   })
                   task.resume()
                   return task
           } }
