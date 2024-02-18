import UIKit

let tokenStorage = OAuth2TokenStorage()

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
        if let token = tokenStorage.token{
            debugPrint ("Токен получен: ", token)
        } else {
            debugPrint ("Токен проебался")
            return
        }
        
    }
}
