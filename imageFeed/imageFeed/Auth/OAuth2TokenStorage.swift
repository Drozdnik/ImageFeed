import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage{
    private let keyChain = KeychainWrapper.standard
    
    private let tokenKey = "oauth2Token"
    
    var token: String?{
        get{
            return keyChain.string(forKey: tokenKey)
        }
        set{
            if let newValue = newValue{
                keyChain.set(newValue, forKey: tokenKey)
            } else {
                keyChain.removeObject(forKey: tokenKey)
            }
        }
    }
}
