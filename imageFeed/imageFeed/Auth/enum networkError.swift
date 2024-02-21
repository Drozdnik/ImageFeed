
import Foundation

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
}

enum ProfileError: Error {
    case failedToCreateRequest
    case networkError
    case decodingError
    case taskError
    case invalidResponce
    case noData
}



