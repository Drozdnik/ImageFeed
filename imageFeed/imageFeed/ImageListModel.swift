import Foundation
let isoDateFormatter = ISO8601DateFormatter()

struct Photo: Decodable{
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.createdAt = photoResult.dateCreatedAt
        self.welcomeDescription = photoResult.description ?? " "
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
    }
}

struct PhotoResult: Decodable{
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    var likedByUser: Bool
    let urls: URlImageResult
    
    var dateCreatedAt: Date?{
        guard let createdAtString = createdAt else {return nil}
        return isoDateFormatter.date(from: createdAtString)
        
    }
}

struct URlImageResult:Decodable{
    let thumb: String
    let full: String
}

struct LikeResponce: Decodable {
    let photo: PhotoResult
}
    
//let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//    return formatter
//}()
