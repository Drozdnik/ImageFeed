
import Foundation

struct UserResult:Decodable{
    let profileImage: smallImageResult 
}

struct smallImageResult: Decodable{
    let small: String?
    let medium: String
    let large: String
}
