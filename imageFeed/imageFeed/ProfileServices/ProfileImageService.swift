
import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let jsonDecoder: JSONDecoder
    private init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURl: String?
    
    func fetchProfileImage(_ token: String, _ completion: @escaping (Result<String, Error>) -> Void){
        guard let request = ImageRequest(token) else{
            completion(.failure(ProfileError.failedToCreateRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request){data, response, error in
            if let error = error{
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
                    let imageResult = try self.jsonDecoder.decode(ProfileResult.self, from: data)
                    let smallImage = imageResult.profileImage.small
                    self.avatarURl = smallImage
                    completion(.success(smallImage))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func ImageRequest(_ token: String) -> URLRequest?{
        guard let request = URLRequest.makeProfileRequest(path: "/me", httpMethod: "GET", token: token) else {
            debugPrint("Не удалось выполнить Imagerequest")
            return nil
        }
        return request
    }
}
