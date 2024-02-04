import Foundation

class OAuth2TokenStorage{
    private let tokenKey = "oauth2Token"
    
    var token: String?{
        get{
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
