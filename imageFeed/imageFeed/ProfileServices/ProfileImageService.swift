
import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
}
