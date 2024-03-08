
import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    private let storage = OAuth2TokenStorage()
    
    func fetchProfileImage(userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        if task != nil {
            task?.cancel()
        }
        
        guard let token = getToken() else {
            completion(.failure(ProfileError.failedToCreateRequest))
            return
        }
        
        guard let request = imageRequest(userName: userName, token: token) else {
            completion(.failure(ProfileError.failedToCreateRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    guard let smallImageURL = userResult.profileImage.small else {
                        completion(.failure(ProfileError.noData))
                        return
                    }
                    debugPrint(smallImageURL)
                    self?.avatarURL = smallImageURL
                    completion(.success(smallImageURL))
                case .failure(let error):
                    completion(.failure(error))
                    debugPrint("Error in ImageService \(error.localizedDescription)")
                }
                self?.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func imageRequest(userName:String , token: String) -> URLRequest?{
        guard let request = URLRequest.makeRequestWithToken(path: "/users/\(userName)", httpMethod: "GET", token: token) else {
            debugPrint("Не удалось выполнить Imagerequest")
            return nil
        }
        return request
    }
    
    private func getToken() -> String?{
        guard let token = storage.token else {
            return nil
        }
        return token
    }
}
