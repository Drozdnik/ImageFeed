import UIKit

let tokenStorage = OAuth2TokenStorage()
private var lastToken: String?
private let urlSession = URLSession.shared
private var task: URLSessionTask?
private let fetchTokenSemaphore = DispatchSemaphore(value: 1)

final class ProfileService{
    private let jsonDecoder :JSONDecoder
    
    init (jsonDecoder: JSONDecoder = JSONDecoder()){
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    struct ProfileResult: Codable{
        let username: String
        let firstName: String
        let lastName: String
        let bio: String?
    }
    
    struct Profile{
        let username: String
        let name: String
        let loginName: String
        let bio: String
        
        init(profileResult: ProfileResult) {
            self.username = profileResult.username
            self.name = profileResult.firstName + " " + profileResult.lastName
            self.loginName = "@" + username
            self.bio = profileResult.bio ?? " "
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        
        
        guard let request = profileInfoRequest(token) else {
            completion(.failure(ProfileError.failedToCreateRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request){ data, response, error in
            if let error = error {
                completion(.failure(ProfileError.taskError))
            }
            
            guard let httpResponce = response as? HTTPURLResponse, (200...299).contains(httpResponce.statusCode) else {
                completion(.failure(ProfileError.invalidResponce))
                return
            }
            
            guard let data = data else {
                completion(.failure(ProfileError.noData))
                return
            }
            
            do{
                let profileResult = try self.jsonDecoder.decode(ProfileResult.self, from: data)
                let profile = Profile(profileResult: profileResult)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    private func getToken() -> String?{
        if let token = tokenStorage.token{
            debugPrint("Токен получен: ", token)
            return token
        } else {
            return nil
        }
    }
    
    private func profileInfoRequest(_ token: String) -> URLRequest? {
        guard let request = URLRequest.makeProfileRequest(path: "/me", httpMethod: "GET", token: token) else {
            assertionFailure("Не удалось создать request")
            return nil
        }
        
        return request
    }
}



