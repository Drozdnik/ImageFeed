import Foundation
enum Constants{
    static let accessKey: String = "TTxNmP3O3DhG3TyWrnQs_Ry_fXjSSExAI6WIe8WmENw"
    static let secretKey: String = "PU9_PPg5qpOgAVsMog9TqURjhiobKqjCdvozO5vUxvM"
    // вторые ключи
//    static let accessKey:String = "QJ4kGWU3hUjtZZLJj9SZ28_BahDeeYvIsh6ap-F_ASM"
//    static let secretKey = "oLM6U1AUYmkRSXlOjUXH4ivGskOC_NOdnJMqOok2q_M"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseUrl = URL(string: "https://api.unsplash.com")
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
        
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
