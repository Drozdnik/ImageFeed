
import WebKit

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
               request.httpMethod = httpMethod
               return request
       }
    
    static func makeProfileRequest(
        path:String,
        httpMethod: String,
        token: String,
        baseUrl: URL = defaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            print("Невозможно создать profile get запрос")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

