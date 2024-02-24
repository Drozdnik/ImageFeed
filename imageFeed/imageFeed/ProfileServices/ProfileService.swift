import UIKit

private let urlSession = URLSession.shared
private var task: URLSessionTask?

final class ProfileService{
    
    static let sharedProfile = ProfileService()
    private(set) var profile:Profile?
    let tokenStorage = OAuth2TokenStorage()
    private let profileQueue = DispatchQueue(label: "com.profileService")
    private init (){
        self.jsonDecoder = JSONDecoder()
    }
    
    private let jsonDecoder: JSONDecoder
    init (jsonDecoder: JSONDecoder = JSONDecoder()){
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        print (token)
        guard let request = profileInfoRequest(token) else {
            completion(.failure(ProfileError.failedToCreateRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request){ data, response, error in
            self.profileQueue.sync {
                
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
                DispatchQueue.main.async {
                do{
                        let profileResult = try self.jsonDecoder.decode(ProfileResult.self, from: data)
                        let profile = Profile(profileResult: profileResult)
                        completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            }
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



