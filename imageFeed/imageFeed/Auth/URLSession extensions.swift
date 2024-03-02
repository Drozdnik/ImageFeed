
import Foundation

extension URLSession{
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T,Error>) ->Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if 200 ..< 300 ~= statusCode {
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let object  = try? decoder.decode(T.self, from: data) else {
                        completion (.failure(NetworkError.urlSessionError))
                        return
                    }
                    completion(.success(object))
                } else {
                    completion(.failure(error ?? NetworkError.httpStatusCode(statusCode)))
                    return
                }
            }
        }
        return task
    }
    
}

