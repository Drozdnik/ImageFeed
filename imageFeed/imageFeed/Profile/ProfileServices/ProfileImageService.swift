
import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderChange")
    static let shared = ProfileImageService()
    private let jsonDecoder: JSONDecoder
    private init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURl: String?
    private let storage = OAuth2TokenStorage()
    
    func fetchProfileImage(userName: String, _ completion: @escaping (Result<String, Error>) -> Void){
        guard let token = getToken() else {return}
        guard let request = ImageRequest(userName: userName, token: token) else{
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
                    let imageResult = try self.jsonDecoder.decode(UserResult.self, from: data)
                    let smallImage = imageResult.profileImage.small
                    self.avatarURl = smallImage
                    DispatchQueue.main.async {
                        completion(.success(smallImage))
                    }
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": smallImage]
                        )
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func ImageRequest(userName:String , token: String) -> URLRequest?{
        guard let request = URLRequest.makeProfileRequest(path: "/users/\(userName)", httpMethod: "GET", token: token) else {
            debugPrint("Не удалось выполнить Imagerequest")
            return nil
        }
        return request
    }
    
    private func getToken() -> String?{
        guard let token = storage.token else {
            return nil
        }
        return token
    }
}
