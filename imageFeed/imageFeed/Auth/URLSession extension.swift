import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }(),
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = self.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse,
                      200 ..< 300 ~= response.statusCode else {
                    completion(.failure(NetworkError.httpStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0)))
                    return
                }
                
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(error))
                    debugPrint("Decodind error: \(error.localizedDescription), Data: \(String(data:data, encoding: .utf8) ?? "")")
                }
            }
        }
        return task
    }
}
