import UIKit

private let urlSession = URLSession.shared
private var task: URLSessionTask?

final class ProfileService{
    
    static let sharedProfile = ProfileService()
    private(set) var profile:Profile?
    let tokenStorage = OAuth2TokenStorage()
    private let profileQueue = DispatchQueue(label: "com.profileService")
    private init (){}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        if tokenStorage.token == nil {
            tokenStorage.token = token
        }
        guard let request = profileInfoRequest(token) else {
            completion(.failure(ProfileError.failedToCreateRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(profileResult: profileResult)
                    self?.profile = profile
                    completion (.success(profile))
                case .failure(let error):
                    completion (.failure(error))
                    
                }
            }
        }
        task.resume()
    }
    
    private func profileInfoRequest(_ token: String) -> URLRequest? {
        guard let request = URLRequest.makeProfileRequest(path: "/me", httpMethod: "GET", token: token) else {
            assertionFailure("Не удалось создать request")
            return nil
        }
        
        return request
    }
}



