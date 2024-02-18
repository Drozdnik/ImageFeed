import UIKit

let tokenStorage = OAuth2TokenStorage()
private var lastToken: String?
private let urlSession = URLSession.shared
private var task: URLSessionTask?
private let fetchTokenSemaphore = DispatchSemaphore(value: 1)

final class ProfileService{
    
    struct ProfileResult: Codable{
        let userName: String
        let firstName: String
        let lastName: String
        let bio: String
    }
    
    struct Profile{
        let username: String
        let name: String
        let loginName: String
        let bio: String
        
        init(profileResult: ProfileResult) {
            self.username = profileResult.userName
            self.name = profileResult.firstName + " " + profileResult.lastName
            self.loginName = "@" + username
            self.bio = profileResult.bio
        }
    }
    
    func fetchProfile(_ token: String, comletion: @escaping (Result<Profile, Error>) -> Void){

    }
    
    private func getToken() -> String?{
        if let token = tokenStorage.token{
            debugPrint("Токен получен: ", token)
            return token
        } else {
            return nil
        }
    }
    
    private func profileInfoRequest(token: String) -> URLRequest? {
        guard let baseUrl = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        
        var request = URLRequest(url:baseUrl)
        request.httpMethod = "GET"
        guard let token = getToken() else {
            debugPrint("Нет токена")
            return nil
        }

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let URLrequest = request
        
        return URLrequest
    }
}
