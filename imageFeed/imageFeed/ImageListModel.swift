import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDesctiption: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable{
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let description: String?
    let likedByUser: Bool
    let urls: URlImageResult
}

struct URlImageResult:Decodable{
    let thumb: String
    let full: String
}

// ToDo
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()
